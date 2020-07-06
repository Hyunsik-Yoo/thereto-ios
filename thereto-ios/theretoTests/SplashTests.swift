import XCTest
import RxSwift

@testable import thereto

class SplashTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    var viewModel: SplashViewModel!
    var userDefaults: UserDefaultsUtil!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        userDefaults = UserDefaultsUtil(name: #file)
        viewModel = SplashViewModel(userDefaults: userDefaults,
                                    userService: UserService())
    }
    
    override func tearDown() {
        disposeBag = nil
        viewModel = nil
        userDefaults.instance.removePersistentDomain(forName: #file)
    }

    func testExample() {
        XCTAssert(true)
    }
}
