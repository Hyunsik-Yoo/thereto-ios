import UIKit
import AuthenticationServices
import FBSDKCoreKit
import FBSDKLoginKit

class SignInView: BaseView {
    
    private let splashImage: UIImageView = {
        let image = UIImageView(image: UIImage.init(named: "image_logo"))
        
        return image
    }()
    
    let appleBtn = ASAuthorizationAppleIDButton(type: .continue, style: .black).then {
        $0.cornerRadius = 0
    }
    
    let fbBtn: FBLoginButton = {
        let button = FBLoginButton(frame: .zero)
        
        button.permissions = ["public_profile", "email"]
        return button
    }()
    
    
    override func setup() {
        backgroundColor = .themeColor
        addSubViews(splashImage, fbBtn, appleBtn)
    }
    
    override func bindConstraints() {
        splashImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(220)
        }
        
        fbBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.bottom.equalToSuperview().offset(-50)
        }
        
        appleBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(fbBtn)
            make.height.equalTo(40)
            make.bottom.equalTo(fbBtn.snp.top).offset(-10)
        }
    }
}
