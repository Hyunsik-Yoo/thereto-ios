import RxSwift
import RxCocoa

class SentLetterViewModel: BaseViewModel {
  
  let input = Input()
  let output = Output()
  
  var userDefaults: UserDefaultsUtil
  var letterService: LetterServiceProtocol
  
  struct Input {
    let tapLetter = PublishSubject<Int>()
  }
  
  struct Output {
    let letters = PublishRelay<[Letter]>()
    let showLoading = PublishRelay<Bool>()
    let showAlert = PublishRelay<AlertContents>()
    let goToLetterDetail = PublishRelay<Letter>()
  }
  
  
  init(userDefaults: UserDefaultsUtil, letterService: LetterServiceProtocol) {
    self.userDefaults = userDefaults
    self.letterService = letterService
    super.init()
    
    input.tapLetter
      .withLatestFrom(output.letters) { $1[$0] }
      .bind(onNext: { (letter) in
        if letter.isRead {
          self.output.goToLetterDetail.accept(letter)
        } else {
          let alertContents = AlertContents(
            title: nil,
            message: "sent_letter_not_read_message".localized
          )
          
          self.output.showAlert.accept(alertContents)
        }
      })
      .disposed(by: disposeBag)
  }
  
  func getSentLetters() {
    let senderId = self.userDefaults.getUserToken()!
    
    self.output.showLoading.accept(true)
    self.letterService
      .getSentLetters(senderId: senderId)
      .subscribe(
        onNext: { [weak self] letters in
          guard let self = self else { return }
          self.output.letters.accept(letters)
          self.output.showLoading.accept(false)
        },
        onError: { error in
          if let error = error as? CommonError {
            let alertContents = AlertContents(title: "보낸 편지 조회 오류", message: error.description)
            
            self.output.showAlert.accept(alertContents)
          }
          self.output.showLoading.accept(false)
      }).disposed(by: disposeBag)
  }
}
