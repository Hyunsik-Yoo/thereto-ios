import RxSwift
import RxCocoa
import AuthenticationServices
import CryptoKit

class SignInViewModel: BaseViewModel {
    
    let input = Input()
    let output = Output()
    
    var service: UserServiceProtocol
    var userDefaults: UserDefaultsUtil
    
    struct Input {
        let userToken = PublishSubject<(String, String)>()
    }
    
    struct Output {
        let showLoading = PublishRelay<Bool>()
        let showAlert = PublishRelay<(String, String)>()
        let goToMain = PublishRelay<Void>()
        let goToProfile = PublishRelay<(String, String)>()
    }
    
    
    init(service: UserServiceProtocol,
         userDefaults: UserDefaultsUtil) {
        self.service = service
        self.userDefaults = userDefaults
        super.init()
        
        input.userToken.bind { [weak self] (userToken, social) in
            guard let self = self else { return }
            self.output.showLoading.accept(true)
            self.service
                .validateUser(token: userToken)
                .subscribe(onNext: { (isValidated) in
                    if isValidated {
                        self.userDefaults.setUserToken(token: userToken)
                        self.userDefaults.setNormalLaunch(isNormal: true)
                        if let fcmToken = self.userDefaults.getFCMToken() {
                            self.service.updateFCMToken(userId: userToken, fcmToken: fcmToken)
                        }
                        self.output.goToMain.accept(())
                    } else {
                        self.output.goToProfile.accept((userToken, social))
                    }
                    self.output.showLoading.accept(false)
                }, onError: { (error) in
                    self.output.showAlert.accept(("유효성 검사 오류", error.localizedDescription))
                    self.output.showLoading.accept(false)
                }).disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
    }
}
