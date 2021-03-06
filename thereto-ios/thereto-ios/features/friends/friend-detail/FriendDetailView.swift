import UIKit

class FriendDetailView: BaseView {
    
    let backBtn = UIButton().then {
        $0.setImage(UIImage.init(named: "ic_back"), for: .normal)
    }
    
    let profileImg = UIImageView().then {
        $0.layer.cornerRadius = 56 * (UIScreen.main.bounds.width / 375) / 2
        $0.layer.masksToBounds = true
        $0.image = UIImage.init(named: "image_profile_default")
    }
    
    let nameLabel = UILabel().then {
        $0.textColor = .black30
        $0.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 19)
    }
    
    let favoriteBtn = UIButton().then {
        $0.setTitle("즐겨찾기", for: .normal)
        $0.setTitleColor(UIColor.init(r: 114, g: 95, b: 95), for: .normal)
        $0.titleLabel?.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 12)
    }
    
    let favoriteDot = UIButton().then {
        $0.layer.cornerRadius = 3
        $0.layer.masksToBounds = true
    }
    
    let whiteContainer = UIView().then {
        $0.backgroundColor = .white
    }
    
    let receivedLabel = UILabel().then {
        $0.text = "받은 엽서"
        $0.textColor = .brownishGrey
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
        $0.textColor = .brownishGrey
        $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 15)
        $0.textAlignment = .right
    }
    
    let sentCountLabel = UILabel().then {
        $0.text = "2"
        $0.textColor = .greyishBrown
        $0.font = UIFont.init(name: "FrankRuhlLibre-Black", size: 25)
    }
    
    let deleteBtn1 = UIButton().then {
        $0.setTitle("친구삭제", for: .normal)
        $0.setTitleColor(UIColor.init(r: 165, g: 156, b: 156), for: .normal)
        $0.titleLabel?.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 12)
    }
    
    let deleteBtn2 = UIButton().then {
        $0.setImage(UIImage.init(named: "ic_delete"), for: .normal)
    }
    
    let descLabel = UILabel().then {
        $0.text = "* 친구요청 수락 중입니다.\n수락 후 엽서쓰기, 친구삭제가 가능합니다."
        $0.numberOfLines = 0
        $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 12)
        $0.textColor = .brownishGrey
        $0.isHidden = true
    }
    
    let writeBtn = UIButton().then {
        $0.backgroundColor = .orangeRed
    }
    
    let writeLabel = UILabel().then {
        $0.text = "엽서 쓰기"
        $0.textColor = .white
        $0.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 17)
    }
    
    override func setup() {
        backgroundColor = .veryLightPink
        addSubViews(backBtn, profileImg, nameLabel, favoriteBtn, favoriteDot, whiteContainer,
                    receivedLabel, receivedCountLabel, sentLabel, sentCountLabel, deleteBtn1, deleteBtn2,
                    writeBtn, writeLabel, descLabel)
    }
    
    override func bindConstraints() {
        backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.left.equalToSuperview().offset(24)
            make.width.height.equalTo(24)
        }
        
        profileImg.snp.makeConstraints { (make) in
            make.left.equalTo(backBtn)
            make.top.equalTo(backBtn.snp.bottom).offset(68)
            make.width.height.equalTo(56 * UIScreen.main.bounds.width / 375)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImg)
            make.left.equalTo(profileImg.snp.right).offset(16)
        }
        
        favoriteBtn.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.equalTo(nameLabel)
        }
        
        favoriteDot.snp.makeConstraints { (make) in
            make.centerY.equalTo(favoriteBtn)
            make.left.equalTo(favoriteBtn.snp.right).offset(5)
            make.width.height.equalTo(6)
        }
        
        whiteContainer.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(96 * RatioUtils.width)
            make.right.equalToSuperview()
            make.top.equalTo(profileImg.snp.bottom).offset(40)
            make.height.equalTo(130)
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
        
        deleteBtn1.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(whiteContainer.snp.bottom).offset(20)
        }
        
        deleteBtn2.snp.makeConstraints { (make) in
            make.right.equalTo(deleteBtn1.snp.left).offset(-5)
            make.centerY.equalTo(deleteBtn1)
            make.width.height.equalTo(26)
        }
        
        writeBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-42)
            make.right.equalToSuperview()
            make.left.equalTo(whiteContainer)
            make.height.equalTo(60)
        }
        
        writeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(writeBtn)
            make.right.equalToSuperview().offset(-80)
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(writeBtn)
            make.bottom.equalTo(writeBtn.snp.top).offset(-24)
        }
    }
    
    private func setWriteBtnEnable(isEnable: Bool) {
        writeBtn.isEnabled = isEnable
        if isEnable {
            writeBtn.backgroundColor = .orangeRed
        } else {
            writeBtn.backgroundColor = .mushroomTwo
        }
    }
    
    func bind(friend: Friend?) {
        if let friend = friend {
            profileImg.kf.setImage(with: URL.init(string: friend.profileURL!), placeholder: UIImage.init(named: "image_profile_default"))
            nameLabel.text = "\(friend.nickname)"
            receivedCountLabel.text = "\(friend.receivedCount)"
            sentCountLabel.text = "\(friend.sentCount)"
            setWriteBtnEnable(isEnable: friend.requestState == .FRIEND)
            deleteBtn1.isHidden = friend.requestState != .FRIEND
            deleteBtn2.isHidden = friend.requestState != .FRIEND
            descLabel.isHidden = friend.requestState != .REQUEST_SENT
            favoriteDot.isEnabled = friend.favorite
            if (favoriteDot.isEnabled) {
                favoriteDot.backgroundColor = .orangeRed
            } else {
                favoriteDot.backgroundColor = .mushroom
            }
        }
    }
}
