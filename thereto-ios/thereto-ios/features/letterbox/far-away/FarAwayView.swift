import UIKit
import NMapsMap

class FarAwayView: BaseView {
    
    let confirmBtn = UIButton().then {
        $0.backgroundColor = .orangeRed
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 14)
        $0.setTitleColor(.white, for: .normal)
    }
    
    let descLabel = UILabel().then {
        $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 16)
        $0.textColor = .black49
        $0.numberOfLines = 0
        $0.text = "엽서가 저장된 장소에서 반경 300m 안에 위치해야 엽서를 읽을 수 있습니다.\n위치 이동 후 다시 시도해주세요."
    }
    
    let mapView = NMFNaverMapView().then {
        $0.isUserInteractionEnabled = false
        $0.showCompass = false
        $0.showScaleBar = false
        $0.showLocationButton = false
        $0.showZoomControls = false
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
    
    let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.shadowColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.5).cgColor
        $0.layer.shadowRadius = 12
    }
    
    
    override func setup() {
        backgroundColor = .clear
        addSubViews(containerView, confirmBtn, descLabel, mapView, locationImg, locationName, addressLabel)
    }
    
    override func bindConstraints() {
        confirmBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-32)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(56)
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(confirmBtn)
            make.bottom.equalTo(confirmBtn.snp.top).offset(-14)
        }
        
        mapView.snp.makeConstraints { (make) in
            make.left.right.equalTo(confirmBtn)
            make.bottom.equalTo(descLabel.snp.top).offset(-25)
            make.height.equalTo(210)
        }
        
        locationImg.snp.makeConstraints { (make) in
            make.left.equalTo(confirmBtn)
            make.bottom.equalTo(mapView.snp.top).offset(-45)
            make.width.height.equalTo(14)
        }
        
        locationName.snp.makeConstraints { (make) in
            make.left.equalTo(locationImg.snp.right).offset(6)
            make.right.equalTo(confirmBtn)
            make.centerY.equalTo(locationImg)
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(locationName)
            make.top.equalTo(locationName.snp.bottom)
        }
        
        containerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(locationImg).offset(-35)
        }
    }
    
    func bind(letter: Letter) {
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
