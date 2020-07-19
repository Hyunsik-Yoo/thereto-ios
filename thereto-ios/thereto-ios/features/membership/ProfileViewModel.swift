import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel: BaseViewModel {
    
    let input = Input()
    let output = Output()
    
    var facebookManager: FaceboookManagerProtocol
    var userService: UserServiceProtocol
    var userDefaults: UserDefaultsUtil
    
    struct Input {
        let nicknameText = PublishSubject<String>()
        let tapConfirm = PublishSubject<Void>()
        let getProfileEvent = PublishSubject<Void>()
    }
    
    struct Output {
        let showLoading = PublishRelay<Bool>()
        let socialNickname = PublishRelay<String>()
        let errorMsg = PublishRelay<String>()
        let profileImage = PublishSubject<String?>()
        let showAlert = PublishRelay<String>()
        let goToMain = PublishRelay<Void>()
    }
    
    let idSocialPublisher = PublishSubject<(String, String)>()
    
    
    init(facebookManager: FaceboookManagerProtocol,
         userService: UserServiceProtocol,
         userDefaults: UserDefaultsUtil) {
        self.facebookManager = facebookManager
        self.userService = userService
        self.userDefaults = userDefaults
        
        super.init()
        
        // 페북으로 로그인 했다면 소셜에 저장된 프로필 사진 가지고 오기
        input.getProfileEvent
            .withLatestFrom(idSocialPublisher)
            .bind { [weak self] (id, social) in
                guard let self = self else { return }
                if social == "facebook" { // 애플로그인으로 접근할 경우에는 사진이 제공되지 않음
                    self.facebookManager.getFBProfile(id: id).subscribe(onNext: { (name, profileURL) in
                        self.output.socialNickname.accept(name)
                        self.output.profileImage.onNext(profileURL)
                    }, onError: { (error) in
                        self.output.showAlert.accept(error.localizedDescription)
                    }).disposed(by: self.disposeBag)
                } else {
                    self.output.profileImage.onNext("")
                }
        }.disposed(by: disposeBag)
        
        input.tapConfirm
            .withLatestFrom(Observable.combineLatest(input.nicknameText, output.profileImage, idSocialPublisher))
            .bind { [weak self] (nickname, profileURL, idSocial) in
                guard let self = self else { return }
                if !nickname.isEmpty {
                    let user = User(nickname: nickname, social: idSocial.1, id: idSocial.0, profileURL: profileURL)
                    
                    self.output.showLoading.accept(true)
                    self.userService.signUp(user: user).subscribe(onNext: { (user) in
                        // 메인 화면으로 이동
                        self.userDefaults.setUserToken(token: user.id)
                        self.userDefaults.setNormalLaunch(isNormal: true) // 다시 로그인할때는 메인으로 돌아가도록
                        if let fcmToken = self.userDefaults.getFCMToken() {
                            self.userService.updateFCMToken(userId: user.id, fcmToken: fcmToken)
                        }
                        self.output.goToMain.accept(())
                        self.output.showLoading.accept(false)
                    }, onError: { (error) in
                        if let error = error as? CommonError {
                            self.output.showAlert.accept(error.description)
                        } else {
                            self.output.showAlert.accept(error.localizedDescription)
                        }
                        self.output.showLoading.accept(false)
                    }).disposed(by: self.disposeBag)
                } else {
                    self.output.errorMsg.accept("닉네임을 설정해주세요.")
                }
        }.disposed(by: disposeBag)
    }
}
