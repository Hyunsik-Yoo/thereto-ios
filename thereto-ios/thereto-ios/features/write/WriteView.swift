import UIKit

class WriteView: BaseView {
  let tapBg = UITapGestureRecognizer()
  
  let topBg = UIView().then {
    $0.backgroundColor = .veryLightPink
  }
  
  let closeButton = UIButton().then {
    $0.setImage(UIImage.init(named: "ic_close"), for: .normal)
  }
  
  let sendButton = UIButton().then {
    $0.setTitle("send", for: .normal)
    $0.titleLabel?.font = UIFont.init(name: "FrankRuhlLibre-Black", size: 21)
    $0.setTitleColor(.black30, for: .normal)
  }
  
  let navigationLine = UIView().then {
    $0.backgroundColor = .mudBrown
  }
  
  let scrollView = UIScrollView()
  
  let containerView = UIView()
  
  let manImage = UIImageView().then {
    $0.image = UIImage.init(named: "ic_man")
  }
  
  let friendButton = UIButton().then {
    $0.setTitle("write_friend_button".localized, for: .normal)
    $0.setTitleColor(.mushroom, for: .normal)
    $0.titleLabel?.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 14)
  }
  
  let line1 = UIView().then {
    $0.backgroundColor = .pinkishGrey
  }
  
  let locationImage = UIImageView().then {
    $0.image = UIImage.init(named: "ic_location")
  }
  
  let locationButton = UIButton().then {
    $0.setTitle("write_location_button".localized, for: .normal)
    $0.setTitleColor(.mushroom, for: .normal)
    $0.contentHorizontalAlignment = .left
    $0.titleLabel?.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 14)
  }
  
  let line2 = UIView().then {
    $0.backgroundColor = .pinkishGrey
  }
  
  let pictureImage = UIImageView().then {
    $0.image = UIImage.init(named: "ic_picture")
  }
  
  let pictureButton = UIButton().then {
    $0.setTitle("write_picture_button".localized, for: .normal)
    $0.setTitleColor(.mushroom, for: .normal)
    $0.contentHorizontalAlignment = .left
    $0.titleLabel?.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 14)
  }
  
  let pictureImgButton = UIButton().then {
    $0.isHidden = true
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  let line3 = UIView().then {
    $0.backgroundColor = .pinkishGrey
  }
  
  let textField = UITextView().then {
    $0.text = "write_text_field".localized
    $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 19)
    $0.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 10, right: 0)
    $0.backgroundColor = .clear
    $0.textColor = .mushroom
  }
  
  let toastLabel = UILabel().then {
    $0.backgroundColor = .greyishBrownThree
    $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 14)
    $0.textColor = .white
    $0.textAlignment = .center
    $0.alpha = 0
  }
  
  
  override func setup() {
    backgroundColor = .themeColor
    addGestureRecognizer(tapBg)
    containerView.addSubViews(
      manImage, friendButton, line1, locationImage, locationButton,
      line2, pictureImage, pictureButton, pictureImgButton, line3, textField
    )
    scrollView.addSubViews(containerView)
    addSubViews(topBg, closeButton, sendButton, navigationLine, scrollView)
  }
  
  override func bindConstraints() {
    topBg.snp.makeConstraints { (make) in
      make.left.right.equalToSuperview()
      make.top.equalTo(safeAreaLayoutGuide)
      make.height.equalTo(56)
    }
    
    closeButton.snp.makeConstraints { (make) in
      make.left.equalToSuperview().offset(24)
      make.bottom.equalTo(topBg).offset(-16)
      make.width.height.equalTo(24)
    }
    
    sendButton.snp.makeConstraints { (make) in
      make.centerY.equalTo(closeButton)
      make.right.equalToSuperview().offset(-24)
    }
    
    navigationLine.snp.makeConstraints { (make) in
      make.left.right.equalToSuperview()
      make.height.equalTo(1)
      make.top.equalTo(closeButton.snp.bottom).offset(16)
    }
    
    scrollView.snp.makeConstraints { (make) in
      make.left.right.bottom.equalToSuperview()
      make.top.equalTo(navigationLine.snp.bottom)
    }
    
    manImage.snp.makeConstraints { (make) in
      make.left.equalToSuperview().offset(24)
      make.top.equalToSuperview().offset(20)
      make.width.height.equalTo(16)
    }
    
    friendButton.snp.makeConstraints { (make) in
      make.centerY.equalTo(manImage)
      make.left.equalTo(manImage.snp.right).offset(16)
    }
    
    line1.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.right.equalToSuperview().offset(-20)
      make.height.equalTo(1)
      make.top.equalTo(manImage.snp.bottom).offset(19)
    }
    
    locationImage.snp.makeConstraints { (make) in
      make.left.equalTo(manImage)
      make.top.equalTo(line1.snp.bottom).offset(20)
      make.width.height.equalTo(16)
    }
    
    locationButton.snp.makeConstraints { (make) in
      make.left.equalTo(locationImage.snp.right).offset(16)
      make.right.equalToSuperview().offset(-20)
      make.centerY.equalTo(locationImage)
    }
    
    line2.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.right.equalToSuperview().offset(-20)
      make.height.equalTo(1)
      make.top.equalTo(locationImage.snp.bottom).offset(19)
    }
    
    pictureImage.snp.makeConstraints { (make) in
      make.left.equalTo(locationImage)
      make.width.equalTo(16)
      make.top.equalTo(line2.snp.bottom).offset(36)
    }
    
    pictureButton.snp.makeConstraints { (make) in
      make.left.equalTo(pictureImage.snp.right).offset(16)
      make.centerY.equalTo(pictureImage)
      make.height.equalTo(56)
    }
    
    pictureImgButton.snp.makeConstraints { (make) in
      make.left.equalTo(pictureButton)
      make.centerY.equalTo(pictureImage)
      make.height.equalTo(56)
      make.width.equalTo(75)
    }
    
    line3.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.right.equalToSuperview().offset(-20)
      make.height.equalTo(1)
      make.top.equalTo(pictureImage.snp.bottom).offset(36)
    }
    
    textField.snp.makeConstraints { (make) in
      make.left.equalToSuperview().offset(20)
      make.right.equalToSuperview().offset(-20)
      make.bottom.equalToSuperview().offset(-20)
      make.top.equalTo(line3.snp.bottom).offset(20)
    }
    
    containerView.snp.makeConstraints { (make) in
      make.edges.equalTo(0)
      make.width.height.equalToSuperview()
    }
  }
  
  func showToast(message: String) {
    toastLabel.text = message
    
    addSubview(toastLabel)
    toastLabel.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
      make.left.equalToSuperview().offset(24)
      make.right.equalToSuperview().offset(-24)
      make.height.equalTo(48)
    }
    
    UIView.animate(withDuration: 0.5) { [weak self] in
      self?.toastLabel.alpha = 1
    }
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
      self?.removeToast()
    }
  }
  
  func removeToast() {
    UIView.animate(withDuration: 0.5, animations: { [weak self] in
      self?.toastLabel.alpha = 0
    }) { [weak self] (_) in
      self?.toastLabel.removeFromSuperview()
    }
  }
  
  func bind(user: User?) {
    if user != nil { 
    }
  }
}
