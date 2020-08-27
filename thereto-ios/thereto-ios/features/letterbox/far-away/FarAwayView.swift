import UIKit
import NMapsMap

class FarAwayView: BaseView {
  
  let confirmButton = UIButton().then {
    $0.backgroundColor = .orangeRed
    $0.setTitle("far_away_confirm_button".localized, for: .normal)
    $0.titleLabel?.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 14)
    $0.setTitleColor(.white, for: .normal)
  }
  
  let descLabel = UILabel().then {
    $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 16)
    $0.textColor = .black49
    $0.numberOfLines = 0
    $0.text = "far_away_description".localized
  }
  
  let mapView = NMFNaverMapView().then {
    $0.isUserInteractionEnabled = false
    $0.showCompass = false
    $0.showScaleBar = false
    $0.showLocationButton = false
    $0.showZoomControls = false
  }
  
  let locationImage = UIImageView().then {
    $0.image = UIImage.init(named: "ic_location")
  }
  
  let locationName = UILabel().then {
    $0.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 12)
    $0.textColor = .brownishGrey
  }
  
  let addressLabel = UILabel().then {
    $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 12)
    $0.textColor = .brownishGrey
  }
  
  let containerView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.shadowColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.5).cgColor
    $0.layer.shadowRadius = 12
  }
  
  
  override func setup() {
    backgroundColor = .clear
    addSubViews(
      containerView, confirmButton, descLabel,
      mapView, locationImage, locationName, addressLabel
    )
  }
  
  override func bindConstraints() {
    confirmButton.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview().offset(-32)
      make.left.equalToSuperview().offset(24)
      make.right.equalToSuperview().offset(-24)
      make.height.equalTo(56)
    }
    
    descLabel.snp.makeConstraints { (make) in
      make.left.right.equalTo(confirmButton)
      make.bottom.equalTo(confirmButton.snp.top).offset(-14)
    }
    
    mapView.snp.makeConstraints { (make) in
      make.left.right.equalTo(confirmButton)
      make.bottom.equalTo(descLabel.snp.top).offset(-25)
      make.height.equalTo(210)
    }
    
    locationImage.snp.makeConstraints { (make) in
      make.left.equalTo(confirmButton)
      make.bottom.equalTo(mapView.snp.top).offset(-45)
      make.width.height.equalTo(14)
    }
    
    locationName.snp.makeConstraints { (make) in
      make.left.equalTo(locationImage.snp.right).offset(6)
      make.right.equalTo(confirmButton)
      make.centerY.equalTo(locationImage)
    }
    
    addressLabel.snp.makeConstraints { (make) in
      make.left.right.equalTo(locationName)
      make.top.equalTo(locationName.snp.bottom)
    }
    
    containerView.snp.makeConstraints { (make) in
      make.left.right.bottom.equalToSuperview()
      make.top.equalTo(locationImage).offset(-35)
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
