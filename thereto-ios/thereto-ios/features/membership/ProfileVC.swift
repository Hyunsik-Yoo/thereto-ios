import UIKit
import FBSDKCoreKit
import RxSwift

class ProfileVC: BaseVC {
    
    var viewModel = ProfileViewModel()
    
    private lazy var profileView: ProfileView =  {
        let profileView = ProfileView(frame: self.view.bounds)
        
        return profileView
    }()
    
    
    static func instance(id: String, social: String) -> ProfileVC {
        let controller = ProfileVC(nibName: nil, bundle: nil)
        
        controller.viewModel.userId = id
        controller.viewModel.social = social
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = profileView
        profileView.nicknameField.delegate = self
        profileView.delegate = self
        
        // focus to textfield
        profileView.nicknameField.becomeFirstResponder()
        getFBProfile(id: viewModel.userId)
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
}

extension ProfileVC: ProfileDelegate, UITextFieldDelegate {
    func onTapOk() {
        AlertUtil.show(message: "\(try? self.viewModel.profileImageUrl.value())")
    }
    
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
