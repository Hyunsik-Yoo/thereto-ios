import UIKit
import FBSDKCoreKit
import RxSwift

class ProfileVC: BaseVC {
    
    private lazy var profileView = ProfileView(frame: self.view.frame)
    var viewModel: ProfileViewModel!
    
    
    static func instance(id: String, social: String) -> ProfileVC {
        let controller = ProfileVC(nibName: nil, bundle: nil).then {
            $0.viewModel = ProfileViewModel(id: id, social: social,
                                            facebookManager: FacebookManager(),
                                            userService: UserService(),
                                            userDefaults: UserDefaultsUtil())
        }
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = profileView
        setupNicknameField()
        viewModel.input.getProfileEvent.onNext(()) // 소셜 id 가지고 오면 프로필 사진 바로 로딩
    }
    
    override func bindEvent() {}
    
    override func bindViewModel() {
        // Bind input
        profileView.nicknameField.rx.text.orEmpty.bind(to: viewModel.input.nicknameText).disposed(by: disposeBag)
        profileView.okBtn.rx.tap.bind(to: viewModel.input.tapConfirm).disposed(by: disposeBag)
        
        // Bind output
        viewModel.output.showLoading.bind(onNext: profileView.showLoading(isShow:))
            .disposed(by: disposeBag)
        viewModel.output.socialNickname.bind(to: profileView.nicknameField.rx.text)
            .disposed(by: disposeBag)
        viewModel.output.errorMsg.bind(onNext: profileView.showError)
            .disposed(by: disposeBag)
        viewModel.output.profileImage.bind(onNext: profileView.setProfile)
            .disposed(by: disposeBag)
        viewModel.output.showAlert.bind(onNext: showAlert)
            .disposed(by: disposeBag)
        viewModel.output.goToMain.bind(onNext: goToMain)
            .disposed(by: disposeBag)
    }
    
    private func setupNicknameField() {
        profileView.nicknameField.delegate = self
        profileView.nicknameField.becomeFirstResponder()
    }
    
    private func goToMain() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.goToMain()
        }
    }
    
    private func showAlert(message: String) {
        AlertUtil.show(controller: self, title: message, message: "")
    }
}

extension ProfileVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        return count <= 5
    }
}
