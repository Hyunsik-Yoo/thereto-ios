import UIKit

class FriendControlCell: BaseTableViewCell {
    
    static let registerId = "\(FriendControlCell.self)"
    
    let profileImg = UIImageView().then {
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.backgroundColor = .white
    }
    
    let nameLabel = UILabel().then {
        $0.text = "박은지"
        $0.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 14)
        $0.textColor = UIColor.init(r: 30, g: 30, b: 30)
    }
    
    let leftBtn = UIButton().then {
        $0.layer.borderColor = UIColor.orange_red.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = UIColor.init(r: 255, g: 233, b: 228)
        $0.setTitle("수락", for: .normal)
        $0.titleLabel?.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 12)
        $0.setTitleColor(.orange_red, for: .normal)
    }
    
    let rightBtn = UIButton().then {
        $0.layer.borderColor = UIColor.init(r: 114, g: 95, b: 95).cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = UIColor.init(r: 237, g: 222, b: 217)
        $0.setTitle("거부", for: .normal)
        $0.titleLabel?.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 12)
        $0.setTitleColor(UIColor.init(r: 114, g: 95, b: 95), for: .normal)
    }
    
    let waitingLabel = UILabel().then {
        $0.text = "친구 요청 수락 기다리는중"
        $0.textColor = UIColor.init(r: 165, g: 156, b: 156)
        $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 14)
        $0.textAlignment = .right
        $0.isHidden = true
    }
    
    
    override func setup() {
        backgroundColor = .clear
        addSubViews(profileImg, nameLabel, leftBtn, rightBtn, waitingLabel)
    }
    
    override func bindConstraints() {
        profileImg.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.width.height.equalTo(40)
        }
        
        rightBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImg)
            make.right.equalToSuperview().offset(-24)
            make.width.equalTo(64)
            make.height.equalTo(32)
        }
        
        leftBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImg)
            make.right.equalTo(rightBtn.snp.left).offset(-8)
            make.width.equalTo(64)
            make.height.equalTo(32)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImg)
            make.left.equalTo(profileImg.snp.right).offset(10)
            make.right.equalTo(leftBtn.snp.left).offset(-8)
        }
        
        waitingLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImg)
            make.right.equalToSuperview().offset(-24)
        }
    }
    
    func setMode(mode: ControlMode) {
        if mode == .RECEIVE {
            leftBtn.setTitle("수락", for: .normal)
            rightBtn.setTitle("거부", for: .normal)
        } else {
            leftBtn.setTitle("재요청", for: .normal)
            rightBtn.setTitle("삭제", for: .normal)
        }
    }
}

enum ControlMode: Int {
    case RECEIVE = 0
    case SENT = 1
}
