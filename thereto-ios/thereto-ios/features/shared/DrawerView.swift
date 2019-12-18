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
    
    let letterboxLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Letterbox."
        label.font = UIFont.init(name: "FrankRuhlLibre-Black", size: 26)
        label.textColor = UIColor.init(r: 60, g: 46, b: 42)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let sentletterLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Sent letter."
        label.font = UIFont.init(name: "FrankRuhlLibre-Black", size: 26)
        label.textColor = UIColor.init(r: 60, g: 46, b: 42)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let friendLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Friend."
        label.font = UIFont.init(name: "FrankRuhlLibre-Black", size: 26)
        label.textColor = UIColor.init(r: 60, g: 46, b: 42)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let setupLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Setup."
        label.font = UIFont.init(name: "FrankRuhlLibre-Black", size: 26)
        label.textColor = UIColor.init(r: 60, g: 46, b: 42)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    
    override func setup() {
        isUserInteractionEnabled = true
        addSubViews(bgView, closeBtn, logoImage, middleLine, letterboxLabel,
                    sentletterLabel, friendLabel, setupLabel)
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
        
        letterboxLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bgView.snp.left).offset(50)
            make.top.equalTo(middleLine.snp.bottom).offset(25)
        }
        
        sentletterLabel.snp.makeConstraints { (make) in
            make.left.equalTo(letterboxLabel)
            make.top.equalTo(letterboxLabel.snp.bottom).offset(30)
        }
        
        friendLabel.snp.makeConstraints { (make) in
            make.left.equalTo(letterboxLabel)
            make.top.equalTo(sentletterLabel.snp.bottom).offset(30)
        }
        
        setupLabel.snp.makeConstraints { (make) in
            make.left.equalTo(letterboxLabel)
            make.top.equalTo(friendLabel.snp.bottom).offset(30)
        }
    }
}
