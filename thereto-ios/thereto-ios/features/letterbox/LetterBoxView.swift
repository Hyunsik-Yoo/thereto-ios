import UIKit

class LetterBoxView: BaseView {
    
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
        $0.text = "letterbox_empty".localized
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
}
