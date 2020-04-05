import UIKit

class LetterBoxView: BaseView {
    
    lazy var dimView = UIView(frame: self.frame).then {
        $0.backgroundColor = .clear
    }
    
    let topBar = BoxNavigationBar().then {
        $0.isUserInteractionEnabled = true
    }

    let rightWhiteView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let tableView = UITableView().then {
        $0.tableFooterView = UIView()
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
    }
    
    let emptyLabel = UILabel().then {
        $0.text = "받은 엽서가 없습니다."
        $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 14)
        $0.textColor = .brownishGrey
        $0.isHidden = true
    }
    
    
    override func setup() {
        backgroundColor = UIColor.themeColor
        addSubViews(topBar, rightWhiteView, tableView, emptyLabel)
    }
    
    override func bindConstraints() {
        topBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
        }
        
        rightWhiteView.snp.makeConstraints { (make) in
            make.top.equalTo(topBar.snp.bottom)
            make.right.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.width.equalTo(70)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(22)
            make.top.equalTo(tableView).offset(48)
        }
    }
    
    func setEmpty(isEmpty: Bool) {
        emptyLabel.isHidden = !isEmpty
    }
    
    func addBgDim() {
        DispatchQueue.main.async { [weak self] in
            if let view = self {
                view.addSubview(view.dimView)
                UIView.animate(withDuration: 0.3) {
                    view.dimView.backgroundColor = UIColor.init(r: 0, g: 0, b: 0, a:0.5)
                }
            }
            
        }
    }
    
    
    func removeBgDim() {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.3, animations: {
                self?.dimView.backgroundColor = .clear
            }) { (_) in
                self?.dimView.removeFromSuperview()
            }
        }
    }
}
