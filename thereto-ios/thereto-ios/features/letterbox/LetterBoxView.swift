import UIKit

class LetterBoxView: BaseView {
    
    let topBar : BoxNavigationBar = {
        let topBar = BoxNavigationBar()
        
        topBar.isUserInteractionEnabled = true
        return topBar
    }()

    private let rightWhiteView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        return view
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    
    override func setup() {
        translatesAutoresizingMaskIntoConstraints = false
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
            make.bottom.right.equalToSuperview()
            make.width.equalTo(70)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
