import RxSwift
import RxCocoa
import CoreLocation

class LetterBoxViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    var userDefaults: UserDefaultsUtil
    var letterService: LetterServiceProtocol
    var userService: UserServiceProtocol
    
    struct Input {
        var selectItem = PublishSubject<Int>()
    }
    
    struct Output {
        var letters = PublishRelay<[Letter]>()
        var showAlerts = PublishRelay<(String, String)>()
        var showLoading = PublishRelay<Bool>()
        var showLocationError = PublishRelay<Void>()
        var goToLetterDetail = PublishRelay<Letter>()
        var showFarAway = PublishRelay<(Letter, CLLocation)>()
    }
    
    // 위치 관련 변수
    private var locationManager = CLLocationManager()
    private let myLocationPublisher = PublishSubject<CLLocation>()
    
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
    
    init(userDefaults: UserDefaultsUtil,
         letterService: LetterServiceProtocol,
         userService: UserServiceProtocol) {
        self.userDefaults = userDefaults
        self.letterService = letterService
        self.userService = userService
        
        super.init()
        
        input.selectItem.withLatestFrom(output.letters) { $1[$0] }
            .withLatestFrom(myLocationPublisher) { ($0, $1) }
            .bind { [weak self] (letter, myLocation) in
                guard let self = self else { return }
                // 위,경도 0,0 일경우는 권한문제이므로 에러 표시
                if myLocation.coordinate.latitude == 0 && myLocation.coordinate.longitude == 0 {
                    self.output.showLocationError.accept(())
                } else {
                    if letter.id == "tutorial" || letter.isRead {
                        self.output.goToLetterDetail.accept(letter)
                    } else {
                        // 거리 계산해서 300 안에 있으면 들어가고 아니면 오류창 출력
                        if self.getDistance(location: letter.location, location2: myLocation) <= 300 {
                            self.output.goToLetterDetail.accept(letter)
                        } else {
                            self.output.showFarAway.accept((letter, myLocation))
                        }
                    }
                }
        }.disposed(by: disposeBag)
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func fetchLetters() {
        let token = userDefaults.getUserToken()!
        
        output.showLoading.accept(true)
        letterService.fetchLetters(receiverId: token)
            .subscribe(onNext: { [weak self] (letters) in
                guard let self = self else { return }
                // 튜토리얼 카드를 지우지 않았다면 맨 마지막에 튜토리얼 카드 붙여주기
                if !self.userDefaults.isTutorialFinished() {
                    self.userService
                        .getUserInfo(token: token)
                        .subscribe(onNext: { (user) in
                            var letters = letters
                            let tutorialLetter = self.createTutorialCard(user: user)
                            
                            letters.append(tutorialLetter)
                            self.output.letters.accept(letters)
                            self.output.showLoading.accept(false)
                        }, onError: { (error) in
                            if let error = error as? CommonError {
                                self.output.showAlerts.accept(("내정보 조회 오류", error.description))
                            } else {
                                self.output.showAlerts.accept(("내정보 조회 오류", error.localizedDescription))
                            }
                            self.output.showLoading.accept(false)
                        }).disposed(by: self.disposeBag)
                } else {
                    self.output.letters.accept(letters)
                    self.output.showLoading.accept(false)
                }}, onError: { [weak self] (error) in
                    guard let self = self else { return }
                    if let error = error as? CommonError {
                        self.output.showAlerts.accept(("편지 조회 오류", error.description))
                    } else {
                        self.output.showAlerts.accept(("편지 조회 오류", error.localizedDescription))
                    }
                    self.output.showLoading.accept(false)
            }).disposed(by: disposeBag)
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
            self.output.showLocationError.accept(())
            self.myLocationPublisher.onNext(CLLocation(latitude: 0, longitude: 0))
        } else {
            self.output.showAlerts.accept(("위치 에러", error.localizedDescription))
        }
    }
}

