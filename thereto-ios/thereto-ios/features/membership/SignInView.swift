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
    
    let facebookBtn = UIButton().then {
        $0.backgroundColor = UIColor(r: 50, g: 92, b: 175)
        $0.setTitle("페이스북 계정으로 로그인", for: .normal)
        $0.titleLabel?.font = UIFont(name: "SpoqaHanSans-Bold", size: 14)
        $0.setTitleColor(.white, for: .normal)
    }
    
    let fbBtn: FBLoginButton = {
        let button = FBLoginButton(frame: .zero)
        
        button.permissions = ["public_profile", "email"]
        return button
    }()
    
    
    override func setup() {
        backgroundColor = .themeColor
        addSubViews(splashImage, fbBtn, appleBtn, facebookBtn)
    }
    
    override func bindConstraints() {
        splashImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(220)
        }
        
        facebookBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.bottom.equalToSuperview().offset(-50)
            make.height.equalTo(40)
        }
        
        fbBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(0)
        }
        
        appleBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(facebookBtn)
            make.height.equalTo(40)
            make.bottom.equalTo(facebookBtn.snp.top).offset(-10)
        }
    }
}
