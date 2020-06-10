import UIKit

class LetterSearchView: BaseView {
    
    let backBtn = UIButton().then {
        $0.setImage(UIImage.init(named: "ic_back"), for: .normal)
    }
    
    let titleLabel = UILabel().then {
        $0.text = "Search."
        $0.font = UIFont.init(name: "FrankRuhlLibre-Black", size: 48)
        $0.textColor = .greyishBrown
    }
    
    let nicknameField = UITextField().then {
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
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.tableFooterView = UIView()
        $0.alwaysBounceVertical = false
    }
    
    let descLabel = UILabel().then {
        $0.text = "받는 사람 혹은 보내는 사람의 이름으로 검색할 수 있습니다."
        $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 14)
        $0.textColor = .brownishGrey
    }
    
    override func setup() {
        backgroundColor = .veryLightPink
        addSubViews(backBtn, titleLabel, nicknameField, nicknameField, searchBtn, underLine, tableView, descLabel)
    }
    
    override func bindConstraints() {
        backBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backBtn)
            make.top.equalTo(backBtn.snp.bottom).offset(16)
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
            make.top.equalTo(underLine.snp.bottom).offset(30)
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(22)
            make.top.equalTo(tableView).offset(22)
        }
    }
    
    func setEmpty(isEmpty: Bool) {
        tableView.isHidden = isEmpty
        descLabel.isHidden = !isEmpty
        descLabel.text = "일치하는 검색 결과가 없습니다."
    }
    
    func setType(type: String) {
        if type == "from" {
            descLabel.text = "받는 사람의 이름으로 검색할 수 있습니다."
        } else {
            descLabel.text = "보낸 사람의 이름으로 검색할 수 있습니다."
        }
    }
}
