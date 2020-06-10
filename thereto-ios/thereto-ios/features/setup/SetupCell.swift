import UIKit

class SetupCell: BaseTableViewCell {
    
    static let registerId = "\(SetupCell.self)"
    
    let titleLabel = UILabel().then {
        $0.textColor = UIColor.init(r: 107, g: 71, b: 55)
        $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 16)
    }
    
    let bottomLine = UIView().then {
        $0.backgroundColor = UIColor.init(r: 208, g: 179, b: 168)
        $0.alpha = 0.48
    }
    
    override func setup() {
        backgroundColor = .clear
        selectionStyle = .none
        addSubViews(titleLabel, bottomLine)
    }
    
    override func bindConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(19)
            make.bottom.equalToSuperview().offset(-19)
            make.left.equalToSuperview().offset(40 * RatioUtils.width)
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.equalToSuperview().offset(32 * RatioUtils.width)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-1)
        }
    }
}
