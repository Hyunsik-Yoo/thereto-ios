import XCTest
import RxSwift
import RxTest
import RxBlocking

@testable import thereto


class SentLetterTests: XCTestCase {
  
  var disposeBag: DisposeBag!
  var viewModel: SentLetterViewModel!
  var userDefaults: UserDefaultsUtil!
  var schedular: TestScheduler!
  
  override func setUp() {
    super.setUp()
    
    disposeBag = DisposeBag()
    userDefaults = UserDefaultsUtil(name: #file)
    viewModel = SentLetterViewModel(
      userDefaults: userDefaults,
      letterService: LetterMockService()
    )
    schedular = TestScheduler(initialClock: 0)
    userDefaults.setUserToken(token: "normal")
  }
  
  override func tearDown() {
    super.tearDown()
    
    disposeBag = nil
    viewModel = nil
    schedular = nil
    userDefaults.instance.removePersistentDomain(forName: #file)
  }
  
  func testFetchSentLetters() {
    let letterExpectation = schedular.createObserver(Array<Letter>.self)
    let showLoadingExpectation = schedular.createObserver(Bool.self)
    
    viewModel.output.letters
      .bind(to: letterExpectation)
      .disposed(by: disposeBag)
    
    viewModel.output.showLoading
      .bind(to: showLoadingExpectation)
      .disposed(by: disposeBag)
    
    viewModel.fetchSentLetters()
    schedular.start()
    
    XCTAssertRecordedElements(showLoadingExpectation.events, [true, false])
    if let letters = letterExpectation.events[0].value.element,
      let firstLetter = letters.first {
      XCTAssertEqual(firstLetter.from.id, "idFrom")
    }
  }
  
  func testGoToLetterDetail() {
    let goToLetterExpectation = schedular.createObserver(Letter.self)
    let from = User(nickname: "보내는사람 닉네임", social: "apple", id: "idFrom", profileURL: "")
    let to = Friend(nickname: "받는사람 닉네임", social: "facebook", id: "idTo", profileURL: "")
    let location = Location(name: "장소 이름", addr: "주소주소", latitude: 0, longitude: 0)
    var letter = Letter(from: from, to: to, location: location, photo: "", message: "메시지 내용")
    letter.isRead = true
    
    viewModel.output.goToLetterDetail
      .bind(to: goToLetterExpectation)
      .disposed(by: disposeBag)
    viewModel.output.letters.accept([letter])
    
    schedular.createColdObservable([.next(210, 0)])
      .bind(to: viewModel.input.tapLetter)
      .disposed(by: disposeBag)
    schedular.start()
    
    if let tapLetter = goToLetterExpectation.events[0].value.element {
      XCTAssertEqual(tapLetter.from.id, "idFrom")
      Log.debug("fdsafdsfdsafsda")
    }
  }
  
  func testNotReadLetter() {
    let alertExpectation = schedular.createObserver(AlertContents.self)
    let from = User(nickname: "보내는사람 닉네임", social: "apple", id: "idFrom", profileURL: "")
    let to = Friend(nickname: "받는사람 닉네임", social: "facebook", id: "idTo", profileURL: "")
    let location = Location(name: "장소 이름", addr: "주소주소", latitude: 0, longitude: 0)
    var letter = Letter(from: from, to: to, location: location, photo: "", message: "메시지 내용")
    letter.isRead = false
    
    viewModel.output.showAlert
      .bind(to: alertExpectation)
      .disposed(by: disposeBag)
    viewModel.output.letters.accept([letter])
    
    schedular.createColdObservable([.next(210, 0)])
      .bind(to: viewModel.input.tapLetter)
      .disposed(by: disposeBag)
    schedular.start()
    
    
    if let alertContent = alertExpectation.events[0].value.element {
      XCTAssertEqual(alertContent.message, "sent_letter_not_read_message".localized)
    }
  }
}
