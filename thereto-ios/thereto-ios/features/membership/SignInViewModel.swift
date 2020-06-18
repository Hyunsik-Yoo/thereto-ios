import RxSwift
import AuthenticationServices
import CryptoKit

class SignInViewModel: BaseViewModel {
    
    var input: Input
    var output: Output
    var service: UserServiceProtocol
    var userDefaults: UserDefaultsProtocol
    
    fileprivate var currentNonce: String?
    
    struct Input {
        var userToken: AnyObserver<(String, String)>
    }
    
    struct Output {
        var showLoading: Observable<Bool>
        var goToMain: Observable<Void>
        var goToProfile: Observable<(String, String)>
    }
    
    let userTokenPublisher = PublishSubject<(String, String)>()
    let showLoadingPublisher = PublishSubject<Bool>()
    let goToMainPublisher = PublishSubject<Void>()
    let goToProfilePublisher = PublishSubject<(String, String)>()
    
    
    init(service: UserServiceProtocol, userDefaults: UserDefaultsProtocol) {
        self.service = service
        self.userDefaults = userDefaults
        input = Input(userToken: userTokenPublisher.asObserver())
        output = Output(showLoading: showLoadingPublisher,
                        goToMain: goToMainPublisher.asObservable(),
                        goToProfile: goToProfilePublisher.asObservable())
        super.init()
        
        
        userTokenPublisher.bind { [weak self] (userToken, social) in
            guard let self = self else { return }
            self.showLoadingPublisher.onNext(true)
            self.service.validateUser(token: userToken) { (isValidated) in
                if isValidated {
                    self.userDefaults.setUserToken(token: userToken)
                    self.userDefaults.setNormalLaunch(isNormal: true)
                    if let fcmToken = self.userDefaults.getFCMToken() {
                        self.service.updateFCMToken(userId: userToken, fcmToken: fcmToken)
                    }
                    self.goToMainPublisher.onNext(())
                } else {
                    self.goToProfilePublisher.onNext((userToken, social))
                }
                self.showLoadingPublisher.onNext(false)
            }
        }.disposed(by: disposeBag)
    }
}
