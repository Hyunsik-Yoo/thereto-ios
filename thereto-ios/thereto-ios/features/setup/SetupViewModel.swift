import RxSwift
import FBSDKLoginKit
import FBSDKCoreKit

class SetupViewModel: BaseViewModel {
    
    var userService: UserServiceProtocol
    var userDefaults: UserDefaultsUtil
    var input: Input
    var output: Output
    
    struct Input {
        var profileImage: AnyObserver<UIImage>
        var logout: AnyObserver<Void>
    }
    
    struct Output {
        var userInfo: Observable<User>
        var profile: Observable<String>
        var showLoading: Observable<Bool>
        var showAlert: Observable<(String, String)>
        var goToSignIn: Observable<Void>
    }
    
    let profileImagePublisher = PublishSubject<UIImage>()
    let logoutPublisher = PublishSubject<Void>()
    let userInfoPublisher = PublishSubject<User>()
    let profilePublisher = PublishSubject<String>()
    let showLoadingPublisher = PublishSubject<Bool>()
    let showAlertPublisher = PublishSubject<(String, String)>()
    let goToSignInPublisher = PublishSubject<Void>()
    
    
    init(userService: UserServiceProtocol,
         userDefaults: UserDefaultsUtil) {
        self.userService = userService
        self.userDefaults = userDefaults
        input = Input(profileImage: profileImagePublisher.asObserver(),
                      logout: logoutPublisher.asObserver())
        output = Output(userInfo: userInfoPublisher,
                        profile: profilePublisher,
                        showLoading: showLoadingPublisher,
                        showAlert: showAlertPublisher,
                        goToSignIn: goToSignInPublisher)
        super.init()
        
        profileImagePublisher.bind { [weak self] (profileImage) in
            guard let self = self else { return }
            self.showLoadingPublisher.onNext(true)
            self.userService.updateProfileURL(userId: userDefaults.getUserToken()!, image: profileImage) { (urlObservable) in
                urlObservable.subscribe(onNext: { (profileURL) in
                    self.profilePublisher.onNext(profileURL)
                    self.showLoadingPublisher.onNext(false)
                }, onError: { (error) in
                    if let error = error as? CommonError {
                        self.showAlertPublisher.onNext(("프로필 업데이트 오류", error.description))
                    } else {
                        self.showAlertPublisher.onNext(("프로필 업데이트 오류", error.localizedDescription))
                    }
                    self.showLoadingPublisher.onNext(false)
                }).disposed(by: self.disposeBag)
            }
        }.disposed(by: disposeBag)
        
        logoutPublisher.withLatestFrom(userInfoPublisher).bind { [weak self] (user) in
            guard let self = self else { return }
            self.userService.deleteFCMToken(userId: user.id)
            self.userDefaults.clearUserToken()
            FirebaseUtil.signOut()
            
            if user.social == .FACEBOOK {
                LoginManager().logOut()
            }
            self.goToSignInPublisher.onNext(())
        }.disposed(by: disposeBag)
    }
    
    func fetchMyInfo() {
        showLoadingPublisher.onNext(true)
        userService.getUserInfo(token: userDefaults.getUserToken()!) { [weak self] (userObservable) in
            guard let self = self else { return }
            userObservable.subscribe(onNext: { (user) in
                self.userInfoPublisher.onNext(user)
                self.showLoadingPublisher.onNext(false)
            }, onError: { (error) in
                if let error = error as? CommonError {
                    self.showAlertPublisher.onNext(("유저 조회 오류", error.description))
                } else {
                    self.showAlertPublisher.onNext(("유저 조회 오류", error.localizedDescription))
                }
                self.showLoadingPublisher.onNext(false)
            }).disposed(by: self.disposeBag)
        }
    }
    
}
