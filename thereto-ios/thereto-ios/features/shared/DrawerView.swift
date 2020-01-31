import UIKit

class DrawerView: BaseView {
    
    private let bgView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.themeColor
        return view
    }()
    
    let closeBtn: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage.init(named: "ic_close"), for: .normal)
        return button
    }()
    
    private let logoImage: UIImageView = {
        let image = UIImageView()
        
        image.image = UIImage.init(named: "image_logo")
        return image
    }()
    
    private let middleLine: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.init(r: 66, g: 40, b: 15)
        return view
    }()
    
    let letterboxBtn = UIButton().then {
        $0.setTitle("Letterbox.", for: .normal)
        $0.setTitleColor(UIColor.init(r: 60, g: 46, b: 42), for: .normal)
        $0.titleLabel?.font = UIFont.init(name: "FrankRuhlLibre-Black", size: 26)
    }
    
    let sentLetterBtn = UIButton().then {
        $0.setTitle("Sent letter.", for: .normal)
        $0.setTitleColor(UIColor.init(r: 60, g: 46, b: 42), for: .normal)
        $0.titleLabel?.font = UIFont.init(name: "FrankRuhlLibre-Black", size: 26)
    }
    
    let friendBtn = UIButton().then {
        $0.setTitle("Friend.", for: .normal)
        $0.setTitleColor(UIColor.init(r: 60, g: 46, b: 42), for: .normal)
        $0.titleLabel?.font = UIFont.init(name: "FrankRuhlLibre-Black", size: 26)
    }
    
    let setupBtn = UIButton().then {
        $0.setTitle("Setup.", for: .normal)
        $0.setTitleColor(UIColor.init(r: 60, g: 46, b: 42), for: .normal)
        $0.titleLabel?.font = UIFont.init(name: "FrankRuhlLibre-Black", size: 26)
    }
    
    let friendControllBtn = UIButton().then {
        $0.setTitle("친구요청 관리", for: .normal)
        $0.setTitleColor(UIColor.init(r: 60, g: 46, b: 42), for: .normal)
        $0.titleLabel?.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 12)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.init(r: 60, g: 46, b: 42).cgColor
    }
    
    let newBadge = UIView().then {
        $0.backgroundColor = UIColor.init(r: 255, g: 84, b: 41)
        $0.layer.cornerRadius = 6
    }
    
    
    override func setup() {
        isUserInteractionEnabled = true
        addSubViews(bgView, closeBtn, logoImage, middleLine, letterboxBtn,
                    sentLetterBtn, friendBtn, setupBtn, friendControllBtn, newBadge)
    }
    
    override func bindConstraints() {
        bgView.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(320)
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(16)
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.width.height.equalTo(30)
        }
        
        logoImage.snp.makeConstraints { (make) in
            make.left.equalTo(bgView.snp.left).offset(50)
            make.top.equalTo(closeBtn.snp.bottom).offset(40)
            make.width.equalTo(180)
            make.height.equalTo(130)
        }
        
        middleLine.snp.makeConstraints { (make) in
            make.left.equalTo(bgView.snp.left).offset(30)
            make.top.equalTo(logoImage.snp.bottom).offset(40)
            make.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        letterboxBtn.snp.makeConstraints { (make) in
            make.left.equalTo(bgView.snp.left).offset(50)
            make.top.equalTo(middleLine.snp.bottom).offset(25)
        }
        
        sentLetterBtn.snp.makeConstraints { (make) in
            make.left.equalTo(letterboxBtn)
            make.top.equalTo(letterboxBtn.snp.bottom).offset(30)
        }
        
        friendBtn.snp.makeConstraints { (make) in
            make.left.equalTo(letterboxBtn)
            make.top.equalTo(sentLetterBtn.snp.bottom).offset(30)
        }
        
        setupBtn.snp.makeConstraints { (make) in
            make.left.equalTo(letterboxBtn)
            make.top.equalTo(friendBtn.snp.bottom).offset(30)
        }
        
        friendControllBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-44)
            make.right.equalToSuperview().offset(-40)
            make.width.equalTo(93)
            make.height.equalTo(32)
        }
        
        newBadge.snp.makeConstraints { (make) in
            make.centerX.equalTo(friendControllBtn.snp.right)
            make.centerY.equalTo(friendControllBtn.snp.top)
            make.width.height.equalTo(12)
        }
    }
}
