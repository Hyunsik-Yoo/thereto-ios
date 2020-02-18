import UIKit

class SentLetterView: BaseView {
    
    let topBar = BoxNavigationBar().then {
        $0.isUserInteractionEnabled = true
    }

    let rightWhiteView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let tableView = UITableView().then {
        $0.allowsSelection = false
        $0.tableFooterView = UIView()
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
    }
    
    
    override func setup() {
        backgroundColor = UIColor.themeColor
        addSubViews(topBar, rightWhiteView, tableView)
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
    }
}
