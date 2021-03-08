import RxSwift
import RxCocoa

class WriteViewModel: BaseViewModel {
  
  let input = Input()
  let output = Output()
  
  let userDefaults: UserDefaultsUtil
  let letterService: LetterServiceProtocol
  let userService: UserServiceProtocol
  
  let myInfoPublisher = PublishSubject<User>()
  
  struct Input {
    let tapSentButton = PublishSubject<Void>()
    let mainImage = BehaviorSubject<UIImage?>(value: nil)
    let location = BehaviorSubject<Location?>(value: nil)
    let friend = BehaviorSubject<Friend?>(value: nil)
    let message = PublishSubject<String>()
  }
  
  struct Output {
    let friendName = PublishRelay<String>()
    let locationName = PublishRelay<String>()
    let showLoading = PublishRelay<Bool>()
    let showAlert = PublishRelay<AlertContents>()
    let showToast = PublishRelay<String>()
    let dismiss = PublishRelay<Void>()
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
    self.fetchMyInfo()
    
    input.friend.bind { [weak self] friend in
      guard let self = self else { return }
      if let friend = friend {
        self.output.friendName.accept(friend.nickname)
      }
    }.disposed(by: disposeBag)
    
    input.location.bind { [weak self] location in
      guard let self = self else { return }
      if let location = location {
        self.output.locationName.accept("\(location.name) (\(location.addr))")
      }
    }.disposed(by: disposeBag)
    
    input.tapSentButton
      .withLatestFrom(Observable.combineLatest(
        myInfoPublisher,
        input.mainImage,
        input.location,
        input.friend,
        input.message
      ))
      .bind { [weak self] (myInfo, mainImage, location, friend, message) in
        guard let self = self else { return }
        
        if !self.isValidate(friend: friend) {
          self.output.showToast.accept("write_toast_friend".localized)
          return
        }
        
        if !self.isValidate(location: location) {
          self.output.showToast.accept("write_toast_location".localized)
          return
        }
        
        if !self.isValidate(image: mainImage) {
          self.output.showToast.accept("write_toast_image".localized)
          return
        }
        
        if !self.isValidate(message: message) {
          self.output.showToast.accept("write_placeholder_message".localized)
          return
        }
        
        self.sendLetter(
          myInfo: myInfo,
          image: mainImage!,
          location: location!,
          friend: friend!,
          message: message
        )
    }.disposed(by: disposeBag)
  }
  
  private func fetchMyInfo() {
    self.userService
      .getUserInfo(token: self.userDefaults.getUserToken()!)
      .subscribe(
        onNext: self.myInfoPublisher.onNext,
        onError: { [weak self] error in
          guard let self = self else { return }
          let alertContents = AlertContents(title: "유저 정보 조회 오류", message: error.localizedDescription)
          self.output.showAlert.accept(alertContents)
      }).disposed(by: disposeBag)
  }
  
  private func isValidate(friend: Friend?) -> Bool { return friend != nil }
  
  private func isValidate(location: Location?) -> Bool { return location != nil }
  
  private func isValidate(image: UIImage?) -> Bool { return image != nil }
  
  private func isValidate(message: String) -> Bool {
    return !message.isEmpty && message != "write_placeholder_message".localized
  }
  
  private func sendLetter(
    myInfo: User,
    image: UIImage,
    location: Location,
    friend: Friend,
    message: String
  ) {
    let imageName = "\(self.userDefaults.getUserToken()!)\(DateUtil.date2String(date: Date()))"
    
    self.output.showLoading.accept(true)
    self.letterService
      .saveLetterImage(image: image, name: imageName)
      .subscribe(
        onNext: { [weak self] url in
          guard let self = self else { return }
          let letter = Letter(
            from: myInfo,
            to: friend,
            location: location,
            photo: url,
            message: message)
          
          self.letterService.sendLetter(letter: letter).subscribe(
            onNext: { [weak self] _ in
              guard let self = self else { return }
              self.letterService.increaseSentCount(userId: self.userDefaults.getUserToken()!)
              self.letterService.increaseReceiveCount(userId: friend.id)
              self.letterService.increaseFriendCount(userId: friend.id)
              self.userService.insertAlarm(userId: friend.id, type: .NEW_LETTER)
              self.output.showLoading.accept(false)
              self.output.dismiss.accept(())
          },
            onError: { [weak self] error in
              guard let self = self else { return }
              let alertContents = AlertContents(title: "편지 보내기 오류", message: error.localizedDescription)
              
              self.output.showLoading.accept(false)
              self.output.showAlert.accept(alertContents)
          })
            .disposed(by: self.disposeBag)
      },
        onError: { [weak self] error in
          guard let self = self else { return }
          let alertContents = AlertContents(title: "편지 이미지 저장 오류", message: error.localizedDescription)
          
          self.output.showLoading.accept(false)
          self.output.showAlert.accept(alertContents)
      })
      .disposed(by: disposeBag)
  }
  
}
