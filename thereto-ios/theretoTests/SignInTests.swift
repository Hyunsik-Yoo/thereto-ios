import XCTest
import RxSwift
import RxTest
import RxBlocking

@testable import thereto

class SignInTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    var viewModel: SignInViewModel!
    var userDefaults: UserDefaultsUtil!
    var schedular: TestScheduler!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        userDefaults = UserDefaultsUtil(name: #file)
        viewModel = SignInViewModel(service: UserMockService(),
                                    userDefaults: userDefaults)
        schedular = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        disposeBag = nil
        viewModel = nil
        schedular = nil
        userDefaults.instance.removePersistentDomain(forName: #file)
    }
    
    // 유효한 멤버 토큰 테스트 -> 메인화면으로 이동
    func testValidatedToken() {
        let showLoadingExpectation = schedular.createObserver(Bool.self)
        let goToMainExpectation = schedular.createObserver(Void.self)
        
        viewModel.output.showLoading
            .bind(to: showLoadingExpectation)
            .disposed(by: disposeBag)
        viewModel.output.goToMain
            .bind(to: goToMainExpectation)
            .disposed(by: disposeBag)
        
        // Input 추가
        schedular.createColdObservable([.next(210, ("validate", "apple"))])
            .bind(to: viewModel.input.userToken)
            .disposed(by: disposeBag)
        schedular.start()
        
        XCTAssertRecordedElements(showLoadingExpectation.events, [true, false])
        XCTAssertEqual(goToMainExpectation.events.count, 1)
    }
    
    func tesInvalidatedToken() {
        let showLoadingExpectation = schedular.createObserver(Bool.self)
        let goToProfileExpectation = schedular.createObserver((String, String).self)
        
        viewModel.output.showLoading
            .bind(to: showLoadingExpectation)
            .disposed(by: disposeBag)
        viewModel.output.goToProfile
            .bind(to: goToProfileExpectation)
            .disposed(by: disposeBag)
        
        // Input 추가
        schedular.createColdObservable([.next(210, ("", "apple"))])
            .bind(to: viewModel.input.userToken)
            .disposed(by: disposeBag)
        schedular.start()
        
        XCTAssertRecordedElements(showLoadingExpectation.events, [true, false])
        XCTAssertEqual(goToProfileExpectation.events.count, 1)
    }
}
