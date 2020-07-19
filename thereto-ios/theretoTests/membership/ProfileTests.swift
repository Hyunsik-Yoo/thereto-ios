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

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
