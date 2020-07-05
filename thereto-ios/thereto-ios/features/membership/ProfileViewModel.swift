import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel: BaseViewModel {
    
    var input: Input
    var output: Output
    
    var id: String
    var social: String
    
    var facebookManager: FaceboookManagerProtocol
    var userService: UserServiceProtocol
    var userDefaults: UserDefaultsProtocol
    
    struct Input {
        var nicknameText: AnyObserver<String>
        var tapConfirm: AnyObserver<Void>
        var getProfileEvent: AnyObserver<Void>
    }
    
    struct Output {
        var showLoading: Observable<Bool>
        var socialNickname: Observable<String>
        var errorMsg: Observable<String>
        var profileImage: Observable<String?>
        var showAlert: Observable<String>
        var goToMain: Observable<Void>
    }
    
    let nicknameTextPublisher = PublishSubject<String>()
    let tapConfirmPublisher = PublishSubject<Void>()
    let getProfileEventPublisher = PublishSubject<Void>()
    
    let showLoadingPublisher = PublishSubject<Bool>()
    let socialNicknamePublisher = PublishSubject<String>()
    let errorMsgPublisher = PublishSubject<String>()
    let profileImagePublisher = PublishSubject<String?>()
    let showAlertPublisher = PublishSubject<String>()
    let goToMainPublisher = PublishSubject<Void>()
    
    init(id: String, social: String,
         facebookManager: FaceboookManagerProtocol,
         userService: UserServiceProtocol,
         userDefaults: UserDefaultsProtocol) {
        self.id = id
        self.social = social
        self.facebookManager = facebookManager
        self.userService = userService
        self.userDefaults = userDefaults
        
        input = Input(nicknameText: nicknameTextPublisher.asObserver(),
                      tapConfirm: tapConfirmPublisher.asObserver(),
                      getProfileEvent: getProfileEventPublisher.asObserver())
        
        output = Output(showLoading: showLoadingPublisher.asObservable(),
                        socialNickname: socialNicknamePublisher.asObservable(),
                        errorMsg: errorMsgPublisher.asObservable(),
                        profileImage: profileImagePublisher.asObservable(),
                        showAlert: showAlertPublisher.asObservable(),
                        goToMain: goToMainPublisher.asObservable())
        super.init()
        
        // 페북으로 로그인 했다면 소셜에 저장된 프로필 사진 가지고 오기
        getProfileEventPublisher.bind { (_) in
            if social == "facebook" { // 애플로그인으로 접근할 경우에는 사진이 제공되지 않음
                facebookManager.getFBProfile(id: id) { [weak self] (infoObservable) in
                    guard let self = self else { return }
                    infoObservable.subscribe(onNext: { (name, profileURL) in
                        self.socialNicknamePublisher.onNext(name)
                        self.profileImagePublisher.onNext(profileURL)
                    }, onError: { (error) in
                        self.showAlertPublisher.onNext(error.localizedDescription)
                    }).disposed(by: self.disposeBag)
                }
            } else {
                self.profileImagePublisher.onNext("")
            }
        }.disposed(by: disposeBag)
        
        tapConfirmPublisher.withLatestFrom(Observable.combineLatest(nicknameTextPublisher, profileImagePublisher))
            .bind { [weak self] (nickname, profileURL) in
                guard let self = self else { return }
                if !nickname.isEmpty {
                    let user = User(nickname: nickname, social: social, id: id, profileURL: profileURL)
                    
                    self.showLoadingPublisher.onNext(true)
                    userService.signUp(user: user) { (userObservable) in
                        userObservable.subscribe(onNext: { (user) in
                            // 메인 화면으로 이동
                            self.userDefaults.setUserToken(token: user.id)
                            self.userDefaults.setNormalLaunch(isNormal: true) // 다시 로그인할때는 메인으로 돌아가도록
                            if let fcmToken = self.userDefaults.getFCMToken() {
                                self.userService.updateFCMToken(userId: user.id, fcmToken: fcmToken)
                            }
                            self.goToMainPublisher.onNext(())
                            self.showLoadingPublisher.onNext(false)
                        }, onError: { (error) in
                            if let error = error as? CommonError {
                                self.showAlertPublisher.onNext(error.description)
                            } else {
                                self.showAlertPublisher.onNext(error.localizedDescription)
                            }
                            self.showLoadingPublisher.onNext(false)
                        }).disposed(by: self.disposeBag)
                    }
                } else {
                    self.errorMsgPublisher.onNext("닉네임을 설정해주세요.")
                }
        }.disposed(by: disposeBag)
    }
}
