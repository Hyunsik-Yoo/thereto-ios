import UIKit
import AuthenticationServices
import FBSDKCoreKit
import FBSDKLoginKit

class SignInView: BaseView {
    
    private let splashImage: UIImageView = {
        let image = UIImageView(image: UIImage.init(named: "image_logo"))
        
        return image
    }()
    
    @available(iOS 13.0, *)
    lazy var appleBtn: ASAuthorizationAppleIDButton? = nil
    
    let fbBtn: FBLoginButton = {
        let button = FBLoginButton(frame: .zero)
        
        button.permissions = ["public_profile", "email"]
        return button
    }()
    
    
    override func setup() {
        backgroundColor = .themeColor
        addSubViews(splashImage, fbBtn)
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
        if #available(iOS 13.0, *) {
            generateSignWithAppleBtn()
        }
    }
    
    @available(iOS 13.0, *)
    private func generateSignWithAppleBtn() {
        appleBtn = ASAuthorizationAppleIDButton(type: .continue, style: .black)
        addSubview(appleBtn!)
        
        appleBtn?.snp.makeConstraints { (make) in
            make.left.right.equalTo(fbBtn)
            make.height.equalTo(40)
            make.bottom.equalTo(fbBtn.snp.top).offset(-10)
        }
    }
}
