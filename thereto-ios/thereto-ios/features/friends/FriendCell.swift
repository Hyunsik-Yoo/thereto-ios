import UIKit
import Kingfisher

class FriendCell: BaseTableViewCell {
    
    static let registerId = "\(FriendCell.self)"
    
    let profileImage = UIImageView().then {
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.image = UIImage.init(named: "image_profile_default")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "박은지"
        label.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 14)
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
    
    func bind(friend: Friend) {
        profileImage.kf.setImage(with: URL.init(string: friend.profileURL!), placeholder: UIImage.init(named: "image_profile_default"))
        nameLabel.text = friend.nickname
        // TODO: 얘 어떻게 처리해야할까...
        favoriteDot.isHidden = true
    }
}
