import UIKit
import SnapKit

class SplashView: BaseView {
    
    private let splashImage: UIImageView = {
        let image = UIImageView(image: UIImage.init(named: "image_splash"))
        
        return image
    }()
    
    
    override func setup() {
        backgroundColor = UIColor.init(hex: "#fffff8ef")
        addSubViews(splashImage)
    }
    
    override func bindConstraints() {
        splashImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(220)
        }
    }
}
