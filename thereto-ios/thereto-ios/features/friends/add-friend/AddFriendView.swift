import UIKit
import Then

class AddFriendView: BaseView {
    
    let backBtn = UIButton().then {
        $0.setImage(UIImage.init(named: "ic_back"), for: .normal)
    }
    
    let titleLabel = UILabel().then {
        $0.text = "Add Friend."
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
    
    private let descLabel = UILabel().then {
        let attributedString =
            NSMutableAttributedString(string: "아직 가입하지 않은\n친구에게 ",
                                      attributes: [.font: UIFont.init(name: "SpoqaHanSans-Light", size: 17)!])
        attributedString
            .append(NSMutableAttributedString(string: "thereto",
                                              attributes: [.font: UIFont.init(name: "SpoqaHanSans-Bold", size: 17)!]))
        attributedString
            .append(NSMutableAttributedString(string: "를 공유해주세요.",
                                              attributes: [.font: UIFont.init(name: "SpoqaHanSans-Light", size: 17)!]))
        
        $0.attributedText = attributedString
        $0.textColor = UIColor.init(r: 60, g: 46, b: 42)
        $0.numberOfLines = 0
    }
    
    let linkBtn = UIButton().then {
        $0.setTitle("친구에게 초대링크 보내기", for: .normal)
        $0.titleLabel?.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 14)
        $0.backgroundColor = UIColor.init(r: 255, g: 84, b: 41)
        $0.setTitleColor(.white, for: .normal)
    }
    
    
    override func setup() {
        backgroundColor = UIColor.themeColor
        addSubViews(backBtn, titleLabel, nicknameField, searchBtn,
                    underLine, descLabel, linkBtn, tableView)
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
        
        descLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backBtn.snp.left)
            make.top.equalTo(underLine.snp.bottom).offset(68)
        }
        
        linkBtn.snp.makeConstraints { (make) in
            make.left.equalTo(backBtn.snp.left)
            make.right.equalTo(underLine.snp.right)
            make.top.equalTo(descLabel.snp.bottom).offset(21)
            make.height.equalTo(56)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(underLine.snp.bottom).offset(23)
        }
    }
    
    func setDataMode(isDataMode: Bool) {
        tableView.isHidden = !isDataMode
        descLabel.isHidden = isDataMode
        linkBtn.isHidden = isDataMode
        setDescText()
    }
    
    private func setDescText() {
        let attributedString =
            NSMutableAttributedString(string: "검색 결과가 없습니다.\n친구에게 ",
                                      attributes: [.font: UIFont.init(name: "SpoqaHanSans-Light", size: 17)!])
        attributedString
            .append(NSMutableAttributedString(string: "thereto",
                                              attributes: [.font: UIFont.init(name: "SpoqaHanSans-Bold", size: 17)!]))
        attributedString
            .append(NSMutableAttributedString(string: "를 공유해주세요.",
                                              attributes: [.font: UIFont.init(name: "SpoqaHanSans-Light", size: 17)!]))
        
        descLabel.attributedText = attributedString
    }
}
