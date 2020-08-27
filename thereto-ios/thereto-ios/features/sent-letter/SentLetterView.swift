import UIKit

class SentLetterView: BaseView {
  
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
    $0.text = "sent_letter_empty".localized
    $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 14)
    $0.numberOfLines = 0
    $0.textColor = .brownishGrey
    $0.isHidden = true
  }
  
  let emptyButton = UIButton().then {
    $0.setTitle("sent_letter_empty_button".localized, for: .normal)
    $0.backgroundColor = .orangeRed
    $0.titleLabel?.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 14)
    $0.isHidden = true
  }
  
  
  override func setup() {
    backgroundColor = UIColor.themeColor
    addSubViews(topBar, rightWhiteView, tableView, emptyLabel, emptyButton)
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
    
    emptyButton.snp.makeConstraints { (make) in
      make.left.equalTo(emptyLabel)
      make.top.equalTo(emptyLabel.snp.bottom).offset(24)
      make.width.equalTo(224)
      make.height.equalTo(56)
    }
  }
  
  func setEmpty(isEmpty: Bool) {
    emptyLabel.isHidden = !isEmpty
    emptyButton.isHidden = !isEmpty
  }
}
