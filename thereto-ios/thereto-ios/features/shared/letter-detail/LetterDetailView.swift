import UIKit
import NMapsMap

class LetterDetailView: BaseView {
    
    let backBtn = UIButton().then {
        $0.setImage(UIImage.init(named: "ic_back"), for: .normal)
    }
    
    let replyBtn = UIButton().then {
        $0.setTitle("reply", for: .normal)
        $0.titleLabel?.font = UIFont.init(name: "FrankRuhlLibre-Black", size: 21)
        $0.setTitleColor(.black30, for: .normal)
    }
    
    let scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
    }
    
    let containerView = UIView()
    
    let mainPhoto = UIImageView().then {
        $0.backgroundColor = .black30
        $0.contentMode = .scaleAspectFill
    }
    
    let mainPhotoContainer = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let whiteContainer = UIView().then {
        $0.backgroundColor = .white
    }
    
    let dateLabel = UILabel().then {
        $0.text = "2019-06-11"
        $0.font = UIFont.init(name: "FrankRuhlLibre-Black", size: 14)
        $0.textColor = UIColor.init(r: 30, g: 30, b: 30)
        $0.transform = CGAffineTransform(rotationAngle: CGFloat.pi * -90 / 180.0)
        $0.alpha = 0.61
    }
    
    let toProfileImg = UIImageView().then {
        $0.backgroundColor = .black30
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        $0.image = UIImage.init(named: "image_profile_default")
    }
    
    let toUserLabel = UILabel().then {
        $0.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 14)
        $0.textColor = .black30
        $0.text = "to. 김민경"
    }
    
    let messageLabel = UITextView().then {
        $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 19)
        $0.textColor = .greyishBrownTwo
        $0.text = "강릉에 여행왔는데,\n너 생각이 나서 편지썼어\n잘 지내고 있지? 옛날에 나랑 너랑 안목해변에서 맨발로 놀았던거 기억나? 그때 너무 재밌었는데\n다시 오면 좋겠다~\n다시 오면 좋겠다~\n다시 오면 좋겠다~"
    }
    
    let fromProfileImg = UIImageView().then {
        $0.backgroundColor = .black30
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        $0.image = UIImage.init(named: "image_profile_default")
    }
    
    let fromUserLabel = UILabel().then {
        $0.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 14)
        $0.textColor = .black30
        $0.text = "from. 김민경"
    }
    
    let redDot = UIView().then {
        $0.backgroundColor = .orangeRed
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
    }
    
    let locationImg = UIImageView().then {
        $0.image = UIImage.init(named: "ic_location")
    }
    
    let locationName = UILabel().then {
        $0.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 12)
        $0.textColor = .brownishGrey
        $0.text = "빵선생 행당점에서"
    }
    
    let addressLabel = UILabel().then {
        $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 12)
        $0.textColor = .brownishGrey
        $0.text = "서울특별시 성동구 뚝섬로1길 25 (성수동1가)"
    }
    
    let mapView = NMFNaverMapView().then {
        $0.isUserInteractionEnabled = false
        $0.showCompass = false
        $0.showScaleBar = false
        $0.showLocationButton = false
        $0.showZoomControls = false
    }
    
    let deleteBtn = UIButton().then {
        $0.setImage(UIImage.init(named: "ic_delete"), for: .normal)
    }
    
    override func setup() {
        backgroundColor = .veryLightPink
        containerView.addSubViews(mainPhotoContainer, whiteContainer, dateLabel, toProfileImg, toUserLabel,
                                  messageLabel, fromProfileImg, fromUserLabel, redDot, locationImg,
                                  locationName, addressLabel, mapView, deleteBtn)
        scrollView.addSubViews(mainPhoto, containerView)
        addSubViews(backBtn, replyBtn, scrollView)
    }
    
    override func bindConstraints() {
        backBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.width.height.equalTo(24)
        }
        
        replyBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(backBtn)
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(backBtn.snp.bottom).offset(14)
            make.bottom.equalToSuperview()
        }
        
        mainPhotoContainer.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(280)
        }
        
        mainPhoto.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(backBtn.snp.bottom).offset(14)
            make.bottom.equalTo(mainPhotoContainer)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(mainPhoto.snp.bottom).offset(62)
        }
        
        whiteContainer.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(48)
            make.top.equalTo(mainPhoto.snp.bottom).offset(-40)
        }
        
        toProfileImg.snp.makeConstraints { (make) in
            make.left.equalTo(whiteContainer).offset(24)
            make.top.equalTo(whiteContainer).offset(24)
            make.width.height.equalTo(32)
        }
        
        toUserLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(toProfileImg)
            make.left.equalTo(toProfileImg.snp.right).offset(12)
        }
        
        messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(toProfileImg)
            make.right.equalToSuperview().offset(-39)
            make.top.equalTo(toProfileImg.snp.bottom).offset(9)
            make.height.greaterThanOrEqualTo(250)
        }
        
        fromProfileImg.snp.makeConstraints { (make) in
            make.left.equalTo(toProfileImg)
            make.top.equalTo(messageLabel.snp.bottom).offset(18)
            make.width.height.equalTo(32)
        }
        
        fromUserLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(fromProfileImg)
            make.left.equalTo(fromProfileImg.snp.right).offset(12)
        }
        
        redDot.snp.makeConstraints { (make) in
            make.left.equalTo(fromUserLabel.snp.right)
            make.centerY.equalTo(fromUserLabel.snp.top)
            make.width.height.equalTo(8)
        }
        
        locationImg.snp.makeConstraints { (make) in
            make.left.equalTo(fromProfileImg)
            make.top.equalTo(fromProfileImg.snp.bottom).offset(15)
            make.width.equalTo(15)
            make.height.equalTo(16)
        }
        
        locationName.snp.makeConstraints { (make) in
            make.top.equalTo(locationImg)
            make.left.equalTo(locationImg.snp.right).offset(4)
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(locationName)
            make.top.equalTo(locationName.snp.bottom)
        }
        
        mapView.snp.makeConstraints { (make) in
            make.left.equalTo(locationImg)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(144)
            make.top.equalTo(addressLabel.snp.bottom).offset(8)
        }
        
        deleteBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-35)
            make.width.height.equalTo(24)
        }
        
        whiteContainer.snp.remakeConstraints { (make) in
            make.right.equalToSuperview()
            make.left.equalToSuperview().offset(48)
            make.top.equalTo(mainPhoto.snp.bottom).offset(-40)
            make.bottom.equalTo(mapView).offset(43)
        }
        
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
            make.width.equalTo(frame.width)
            make.top.equalToSuperview()
            make.bottom.equalTo(whiteContainer)
        }
    }
    
    func bind(letter: Letter) {
        mainPhoto.kf.setImage(with: URL.init(string: letter.photo))
        dateLabel.text = String(letter.createdAt.prefix(10))
        
        if let toURL = letter.to.profileURL,
            !toURL.isEmpty {
            toProfileImg.kf.setImage(with: URL.init(string: toURL))
        } else {
            toProfileImg.image = UIImage(named: "image_profile_default")
            
        }
        toUserLabel.text = "to. \(letter.to.nickname)"
        messageLabel.text = letter.message
        
        if let fromURL = letter.from.profileURL,
            !fromURL.isEmpty {
            fromProfileImg.kf.setImage(with: URL.init(string: letter.from.profileURL!))
        } else {
            fromProfileImg.image = UIImage(named: "image_profile_default")
        }
        fromUserLabel.text = "from. \(letter.from.nickname)"
        locationName.text = letter.location.name
        addressLabel.text = letter.location.addr
        setMarker(latitude: letter.location.latitude, longitude: letter.location.longitude)
    }
    
    private func setMarker(latitude: Double, longitude: Double) {
        let marker = NMFMarker().then {
            $0.position = NMGLatLng(lat: latitude, lng: longitude)
            $0.iconImage = NMFOverlayImage.init(name: "ic_spot")
        }
        marker.mapView = mapView.mapView
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude))
        mapView.mapView.moveCamera(cameraUpdate)
    }
}
