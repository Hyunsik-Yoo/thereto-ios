import UIKit

class TabBarCell: BaseCollectionViewCell {
    
    static let registerId = "\(TabBarCell.self)"
    
    let titleLabel = UILabel().then {
        $0.text = "Title"
        $0.textColor = UIColor.init(r: 60, g: 46, b: 42)
        $0.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 14)
    }
    
    override func setup() {
        addSubViews(titleLabel)
    }
    
    override func bindConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}
