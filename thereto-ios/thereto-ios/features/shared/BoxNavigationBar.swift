import UIKit

class BoxNavigationBar: BaseView {
    
    let titleLabel = UILabel().then {
        $0.text = "Letterbox."
        $0.textAlignment = .left
        $0.font = UIFont.init(name: "FrankRuhlLibre-Black", size: 31)
        $0.textColor = .greyishBrown
    }
    
    let addFriendBtn = UIButton().then {
        $0.setImage(UIImage.init(named: "ic_add_friend"), for: .normal)
    }
    
    let searchBtn = UIButton().then {
        $0.setImage(UIImage.init(named: "ic_search"), for: .normal)
    }
    
    let bottomLine = UIView().then {
        $0.backgroundColor = UIColor.init(r: 66, g: 40, b: 15)
    }
    
    
    override func setup() {
        backgroundColor = UIColor.themeColor
        addSubViews(titleLabel, addFriendBtn, searchBtn, bottomLine)
    }
    
    override func bindConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24 * RatioUtils.width)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        searchBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-24 * RatioUtils.width)
            make.width.height.equalTo(24)
        }
        
        addFriendBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(searchBtn.snp.left).offset(-16 * RatioUtils.width)
            make.width.height.equalTo(24)
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.left.equalToSuperview().offset(16 * RatioUtils.width)
            make.height.equalTo(1)
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
        }
    }
    
    func setLetterBoxMode() {
        titleLabel.text = "Letterbox."
        addFriendBtn.isHidden = true
    }
    
    func setFriendListMode() {
        titleLabel.text = "Friend."
        addFriendBtn.isHidden = false
    }
}
