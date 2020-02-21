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
        $0.text = "보낸 엽서가 없습니다.\n친구에게 엽서를 남겨보세요!"
        $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 14)
        $0.numberOfLines = 0
        $0.textColor = .brownishGrey
        $0.isHidden = true
    }
    
    let emptyBtn = UIButton().then {
        $0.setTitle("엽서 쓰기", for: .normal)
        $0.backgroundColor = .orangeRed
        $0.titleLabel?.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 14)
        $0.isHidden = true
    }
    
    override func setup() {
        backgroundColor = UIColor.themeColor
        addSubViews(topBar, rightWhiteView, tableView, emptyLabel, emptyBtn)
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
            make.top.equalTo(tableView).offset(45)
        }
        
        emptyBtn.snp.makeConstraints { (make) in
            make.left.equalTo(emptyLabel)
            make.top.equalTo(emptyLabel.snp.bottom).offset(24)
            make.width.equalTo(224)
            make.height.equalTo(56)
        }
    }
    
    func setEmpty(isEmpty: Bool) {
        emptyLabel.isHidden = !isEmpty
        emptyBtn.isHidden = !isEmpty
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
