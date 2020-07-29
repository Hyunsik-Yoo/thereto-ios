import XCTest
import RxSwift
import RxTest
import RxBlocking
import CoreLocation

@testable import thereto

class LetterboxTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    var viewModel: LetterBoxViewModel!
    var userDefaults: UserDefaultsUtil!
    var schedular: TestScheduler!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        userDefaults = UserDefaultsUtil(name: #file)
        viewModel = LetterBoxViewModel(userDefaults: userDefaults,
                                       letterService: LetterMockService(),
                                       userService: UserMockService())
        schedular = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        disposeBag = nil
        viewModel = nil
        schedular = nil
        userDefaults.instance.removePersistentDomain(forName: #file)
    }
    
    func testFetchLettersWithTutorialLetter() {
        // 튜토리얼 카드가 붙도록 편지 패치
        let letterExpectation = schedular.createObserver(Array<Letter>.self)
        let showLoadingExpectation = schedular.createObserver(Bool.self)
        
        viewModel.output.letters
            .bind(to: letterExpectation)
            .disposed(by: disposeBag)
        viewModel.output.showLoading
            .bind(to: showLoadingExpectation)
            .disposed(by: disposeBag)
        
        userDefaults.setUserToken(token: "normal")
        viewModel.fetchLetters()
        schedular.start()
        
        if let letters = letterExpectation.events[0].value.element,
            let tutorialCard = letters.last {
            XCTAssertEqual(tutorialCard.from.nickname, "thereto")
            XCTAssertEqual(letters.count, 2)
        }
        XCTAssertRecordedElements(showLoadingExpectation.events, [true, false])
    }
    
    func testFetchLettersWithoutTutorialLetter() {
        // 튜토리얼 카드가 없는 상태의 카드 패치
        let letterExpectation = schedular.createObserver(Array<Letter>.self)
        let showLoadingExpectation = schedular.createObserver(Bool.self)
        
        viewModel.output.letters
            .bind(to: letterExpectation)
            .disposed(by: disposeBag)
        viewModel.output.showLoading
            .bind(to: showLoadingExpectation)
            .disposed(by: disposeBag)
        
        userDefaults.setTutorialFinish()
        userDefaults.setUserToken(token: "normal")
        viewModel.fetchLetters()
        schedular.start()
        
        if let letters = letterExpectation.events[0].value.element {
            if let letter = letters.first {
                XCTAssertEqual(letter.from.id, "idFrom")
            }
            XCTAssertEqual(letters.count, 1)
        }
        XCTAssertRecordedElements(showLoadingExpectation.events, [true, false])
    }
    
    func testSelectItemWithLocationError() {
        // 아이템을 선택했을 때, 위,경도가 0,0일경우!
        let locationErrorExpectation = schedular.createObserver(Void.self)
        
        viewModel.output.showLocationError
            .bind(to: locationErrorExpectation)
            .disposed(by: disposeBag)
        
        schedular.createColdObservable([.next(210, createDummyLetters())])
            .bind(to: viewModel.output.letters)
            .disposed(by: disposeBag)
        schedular.createColdObservable([.next(220, 0)])
            .bind(to: viewModel.input.selectItem)
            .disposed(by: disposeBag)
        schedular.createColdObservable([.next(210, CLLocation(latitude: 0, longitude: 0))])
            .bind(to: viewModel.myLocationPublisher)
            .disposed(by: disposeBag)
        schedular.start()
        
        XCTAssertEqual(locationErrorExpectation.events.count, 1)
    }
    
    func testSelectTutorialLetter() {
        // 튜토리얼 편지를 눌렀을 때
        let goToLetterDetailExpectation = schedular.createObserver(Letter.self)
        let user = User(nickname: "nickname", social: "apple", id: "id", profileURL: "")
        let tutorialCard = Letter.createTutorialCard(user: user)
        
        viewModel.output.goToLetterDetail
            .bind(to: goToLetterDetailExpectation)
            .disposed(by: disposeBag)
        
        schedular.createColdObservable([.next(210, [tutorialCard])])
            .bind(to: viewModel.output.letters)
            .disposed(by: disposeBag)
        schedular.createColdObservable([.next(210, CLLocation(latitude: 37.504884, longitude: 127.055053))])
            .bind(to: viewModel.myLocationPublisher)
            .disposed(by: disposeBag)
        schedular.createColdObservable([.next(220, 0)])
            .bind(to: viewModel.input.selectItem)
            .disposed(by: disposeBag)
        schedular.start()
        
        XCTAssertRecordedElements(goToLetterDetailExpectation.events, [tutorialCard])
    }
    
    func testSelectFarLetter() {
        // 거리가 먼 편지를 눌렀을 경우
        let farAwayExpectation = schedular.createObserver((Letter, CLLocation).self)
        
        viewModel.output.showFarAway
            .bind(to: farAwayExpectation)
            .disposed(by: disposeBag)
        
        schedular.createColdObservable([.next(210, createDummyLetters())])
            .bind(to: viewModel.output.letters)
            .disposed(by: disposeBag)
        schedular.createColdObservable([.next(210, CLLocation(latitude: 1, longitude: 1))])
            .bind(to: viewModel.myLocationPublisher)
            .disposed(by: disposeBag)
        schedular.createColdObservable([.next(220, 0)])
            .bind(to: viewModel.input.selectItem)
            .disposed(by: disposeBag)
        schedular.start()
        
        XCTAssertEqual(farAwayExpectation.events.count, 1)
    }
    
    func testSelectNormalLetter() {
        // 일반 편지를 눌렀을 경우
        let goToLetterDetailExpectation = schedular.createObserver(Letter.self)
        
        viewModel.output.goToLetterDetail
            .bind(to: goToLetterDetailExpectation)
            .disposed(by: disposeBag)
        
        schedular.createColdObservable([.next(210, createDummyLetters())])
            .bind(to: viewModel.output.letters)
            .disposed(by: disposeBag)
        schedular.createColdObservable([.next(210, CLLocation(latitude: 37.504884, longitude: 127.055053))])
            .bind(to: viewModel.myLocationPublisher)
            .disposed(by: disposeBag)
        schedular.createColdObservable([.next(220, 0)])
            .bind(to: viewModel.input.selectItem)
            .disposed(by: disposeBag)
        schedular.start()
        
        XCTAssertRecordedElements(goToLetterDetailExpectation.events, createDummyLetters())
    }
    
    func createDummyLetters() -> [Letter] {
        let from = User.init(nickname: "thereto", social: "facebook", id: "tutorial", profileURL: "")
        let to = Friend.init(nickname: "to", social: "facebook", id: "toId", profileURL: "")
        let location = Location.init(name: "데얼투", addr: "서울 강남구 삼성로85길 26", latitude: 37.504884, longitude: 127.055053)
        var letter = Letter.init(from: from, to: to, location: location, photo: "https://firebasestorage.googleapis.com/v0/b/there-to.appspot.com/o/img%402x.png?alt=media&token=cdab7112-0702-490f-8d82-eac91213f044", message: "\(to.nickname)님, thereto에 오신것을 환영합니다. 특별한 장소에서 친구에게특별한 엽서를 남겨보세요.\n친구는 해당 장소에 도착해야지만 엽서를 볼 수 있습니다.\n\n감사합니다.", createdAt: "")
        
        letter.id = "letterId"
        
        return [letter]
    }
}
