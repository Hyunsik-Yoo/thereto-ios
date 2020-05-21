import RxSwift

class SplashViewModel: BaseViewModel {
    
    var input: Input
    var output: Output
    var userService: UserServiceProtocol
    var userDefaults: UserDefaultsProtocol
    
    struct Input {
        var checkAuth: AnyObserver<Void>
    }
    
    struct Output {
        var goToSignIn: Observable<Void>
        var goToMain: Observable<Void>
    }
    
    let checkAuthPublisher = PublishSubject<Void>()
    let goToSignInPublisher = PublishSubject<Void>()
    let goToMainPublisher = PublishSubject<Void>()
    
    init(userDefaults: UserDefaultsProtocol,
         userService: UserServiceProtocol) {
        self.userDefaults = userDefaults
        self.userService = userService
        input = Input(checkAuth: checkAuthPublisher.asObserver())
        output = Output(goToSignIn: goToSignInPublisher.asObservable(),
                        goToMain: goToMainPublisher.asObservable())
        
        super.init()
        checkAuthPublisher.bind { [weak self] (_) in
            guard let self = self else { return }
            
            if !self.userDefaults.isNormalLaunch() || !self.userService.isSessionExisted(){
                self.goToSignInPublisher.onNext(())
            } else {
                self.goToMainPublisher.onNext(())
            }
        }.disposed(by: disposeBag)
    }
}
