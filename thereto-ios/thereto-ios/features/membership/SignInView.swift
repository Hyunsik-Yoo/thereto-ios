import UIKit
import AuthenticationServices

class SignInView: BaseView {
    
    private let splashImage: UIImageView = {
        let image = UIImageView(image: UIImage.init(named: "SplashImage"))
        
        return image
    }()
    
    let appleBtn: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .continue, style: .black)
        
        return button
    }()
    
    
    override func setup() {
        backgroundColor = .themeColor
        
        addSubViews(splashImage, appleBtn)
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
    }
}
