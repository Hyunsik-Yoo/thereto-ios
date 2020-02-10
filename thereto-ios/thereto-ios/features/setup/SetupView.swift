import UIKit

class SetupView: BaseView {
    
    let topBar = BoxNavigationBar().then{
        $0.isUserInteractionEnabled = true
        $0.addFriendBtn.isHidden = true
        $0.searchBtn.isHidden = true
        $0.titleLabel.text = "Setup."
    }
    
    let profileImg = UIImageView().then {
        $0.layer.cornerRadius = 40
        $0.layer.masksToBounds = true
        $0.backgroundColor = .gray
        $0.image = UIImage.init(named: "image_profile_default")
    }
    
    let nicknameLabel = UILabel().then {
        $0.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 20)
        $0.textColor = .black30
    }
    
    let nameLabel = UILabel().then {
        $0.textColor = .mushroom
        $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 17)
    }
    
    let bottomBg = UIView().then {
        $0.backgroundColor = .white
    }
    
    let whiteContainer = UIView().then {
        $0.backgroundColor = .white
    }
    
    let receivedLabel = UILabel().then {
        $0.text = "받은 엽서"
        $0.textColor = .brownish_grey
        $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 15)
        $0.textAlignment = .right
    }
    
    let receivedCountLabel = UILabel().then {
        $0.text = "0"
        $0.textColor = .greyishBrown
        $0.font = UIFont.init(name: "FrankRuhlLibre-Black", size: 25)
    }
    
    let sentLabel = UILabel().then {
        $0.text = "보낸 엽서"
        $0.textColor = .brownish_grey
        $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 15)
        $0.textAlignment = .right
    }
    
    let sentCountLabel = UILabel().then {
        $0.text = "0"
        $0.textColor = .greyishBrown
        $0.font = UIFont.init(name: "FrankRuhlLibre-Black", size: 25)
    }
    
    let tableView = UITableView().then {
        $0.tableFooterView = UIView()
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.isScrollEnabled = false
    }
    
    override func setup() {
        backgroundColor = .veryLightPink
        addSubViews(topBar, profileImg, nicknameLabel, nameLabel,
                    bottomBg, whiteContainer, receivedLabel, receivedCountLabel,
                    sentLabel, sentCountLabel, tableView)
    }
    
    override func bindConstraints() {
        topBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
        }
        
        profileImg.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(topBar.snp.bottom).offset(45)
            make.width.height.equalTo(80)
        }
        
        nicknameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(profileImg.snp.right).offset(15)
            make.top.equalTo(profileImg).offset(10)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nicknameLabel)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
        }
        
        whiteContainer.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(96 * RatioUtils.width)
            make.right.equalToSuperview()
            make.top.equalTo(profileImg.snp.bottom).offset(25)
            make.height.equalTo(130)
        }
        
        bottomBg.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(whiteContainer.snp.centerY)
        }
        
        receivedLabel.snp.makeConstraints { (make) in
            make.top.equalTo(whiteContainer).offset(40)
            make.left.equalTo(whiteContainer).offset(47 * RatioUtils.width)
        }
        
        receivedCountLabel.snp.makeConstraints { (make) in
            make.right.equalTo(receivedLabel)
            make.top.equalTo(receivedLabel.snp.bottom).offset(6)
        }
        
        sentLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-46 * RatioUtils.width)
            make.centerY.equalTo(receivedLabel)
        }
        
        sentCountLabel.snp.makeConstraints { (make) in
            make.right.equalTo(sentLabel)
            make.centerY.equalTo(receivedCountLabel)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(whiteContainer.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func bind(user: User?) {
        if let user = user {
            profileImg.kf.setImage(with: URL.init(string: user.profileURL!))
            nicknameLabel.text = user.nickname
            nameLabel.text = user.name
            receivedCountLabel.text = "\(user.receivedCount)"
            sentCountLabel.text = "\(user.sentCount)"
        }
    }
}
