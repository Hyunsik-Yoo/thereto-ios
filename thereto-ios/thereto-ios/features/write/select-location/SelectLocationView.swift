import UIKit
import NMapsMap

class SelectLocationView: BaseView {
    
    let backBtn = UIButton().then {
        $0.setImage(UIImage.init(named: "ic_back"), for: .normal)
    }
    
    let mapView = NMFNaverMapView().then {
        $0.positionMode = .normal
        $0.showLocationButton = false
        $0.showZoomControls = false
        $0.showScaleBar = false
    }
    
    let whiteBg = UIView().then {
        $0.backgroundColor = .white
    }
    
    let myLocationBtn = UIButton().then {
        $0.backgroundColor = .white
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 2
        $0.setImage(UIImage.init(named: "ic_my_location"), for: .normal)
    }
    
    let brownLine = UIView().then {
        $0.backgroundColor = .mudBrown
    }
    
    let locationImg = UIImageView().then {
        $0.image = UIImage.init(named: "ic_location")
    }
    
    let placeLabel = UILabel().then {
        $0.text = "장소"
        $0.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 14)
        $0.textColor = .brownishGrey
    }
    
    let addressLabel = UILabel().then {
        $0.text = "서울특별시 성동구 뚝섬로1길 25 (성수동 1가)"
        $0.textColor = .brownishGrey
        $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 14)
    }
    
    let confirmBtn = UIButton().then {
        $0.backgroundColor = .orangeRed
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 14)
        $0.setTitleColor(.white, for: .normal)
    }
    
    let selectLocationBtn = UIButton().then {
        $0.setTitle("이 장소가 아닌가요?", for: .normal)
        $0.setTitleColor(.brownGrey, for: .normal)
        $0.titleLabel?.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 15)
    }
    
    
    override func setup() {
        backgroundColor = .themeColor
        addSubViews(backBtn, mapView, whiteBg, myLocationBtn, brownLine, locationImg,
                    placeLabel, addressLabel, confirmBtn, selectLocationBtn)
    }
    
    override func bindConstraints() {
        backBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.width.height.equalTo(24)
        }
        
        mapView.snp.makeConstraints { (make) in
            make.top.equalTo(backBtn.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
        
        whiteBg.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(39 * RatioUtils.width)
            make.height.equalTo(212)
        }
        
        myLocationBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(whiteBg.snp.top).offset(-16)
            make.width.height.equalTo(40)
        }
        
        brownLine.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(whiteBg)
            make.height.equalTo(1)
        }
        
        locationImg.snp.makeConstraints { (make) in
            make.left.equalTo(whiteBg).offset(24)
            make.top.equalTo(whiteBg).offset(24)
            make.width.height.equalTo(16)
        }
        
        placeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(locationImg)
            make.left.equalTo(locationImg.snp.right).offset(8)
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(placeLabel)
            make.top.equalTo(placeLabel.snp.bottom)
        }
        
        confirmBtn.snp.makeConstraints { (make) in
            make.left.equalTo(placeLabel)
            make.right.equalToSuperview()
            make.top.equalTo(addressLabel.snp.bottom).offset(16)
            make.height.equalTo(56)
        }
        
        selectLocationBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-5)
        }
    }
}
