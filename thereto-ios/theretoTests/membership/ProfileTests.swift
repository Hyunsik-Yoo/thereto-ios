import XCTest
import RxSwift
import RxTest
import RxBlocking

@testable import thereto

class ProfileTests: XCTestCase {

    var disposeBag: DisposeBag!
    var viewModel: ProfileViewModel!
    var userDefaults: UserDefaultsUtil!
    var schedular: TestScheduler!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        userDefaults = UserDefaultsUtil(name: #file)
        viewModel = ProfileViewModel(facebookManager: FacebookMockManager(),
                                     userService: UserMockService(),
                                     userDefaults: userDefaults)
        schedular = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        disposeBag = nil
        viewModel = nil
        schedular = nil
        userDefaults.instance.removePersistentDomain(forName: #file)
    }
    
    func testFBProfileEvent() {
        let socialNameExpectation = schedular.createObserver(String.self)
        let profileImageExpectation = schedular.createObserver(String?.self)
        
        viewModel.output.socialNickname
            .bind(to: socialNameExpectation)
            .disposed(by: disposeBag)
        viewModel.output.profileImage
            .bind(to: profileImageExpectation)
            .disposed(by: disposeBag)
        
        // Input 추가
        schedular.createColdObservable([.next(210, ("id","facebook"))])
            .bind(to: viewModel.idSocialPublisher)
            .disposed(by: disposeBag)
        schedular.createColdObservable([.next(220, ())])
            .bind(to: viewModel.input.getProfileEvent)
            .disposed(by: disposeBag)
        schedular.start()
        
        XCTAssertRecordedElements(socialNameExpectation.events, ["name"])
        XCTAssertRecordedElements(profileImageExpectation.events, ["url"])
    }
    
    
    func testAppleProfileEvent() {
        let profileImageExpectation = schedular.createObserver(String?.self)
        
        viewModel.output.profileImage
            .bind(to: profileImageExpectation)
            .disposed(by: disposeBag)
        
        // Input 추가
        schedular.createColdObservable([.next(210, ("id","apple"))])
            .bind(to: viewModel.idSocialPublisher)
            .disposed(by: disposeBag)
        schedular.createColdObservable([.next(220, ())])
            .bind(to: viewModel.input.getProfileEvent)
            .disposed(by: disposeBag)
        schedular.start()
        
        XCTAssertRecordedElements(profileImageExpectation.events, [""])
    }
    
    func testSignUpWithEmptyName() {
        let errorMsgExpectation = schedular.createObserver(String.self)
        let showLoadingExpectation = schedular.createObserver(Bool.self)
        
        viewModel.output.errorMsg
            .bind(to: errorMsgExpectation)
            .disposed(by: disposeBag)
        viewModel.output.showLoading
            .bind(to: showLoadingExpectation)
            .disposed(by: disposeBag)
        
        // Input 추가
        schedular.createColdObservable([.next(210, "")])
            .bind(to: viewModel.input.nicknameText)
            .disposed(by: disposeBag)
        schedular.createColdObservable([.next(220, "312")])
            .bind(to: viewModel.output.profileImage)
            .disposed(by: disposeBag)
        schedular.createColdObservable([.next(230, ("id", "facebook"))])
            .bind(to: viewModel.idSocialPublisher)
            .disposed(by: disposeBag)
        schedular.createColdObservable([.next(240, ())])
            .bind(to: viewModel.input.tapConfirm)
            .disposed(by: disposeBag)
        
        XCTAssertRecordedElements(errorMsgExpectation.events, ["닉네임을 설정해주세요."])
    }
}
