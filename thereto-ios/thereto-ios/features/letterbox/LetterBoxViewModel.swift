import RxSwift
import CoreLocation

class LetterBoxViewModel: BaseViewModel {
    var input: Input
    var output: Output
    var userDefaults: UserDefaultsProtocol
    var letterService: LetterServiceProtocol
    var userService: UserServiceProtocol
    
    struct Input {
        var getLetters: AnyObserver<Void>
        var setupLocationManager: AnyObserver<Void>
        var myLocation: AnyObserver<CLLocation>
        var selectItem: AnyObserver<Int>
    }
    
    struct Output {
        var letters: Observable<[Letter]>
        var showAlerts: Observable<(String, String)>
        var showLoading: Observable<Bool>
        var showLocationError: Observable<Void>
        var goToLetterDetail: Observable<Letter>
        var showFarAway: Observable<(Letter, CLLocation)>
    }
    
    let getLettersPublisher = PublishSubject<Void>()
    let setupLocationManagerPublisher = PublishSubject<Void>()
    let myLocationPublisher = PublishSubject<CLLocation>()
    let selectItemPublisher = PublishSubject<Int>()
    
    let lettersPublisher = PublishSubject<[Letter]>()
    let showAlertsPublisher = PublishSubject<(String, String)>()
    let showLoadingPublisher = PublishSubject<Bool>()
    let showLocationErrorPublisher = PublishSubject<Void>()
    let goToLetterDetailPublisher = PublishSubject<Letter>()
    let showFarAwayPublisher = PublishSubject<(Letter, CLLocation)>()
    
    // 위치 관련 변수
    private var locationManager = CLLocationManager()
    
    init(userDefaults: UserDefaultsProtocol,
         letterService: LetterServiceProtocol,
         userService: UserServiceProtocol) {
        self.userDefaults = userDefaults
        self.letterService = letterService
        self.userService = userService
        
        input = Input(getLetters: getLettersPublisher.asObserver(),
                      setupLocationManager: setupLocationManagerPublisher.asObserver(),
                      myLocation: myLocationPublisher.asObserver(),
                      selectItem: selectItemPublisher.asObserver())
        output = Output(letters: lettersPublisher,
                        showAlerts: showAlertsPublisher,
                        showLoading: showLoadingPublisher,
                        showLocationError: showLocationErrorPublisher,
                        goToLetterDetail: goToLetterDetailPublisher,
                        showFarAway: showFarAwayPublisher)
        super.init()
        
        setupLocationManagerPublisher.bind { [weak self] (_) in
            guard let self = self else { return }
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }.disposed(by: disposeBag)
        
        getLettersPublisher.bind { [weak self] (_) in
            guard let self = self else { return }
            let token = self.userDefaults.getUserToken()
            
            self.showLoadingPublisher.onNext(true)
            letterService.getLetters(receiverId: token) { (lettersObservable) in
                lettersObservable.subscribe(onNext: { (letters) in
                    // 튜토리얼카드 삭제하지 않았을 경우에는 튜토리얼 카드 추가
                    if !userDefaults.isTutorialFinished() {
                        userService.getUserInfo(token: userDefaults.getUserToken()) { [weak self] (userObservable) in
                            guard let self = self else { return }
                            userObservable.subscribe(onNext: { (user) in
                                var letters = letters
                                let tutorialLetter = self.createTutorialCard(user: user)
                                letters.append(tutorialLetter)
                                self.lettersPublisher.onNext(letters)
                                self.showLoadingPublisher.onNext(false)
                            }, onError: { (error) in
                                self.showAlertsPublisher.onNext(("내정보 조회 오류", error.localizedDescription))
                                self.showLoadingPublisher.onNext(false)
                            }).disposed(by: self.disposeBag)
                        }
                    } else {
                        self.lettersPublisher.onNext(letters)
                        self.showLoadingPublisher.onNext(false)
                    }
                }, onError: { (error) in
                    self.showAlertsPublisher.onNext(("편지 조회 오류", error.localizedDescription))
                    self.showLoadingPublisher.onNext(false)
                }).disposed(by: self.disposeBag)
            }
            
            
        }.disposed(by: disposeBag)
        
        selectItemPublisher.withLatestFrom(Observable.combineLatest(selectItemPublisher, lettersPublisher, myLocationPublisher))
            .bind(onNext: { [weak self] (index, letters, myLocation) in
                guard let self = self else { return }
                
                // 위,경도 0,0 일경우는 권한문제이므로 에러 표시
                if myLocation.coordinate.latitude == 0 && myLocation.coordinate.longitude == 0 {
                    self.showLocationErrorPublisher.onNext(())
                } else {
                    let letter = letters[index]
                    
                    if letter.id == "tutorial" || letter.isRead {
                        self.goToLetterDetailPublisher.onNext(letter)
                    } else {
                        // 거리 계산해서 300 안에 있으면 들어가고 아니면 오류창 출력
                        if self.getDistance(location: letter.location, location2: myLocation) <= 300 {
                            self.goToLetterDetailPublisher.onNext(letter)
                        } else {
                            self.showFarAwayPublisher.onNext((letter, myLocation))
                        }
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
    
    
    private func getDistance(location: Location, location2: CLLocation) -> Int {
        let letterLocation = CLLocation.init(latitude: location.latitude, longitude: location.longitude)
        
        return Int(location2.distance(from: letterLocation))
    }
    
    private func createTutorialCard(user: User) -> Letter {
        let thereto = User.init(nickname: "thereto", social: "facebook", id: "tutorial", profileURL: "")
        let me = Friend.init(nickname: user.nickname, social: user.getSocial(), id: user.id, profileURL: user.profileURL!)
        let location = Location.init(name: "데얼투", addr: "서울 강남구 삼성로85길 26", latitude: 37.504884, longitude: 127.055053)
        var letter = Letter.init(from: thereto, to: me, location: location, photo: "https://firebasestorage.googleapis.com/v0/b/there-to.appspot.com/o/img%402x.png?alt=media&token=cdab7112-0702-490f-8d82-eac91213f044", message: "\(user.nickname)님, thereto에 오신것을 환영합니다. 특별한 장소에서 친구에게특별한 엽서를 남겨보세요.\n친구는 해당 장소에 도착해야지만 엽서를 볼 수 있습니다.\n\n감사합니다.", createdAt: user.createdAt)
        
        letter.id = "tutorial"
        
        return letter
    }
}

extension LetterBoxViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.myLocationPublisher.onNext(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if (error as NSError).code == 1 {
            self.showLocationErrorPublisher.onNext(())
            self.myLocationPublisher.onNext(CLLocation(latitude: 0, longitude: 0))
        } else {
            self.showAlertsPublisher.onNext(("LocationManager error", error.localizedDescription))
        }
    }
}

