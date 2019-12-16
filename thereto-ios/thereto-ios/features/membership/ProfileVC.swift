import UIKit

class ProfileVC: BaseVC {
    
    private lazy var profileView: ProfileView =  {
        let profileView = ProfileView(frame: self.view.bounds)
        
        return profileView
    }()
    
    
    static func instance() -> ProfileVC {
        return ProfileVC(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        view = profileView
        profileView.nicknameField.delegate = self
        profileView.delegate = self
        
        // focus to textfield
        profileView.nicknameField.becomeFirstResponder()
    }
}

extension ProfileVC: ProfileDelegate, UITextFieldDelegate {
    func onTapOk() {
        AlertUtil.show(message: "확인 눌렀음!")
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
