import RxSwift
import RxCocoa

class SplashViewModel: BaseViewModel {
    
    var input = Input()
    var output = Output()
    var userService: UserServiceProtocol
    var userDefaults: UserDefaultsUtil
    
    struct Input {
        let checkAuth = PublishSubject<Void>()
    }
    
    struct Output {
        let goToSignIn = PublishRelay<Void>()
        let goToMain = PublishRelay<Void>()
    }
    
    
    init(userDefaults: UserDefaultsUtil,
         userService: UserServiceProtocol) {
        self.userDefaults = userDefaults
        self.userService = userService
        
        super.init()
        input.checkAuth.bind { [weak self] (_) in
            guard let self = self else { return }
            
            if !self.userDefaults.isNormalLaunch() || !self.userService.isSessionExisted(){
                self.output.goToSignIn.accept(())
            } else {
                self.output.goToMain.accept(())
            }
        }.disposed(by: disposeBag)
    }
}
