import UIKit
import FBSDKCoreKit
import RxSwift

class ProfileVC: BaseVC {
    
    var viewModel = ProfileViewModel()
    var userId: String!
    var social: String!
    
    private lazy var profileView: ProfileView =  {
        let profileView = ProfileView(frame: self.view.bounds)
        
        return profileView
    }()
    
    
    static func instance(id: String, social: String, name: String? = nil) -> ProfileVC {
        let controller = ProfileVC(nibName: nil, bundle: nil)
        
        controller.userId = id
        controller.social = social
        if let name = name {
            controller.viewModel.name.onNext(name)
        }
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = profileView
        
        profileView.nicknameField.delegate = self
        profileView.delegate = self
        profileView.nicknameField.becomeFirstResponder()
        
        if social == "facebook" { // 애플로그인으로 접근할 경우에는 사진이 제공되지 않음
            getFBProfile(id: userId)
        }
    }
    
    override func bindViewModel() {
        viewModel.name
            .bind(to: profileView.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.profileImageUrl
            .filter({ $0 != "" })
            .bind(onNext: { (urlString) in
                self.profileView.profileImage.setImage(urlString: urlString)
            }).disposed(by: disposeBag)
    }
    
    private func getFBProfile(id: String){
        let connection = GraphRequestConnection()
        
        connection.add(GraphRequest(graphPath: "/me")) { (httpResponse, result, error) in
            if error != nil {
                AlertUtil.show(message: error.debugDescription)
            } else {
                if let result = result as? [String:String],
                    let name: String = result["name"],
                    let fbId: String = result["id"] {
                    self.viewModel.name.onNext(name)
                    self.viewModel.profileImageUrl.onNext("https://graph.facebook.com/\(fbId)/picture?height=400")
                }
            }
        }
        connection.start()
    }
    
    private func goToMain() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.goToLetterbox()
        }
    }
}

extension ProfileVC: ProfileDelegate{
    func onTapOk() {
        let nickname = self.profileView.nicknameField.text!
        
        if !nickname.isEmpty {
            if let name = try? self.viewModel.name.value(),
                let profileURL = try? self.viewModel.profileImageUrl.value() {
                let user = User(nickname: nickname, name: name, social: self.social,
                                id: self.userId, profileURL: profileURL)
                
                UserService.isExistingUser(nickname: nickname) { (isExisted) in
                    if (isExisted) {
                        AlertUtil.show(message: "중복된 닉네임입니다.\n다른 닉네임을 적어주세요.")
                    } else {
                        UserService.saveUser(user: user) {
                            self.goToMain()
                        }
                    }
                }
            }
        }
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
