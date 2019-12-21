import UIKit

class FriendCell: BaseTableViewCell {
    
    static let registerId = "\(FriendCell.self)"
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = .red
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "박은지"
        label.font = UIFont.init(name: "SpoqaHanSansBold", size: 14)
        label.textColor = UIColor.init(r: 30, g: 30, b: 30)
        return label
    }()
    
    let favoriteDot: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.init(r: 255, g: 84, b: 41)
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        return view
    }()
    
    
    override func setup() {
        backgroundColor = .clear
        selectionStyle = .none
        addSubViews(profileImage, nameLabel, favoriteDot)
    }
    
    override func bindConstraints() {
        profileImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(24)
            make.width.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImage.snp.centerY)
            make.left.equalTo(profileImage.snp.right).offset(10)
        }
        
        favoriteDot.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameLabel.snp.top)
            make.left.equalTo(nameLabel.snp.right).offset(2)
            make.width.height.equalTo(6)
        }
    }
}
