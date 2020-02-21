import UIKit

class PlaceTitleView: BaseView {
    let bg = UIView().then {
        $0.backgroundColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowRadius = 12
    }
    
    let closeBtn = UIButton().then {
        $0.setImage(UIImage.init(named: "ic_close"), for: .normal)
    }
    
    let titleLabel = UILabel().then {
        $0.text = "장소명을 입력해주세요!"
        $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 16)
        $0.textColor = .black49
    }
    
    let placeImg = UIImageView().then {
        $0.image = UIImage.init(named: "ic_location")
    }
    
    let placeField = UITextField().then {
        $0.placeholder = "장소명(10자 이내)"
        $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 14)
        $0.textColor = .mushroom
    }
    
    let underLine = UIView().then {
        $0.backgroundColor = .mudBrown
    }
    
    let confirmBtn = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 14)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .orangeRed
    }
    
    let swipeDownGesture = UISwipeGestureRecognizer().then {
        $0.direction = .down
    }
    
    override func setup() {
        backgroundColor = .clear
        addSubViews(bg, closeBtn, titleLabel, placeImg, placeField, underLine, confirmBtn)
        addGestureRecognizer(swipeDownGesture)
    }
    
    override func bindConstraints() {
        bg.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(521)
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(bg).offset(24)
            make.right.equalToSuperview().offset(-24)
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(closeBtn.snp.bottom).offset(23)
        }
        
        placeImg.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.width.height.equalTo(14)
            make.top.equalTo(titleLabel.snp.bottom).offset(36)
        }
        
        placeField.snp.makeConstraints { (make) in
            make.left.equalTo(placeImg.snp.right).offset(10)
            make.centerY.equalTo(placeImg)
            make.right.equalToSuperview().offset(-95)
        }
        
        underLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(placeField)
            make.top.equalTo(placeField.snp.bottom).offset(12)
            make.height.equalTo(1)
        }
        
        confirmBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.left.equalToSuperview().offset(87 * RatioUtils.width)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().offset(-72)
        }
    }
}
