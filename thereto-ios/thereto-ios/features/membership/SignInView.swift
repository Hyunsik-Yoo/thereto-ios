import UIKit
import AuthenticationServices
import FBSDKCoreKit
import FBSDKLoginKit

class SignInView: BaseView {
    
    private let splashImage: UIImageView = {
        let image = UIImageView(image: UIImage.init(named: "image_logo"))
        
        return image
    }()
    
    let appleBtn: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .continue, style: .black)
        
        return button
    }()
    
    let fbBtn: FBLoginButton = {
        let button = FBLoginButton(frame: .zero)
        
        button.permissions = ["public_profile", "email"]
        return button
    }()
    
    
    override func setup() {
        backgroundColor = .themeColor
        
        addSubViews(splashImage, appleBtn, fbBtn)
    }
    
    override func bindConstraints() {
        splashImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(220)
        }
        
        appleBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.bottom.equalToSuperview().offset(-50)
            make.height.equalTo(40)
        }
        
        fbBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(appleBtn)
            make.height.equalTo(160)
            make.bottom.equalTo(appleBtn.snp.top).offset(-10)
        }
    }
}
