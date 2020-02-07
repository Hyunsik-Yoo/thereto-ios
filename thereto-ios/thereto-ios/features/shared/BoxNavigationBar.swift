import UIKit

class BoxNavigationBar: BaseView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Letterbox."
        label.textAlignment = .left
        label.font = UIFont.init(name: "FrankRuhlLibre-Black", size: 41)
        label.textColor = UIColor.init(r: 60, g: 46, b: 42)
        return label
    }()
    
    let addFriendBtn: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage.init(named: "ic_add_friend"), for: .normal)
        return button
    }()
    
    let searchBtn: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage.init(named: "ic_search"), for: .normal)
        return button
    }()
    
    let hambugerBtn: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage.init(named: "ic_hamburger"), for: .normal)
        return button
    }()
    
    private let bottomLine: UIView = {
        let bottom = UIView()
        
        bottom.backgroundColor = UIColor.init(r: 66, g: 40, b: 15)
        return bottom
    }()
    
    
    
    override func setup() {
        backgroundColor = UIColor.themeColor
        addSubViews(titleLabel, addFriendBtn, searchBtn, hambugerBtn, bottomLine)
    }
    
    override func bindConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        hambugerBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-20)
        }
        
        searchBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(hambugerBtn.snp.left).offset(-10)
        }
        
        addFriendBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(searchBtn.snp.left).offset(-10)
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(1)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
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
