import UIKit

class ProfileView: BaseView {
    
    private let logoImage: UIImageView = {
        let image = UIImageView(image: UIImage.init(named: "LogoImage"))
        
        return image
    }()
    
    private let profileImage: UIImageView = {
        let image = UIImageView()
        
        image.backgroundColor = .white
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "박은지"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let nicknameField: UITextField = {
        let field = UITextField()
        
        field.placeholder = "닉네임을 설정해주세요. (5자이내)"
        field.font = UIFont.systemFont(ofSize: 16)
        return field
    }()
    
    private let nicknameUnderLine: UIView = {
        let view = UIView(frame: .zero)
        
        view.backgroundColor = UIColor.init(r: 66, g: 40, b: 15)
        return view
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        
        label.text = "* 한글, 영문, 숫자만 사용가능합니다.\n* 닉네임은 수정할 수 없습니다."
        label.textColor = UIColor.init(r: 114, g: 95, b: 95)
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()
    
    let okBtn: UIButton = {
        let button = UIButton()
        
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = UIColor.init(r: 255, g: 84, b: 41)
        return button
    }()
    
    override func setup() {
        backgroundColor = UIColor.themeColor
        addSubViews(logoImage, profileImage, nameLabel, nicknameUnderLine,
                    nicknameField, descLabel, okBtn)
    }
    
    override func bindConstraints() {
        logoImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(160)
            make.height.equalTo(112)
            make.top.equalToSuperview().offset(200)
        }
        
        okBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
            make.bottom.equalToSuperview().offset(-58)
            make.height.equalTo(56)
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(32)
            make.bottom.equalTo(okBtn.snp.top).offset(-76)
        }
        
        nicknameUnderLine.snp.makeConstraints { (make) in
            make.left.equalTo(descLabel.snp.left)
            make.right.equalToSuperview().offset(-32)
            make.bottom.equalTo(descLabel.snp.top).offset(-13.5)
            make.height.equalTo(1)
        }
        
        nicknameField.snp.makeConstraints { (make) in
            make.left.equalTo(descLabel.snp.left)
            make.right.equalTo(nicknameUnderLine.snp.right)
            make.bottom.equalTo(nicknameUnderLine.snp.top)
        }
        
        profileImage.snp.makeConstraints { (make) in
            make.left.equalTo(descLabel.snp.left)
            make.bottom.equalTo(nicknameField.snp.top).offset(-33)
            make.width.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(profileImage.snp.right).offset(10)
            make.centerY.equalTo(profileImage)
        }
    }
}
