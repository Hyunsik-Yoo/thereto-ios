import UIKit

class FriendTableView: BaseView {
    let tableView = UITableView().then {
        $0.backgroundColor = UIColor.init(r: 255, g: 248, b: 239)
        $0.tableFooterView = UIView()
        $0.separatorStyle = .none
    }
    
    let emptyLabel = UILabel().then {
        $0.text = "받은 요청이 없습니다."
        $0.textColor = .black_30
        $0.font = UIFont.init(name: "SpoqaHanSans-Light", size: 14)
        $0.isHidden = true
    }
    
    
    override func setup() {
        backgroundColor = UIColor.init(r: 255, g: 248, b: 239)
        addSubViews(tableView, emptyLabel)
    }
    
    override func bindConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        emptyLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(tableView).offset(80)
        }
    }
}
