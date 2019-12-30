import UIKit

class PageCell: BaseCollectionViewCell {
    
    static let registerId = "\(PageCell.self)"
    
    let label = UILabel().then {
        $0.text = "page"
        $0.textColor = .black
    }
    
    
    override func setup() {
        backgroundColor = UIColor.init(r: 255, g: 248, b: 239)
        addSubViews(label)
    }
    
    override func bindConstraints() {
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}
