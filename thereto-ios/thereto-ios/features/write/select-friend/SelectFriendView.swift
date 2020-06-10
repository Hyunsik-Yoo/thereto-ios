import UIKit

class SelectFirendView: BaseView {
    
    let backBtn = UIButton().then {
        $0.setImage(UIImage.init(named: "ic_back"), for: .normal)
    }
    
    let nicknameField = UITextField().then {
        $0.placeholder = "닉네임을 입력하세요."
        $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 14)
        $0.returnKeyType = .done
        $0.textColor = .mushroom
    }
    
    let searchBtn = UIButton().then {
        $0.setImage(UIImage.init(named: "ic_search"), for: .normal)
    }
    
    let underLine = UIView().then {
        $0.backgroundColor = .mudBrown
    }
    
    let tableView = UITableView().then {
        $0.tableFooterView = UIView()
        $0.backgroundColor = UIColor.themeColor
        $0.separatorStyle = .none
        $0.isHidden = true
    }
    
    let emptyLabel = UILabel().then {
        $0.text = "친구가 없습니다ㅠ.ㅠ"
        $0.textColor = .black30
        $0.font = UIFont.init(name: "SpoqaHanSans-Light", size: 15)
        $0.isHidden = true
    }
    
    override func setup() {
        backgroundColor = .themeColor
        addSubViews(backBtn, nicknameField, searchBtn, underLine, tableView, emptyLabel)
    }
    
    override func bindConstraints() {
        backBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.width.height.equalTo(24)
        }
        
        searchBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(backBtn.snp.bottom).offset(34)
            make.width.height.equalTo(24)
        }
        
        nicknameField.snp.makeConstraints { (make) in
            make.left.equalTo(backBtn)
            make.centerY.equalTo(searchBtn)
            make.right.equalTo(searchBtn.snp.left).offset(-10)
        }
        
        underLine.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(1)
            make.top.equalTo(searchBtn.snp.bottom).offset(8)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(underLine.snp.bottom).offset(10)
        }
        
        emptyLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(tableView).offset(20)
        }
    }
    
    func setDataMode(isEmpty: Bool) {
        tableView.isHidden = isEmpty
        emptyLabel.isHidden = !isEmpty
    }
}
