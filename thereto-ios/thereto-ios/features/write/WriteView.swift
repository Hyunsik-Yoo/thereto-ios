import UIKit

class WriteView: BaseView {
    
    let topBg = UIView().then {
        $0.backgroundColor = .veryLightPink
    }
    
    let backBtn = UIButton().then {
        $0.setImage(UIImage.init(named: "ic_back"), for: .normal)
    }
    
    let sendBtn = UIButton().then {
        $0.setTitle("send", for: .normal)
        $0.titleLabel?.font = UIFont.init(name: "FrankRuhlLibre-Black", size: 21)
        $0.setTitleColor(.black30, for: .normal)
    }
    
    let bottomLine = UIView().then {
        $0.backgroundColor = .mudBrown
    }
    
    
    override func setup() {
        backgroundColor = .white
        addSubViews(topBg, backBtn, sendBtn, bottomLine)
    }
    
    override func bindConstraints() {
        
    }
}
