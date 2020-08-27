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
    let selectItem = PublishSubject<Int>()
  }
  
  struct Output {
    let letters = PublishRelay<[Letter]>()
    let showAlerts = PublishRelay<AlertContents>()
    let showLoading = PublishRelay<Bool>()
    let showLocationError = PublishRelay<Void>()
    let goToLetterDetail = PublishRelay<Letter>()
    let showFarAway = PublishRelay<(Letter, CLLocation)>()
  }
  
  // 위치 관련 변수
  private var locationManager = CLLocationManager()
  let myLocationPublisher = PublishSubject<CLLocation>()
  
  
  deinit {
    locationManager.stopUpdatingLocation()
  }
  
  init(
    userDefaults: UserDefaultsUtil,
    letterService: LetterServiceProtocol,
    userService: UserServiceProtocol
  ) {
    self.userDefaults = userDefaults
    self.letterService = letterService
    self.userService = userService
    
    super.init()
    
    input.selectItem
      .withLatestFrom(output.letters) { $1[$0] }
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
      .subscribe(
        onNext: { [weak self] letters in
          guard let self = self else { return }
          // 튜토리얼 카드를 지우지 않았다면 맨 마지막에 튜토리얼 카드 붙여주기
          if !self.userDefaults.isTutorialFinished() {
            self.appendTutorialCard(letters: letters)
          } else {
            self.output.letters.accept(letters)
            self.output.showLoading.accept(false)
          }},
        onError: { [weak self] error in
          guard let self = self else { return }
          if let error = error as? CommonError {
            let alertContents = AlertContents(title: "편지 조회 오류", message: error.description)
            
            self.output.showAlerts.accept(alertContents)
          }
          self.output.showLoading.accept(false)
      }).disposed(by: disposeBag)
  }
  
  private func appendTutorialCard(letters: [Letter]) {
    self.userService
      .getUserInfo(token: self.userDefaults.getUserToken()!)
      .subscribe(
        onNext: { user in
          let tutorialLetter = Letter.createTutorialCard(user: user)
          
          self.output.letters.accept(letters + [tutorialLetter])
          self.output.showLoading.accept(false)
      },
        onError: { (error) in
          if let error = error as? CommonError {
            let alertContents = AlertContents(title: "내 정보 조회 오류", message: error.description)
            
            self.output.showAlerts.accept(alertContents)
          }
          self.output.showLoading.accept(false)
      }).disposed(by: self.disposeBag)
  }
  
  
  private func getDistance(location: Location, location2: CLLocation) -> Int {
    let letterLocation = CLLocation.init(
      latitude: location.latitude,
      longitude: location.longitude
    )
    
    return Int(location2.distance(from: letterLocation))
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
      let alertContents = AlertContents(title: "위치 에러", message: error.localizedDescription)
      
      self.output.showAlerts.accept(alertContents)
    }
  }
}

