import UIKit

class AddFriendCell: BaseTableViewCell {
    
    static let registerId = "\(AddFriendCell.self)"
    
    let profileImage = UIImageView().then {
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .red
    }
    
    let nameLabel = UILabel().then {
        $0.text = "박은지"
        $0.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 14)
        $0.textColor = UIColor.init(r: 30, g: 30, b: 30)
    }
    
    let addBtn = UIButton().then {
        $0.setImage(UIImage.init(named: "ic_add"), for: .normal)
    }
    
    
    override func setup() {
        backgroundColor = .clear
        selectionStyle = .none
        addSubViews(profileImage, nameLabel, addBtn)
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
        
        addBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImage.snp.centerY)
            make.right.equalToSuperview().offset(-24)
            make.width.height.equalTo(24)
        }
    }
    
    func bind(user: User?) {
        // TODO: bind
    }
}
