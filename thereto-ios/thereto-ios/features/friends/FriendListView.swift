import UIKit
import Then

class FriendListView: BaseView {
    
    let topBar : BoxNavigationBar = {
        let topBar = BoxNavigationBar()
        
        topBar.isUserInteractionEnabled = true
        return topBar
    }()
    
    let tableView =  UITableView().then {
        $0.tableFooterView = UIView()
        $0.backgroundColor = .clear
        $0.rowHeight = UITableView.automaticDimension
        $0.separatorStyle = .none
    }
    
    let emptyLabel = UILabel().then {
        $0.text = "친구가 없습니다ㅠ.ㅠ"
        $0.textColor = .black30
        $0.font = UIFont.init(name: "SpoqaHanSans-Light", size: 15)
        $0.isHidden = true
    }
    
    
    override func setup() {
        backgroundColor = UIColor.themeColor
        addSubViews(topBar, tableView, emptyLabel)
    }
    
    override func bindConstraints() {
        topBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(topBar.snp.bottom).offset(40)
        }
    }
}
