import UIKit


class FriendAdminCell: BaseTableViewCell {
    
    static let registerId = "\(FriendAdminCell.self)"
    
    let titleLabel = UILabel().then {
        $0.text = "친구 요청 관리"
        $0.textColor = .black30
        $0.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 14)
    }
    
    let redDot = UIView().then {
        $0.backgroundColor = .orangeRed
        $0.layer.cornerRadius = 3
    }
    
    let rightArrow = UIImageView().then {
        $0.image = UIImage.init(named: "ic_arrow_right")
    }
    
    let bottomLine = UIView().then {
        $0.backgroundColor = .pinkishGrey
    }
    
    
    override func setup() {
        backgroundColor = .clear
        selectionStyle = .none
        addSubViews(titleLabel, redDot, rightArrow, bottomLine)
    }
    
    override func bindConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(31)
            make.bottom.equalToSuperview().offset(-31)
            make.left.equalToSuperview().offset(24)
        }
        
        redDot.snp.makeConstraints { (make) in
            make.width.height.equalTo(6)
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.centerY.equalTo(titleLabel.snp.top)
        }
        
        rightArrow.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-24)
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
    
}
