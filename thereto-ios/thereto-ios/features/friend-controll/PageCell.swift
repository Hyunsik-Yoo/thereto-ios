import UIKit

class PageCell: BaseCollectionViewCell {
    
    static let registerId = "\(PageCell.self)"
    
    let tableView = UITableView().then {
        $0.backgroundColor = UIColor.init(r: 255, g: 248, b: 239)
        $0.tableFooterView = UIView()
        $0.separatorStyle = .none
    }
    
    
    override func setup() {
        backgroundColor = UIColor.init(r: 255, g: 248, b: 239)
        addSubViews(tableView)
    }
    
    override func bindConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
}
