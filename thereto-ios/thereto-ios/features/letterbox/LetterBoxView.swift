import UIKit

class LetterBoxView: BaseView {
    
    private let topBar = BoxNavigationBar()

    private let rightWhiteView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        return view
    }()
    
    override func setup() {
        backgroundColor = UIColor.themeColor
        addSubViews(topBar, rightWhiteView)
    }
    
    override func bindConstraints() {
        topBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
        }
        
        rightWhiteView.snp.makeConstraints { (make) in
            make.top.equalTo(topBar.snp.bottom)
            make.bottom.right.equalToSuperview()
            make.width.equalTo(70)
        }
    }
}
