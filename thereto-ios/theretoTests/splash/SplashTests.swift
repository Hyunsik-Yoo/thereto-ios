import XCTest
import RxSwift
import RxTest
import RxBlocking

@testable import thereto

class SplashTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    var viewModel: SplashViewModel!
    var userDefaults: UserDefaultsUtil!
    var schedular: TestScheduler!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        userDefaults = UserDefaultsUtil(name: #file)
        viewModel = SplashViewModel(userDefaults: userDefaults,
                                    userService: UserService())
        schedular = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        disposeBag = nil
        viewModel = nil
        schedular = nil
        userDefaults.instance.removePersistentDomain(forName: #file)
    }

    // 첫 실행일 경우 로그인 화면으로 이동
    func testCheckAuth1() {
        let goToSigninExpectation = schedular.createObserver(Void.self)
        
        viewModel.output.goToSignIn
            .bind(to: goToSigninExpectation)
            .disposed(by: disposeBag)
        
        schedular.createColdObservable([.next(210, ())])
            .bind(to: viewModel.input.checkAuth)
            .disposed(by: disposeBag)
        schedular.start()
        
        XCTAssertEqual(goToSigninExpectation.events.count, 1)
    }
    
    // isNormalLaunch만 true일 경우, 세션이 없으므로 로그인 화면으로 이동해야함
//    func testCheckAuth2() {
//        let goToMainExpectation = schedular.createObserver(Void.self)
//        
//        userDefaults.setNormalLaunch(isNormal: true)
//        viewModel.output.goToMain
//            .bind(to: goToMainExpectation)
//            .disposed(by: disposeBag)
//        
//        schedular.createColdObservable([.next(210, ())])
//            .bind(to: viewModel.input.checkAuth)
//            .disposed(by: disposeBag)
//        schedular.start()
//        
//        XCTAssertEqual(goToMainExpectation.events.count, 1)
//    }
}
