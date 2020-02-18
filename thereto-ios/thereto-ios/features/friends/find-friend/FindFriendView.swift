import UIKit

class FindFriendView: BaseView {
    let backBtn = UIButton().then {
        $0.setImage(UIImage.init(named: "ic_back"), for: .normal)
    }
    
    let titleLabel = UILabel().then {
        $0.text = "Find Friend."
        $0.font = UIFont.init(name: "FrankRuhlLibre-Black", size: 51)
        $0.textColor = UIColor.init(r: 60, g: 46, b: 42)
    }
    
    let nicknameField = UITextField().then {
        $0.placeholder = "닉네임을 입력하세요."
        $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 14)
        $0.returnKeyType = .done
        $0.textColor = UIColor.init(r: 60, g: 46, b: 42)
    }
    
    let searchBtn = UIButton().then {
        $0.setImage(UIImage.init(named: "ic_search"), for: .normal)
    }
    
    let underLine = UIView().then {
        $0.backgroundColor = UIColor.init(r: 66, g: 40, b: 15)
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
        backgroundColor = UIColor.themeColor
        addSubViews(backBtn, titleLabel, nicknameField, searchBtn,
                    underLine, tableView, emptyLabel)
    }
    
    override func bindConstraints() {
        backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.left.equalToSuperview().offset(24)
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backBtn.snp.left)
            make.top.equalTo(safeAreaLayoutGuide).offset(56)
        }
        
        searchBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(titleLabel.snp.bottom).offset(27)
            make.width.height.equalTo(24)
        }
        
        nicknameField.snp.makeConstraints { (make) in
            make.left.equalTo(backBtn.snp.left)
            make.centerY.equalTo(searchBtn.snp.centerY)
            make.right.equalTo(searchBtn.snp.left).offset(-10)
        }
        
        underLine.snp.makeConstraints { (make) in
            make.left.equalTo(nicknameField.snp.left)
            make.right.equalTo(searchBtn.snp.right)
            make.top.equalTo(searchBtn.snp.bottom).offset(7.5)
            make.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(underLine.snp.bottom).offset(23)
        }
        
        emptyLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(underLine.snp.bottom).offset(40)
        }
    }
    
    func setDataMode(isEmpty: Bool) {
        tableView.isHidden = isEmpty
        emptyLabel.isHidden = !isEmpty
    }
}
