import UIKit

class LetterBoxView: BaseView {
    
    private let label: UILabel = {
        let label = UILabel()
        
        label.text = "Hello"
        return label
    }()
    
    override func setup() {
        backgroundColor = UIColor.themeColor
        addSubview(label)
    }
    
    override func bindConstraints() {
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}
