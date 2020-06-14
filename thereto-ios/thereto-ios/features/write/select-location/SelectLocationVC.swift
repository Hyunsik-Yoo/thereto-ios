import UIKit
import CoreLocation
import NMapsMap

protocol SelectLocationDelegate: class {
    func onSelectLocation(location: Location)
}

class SelectLocationVC: BaseVC {
    
    private lazy var selectLocationView = SelectLocationView.init(frame: self.view.frame)
    
    private var viewModel = SelectLocationViewModel()
    
    private var mapAnimationFlag = false
    
    private var locationManager = CLLocationManager()
    
    private var currentLocation: (latitude: Double, longitude: Double)!
    
    var delegate: SelectLocationDelegate?
    
    
    static func instance() -> SelectLocationVC {
        return SelectLocationVC.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = selectLocationView
        setupLocationManager()
        selectLocationView.mapView.delegate = self
    }
    
    override func bindViewModel() {
        viewModel.address.bind(to: selectLocationView.addressLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.marker.subscribe(onNext: { [weak self] (marker) in
            if let vc = self {
                marker.mapView = vc.selectLocationView.mapView.mapView
            }
        }).disposed(by: disposeBag)
        
        viewModel.myLocation.subscribe (onNext: { [weak self] (myLocation) in
            if let vc = self {
                myLocation.mapView = vc.selectLocationView.mapView.mapView
            }
        }).disposed(by: disposeBag)
        
        viewModel.myCircle.subscribe(onNext: { [weak self] (myCircle) in
            if let vc = self {
                myCircle?.mapView = vc.selectLocationView.mapView.mapView
            }
        }).disposed(by: disposeBag)
    }
    
    override func bindEvent() {
        selectLocationView.backBtn.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        selectLocationView.myLocationBtn.rx.tap.bind { [weak self] in
            self?.mapAnimationFlag = true
            self?.locationManager.startUpdatingLocation()
        }.disposed(by: disposeBag)
        
        selectLocationView.selectLocationBtn.rx.tap.bind { [weak self] in
            if let vc = self {
                let controller = FindAddressVC.instance().then {
                    $0.delegate = vc
                }
                self?.navigationController?.pushViewController(controller, animated: true)
            }
        }.disposed(by: disposeBag)
        
        selectLocationView.confirmBtn.rx.tap.bind { [weak self] in
            if let vc = self {
                if vc.isIn300m() {
                    self?.selectLocationView.addBgDim()
                    
                    let controller = PlaceTitleVC.instance().then {
                        $0.delegate = self
                    }
                    self?.present(controller, animated: true, completion: nil)
                } else {
                    AlertUtil.show(controller: vc, title: "위치선택오류", message: "현재 위치 기준 300m 밖의 장소는 선택할 수 없습니다.")
                }
            }
        }.disposed(by: disposeBag)
    }
    
    private func isIn300m() -> Bool {
        let currentPosition = NMGLatLng.init(lat: currentLocation.0, lng: currentLocation.1)
        let distance = selectLocationView.mapView.mapView.cameraPosition.target.distance(to: currentPosition)
        
        return Int(distance) <= 300
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupMyLocation(lat: Double, lng: Double) {
        if let oldMyLocation = try? self.viewModel.myLocation.value() {
            oldMyLocation.mapView = nil
        }
        let myLocation = NMGLatLng.init(lat: lat, lng: lng)
        
        self.viewModel.myLocation.onNext(NMFMarker.init(position: myLocation, iconImage: NMFOverlayImage.init(name: "ic_my_position")))
        
        
        if let oldMyCircle = try? self.viewModel.myCircle.value() {
            oldMyCircle.mapView = nil
        }
        let circle = NMFCircleOverlay.init(myLocation, radius: 300).then {
            $0.fillColor = UIColor.init(r: 106, g: 38, b: 255, a: 0.21)
        }
        self.viewModel.myCircle.onNext(circle)
    }
    
    private func getAddress(latitude: Double, longitude: Double) {
        MapService.getAddressFromLocation(latitude: latitude, longitude: longitude) { [weak self] (address) in
            self?.viewModel.address.onNext(address)
        }
    }
    
    private func getLocationFromAddress(address: String) {
        MapService.getLocationFromAddress(address: address, currentLocation: currentLocation) {[weak self] (longitude, latitude, distance) in
            if let vc = self {
                // 기존에 있던 마커 지우기
                let oldMarker = try! vc.viewModel.marker.value()
                
                oldMarker.mapView = nil
                
                if distance > 300 {
                    AlertUtil.show(controller: vc, title: "위치선택오류", message: "현재 위치 기준 300m 밖의 장소는 선택할 수 없습니다.")
                } else {
                    let marker = NMFMarker().then {
                        $0.position = NMGLatLng(lat: latitude, lng: longitude)
                        $0.iconImage = NMFOverlayImage.init(name: "ic_spot")
                    }
                    
                    let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude - 0.005, lng: longitude))
                    cameraUpdate.animation = .easeIn
                    vc.selectLocationView.mapView.mapView.moveCamera(cameraUpdate)
                    vc.viewModel.marker.onNext(marker)
                }
            }
        }
    }
    
    
}

extension SelectLocationVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: location!.coordinate.latitude, lng: location!.coordinate.longitude))
        
        self.setupMyLocation(lat: location!.coordinate.latitude, lng: location!.coordinate.longitude)
        currentLocation = (location!.coordinate.latitude, location!.coordinate.longitude)
        
        if self.mapAnimationFlag {
            cameraUpdate.animation = .easeIn
        }
        self.selectLocationView.mapView.mapView.moveCamera(cameraUpdate)
        self.getAddress(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if (error as NSError).code == 1 { // 위치 권한 오류
            AlertUtil.showWithCancel(title: "위치 권한 오류", message: "설정 > thereto > 위치 > 앱을 사용하는 동안으로 선택해주세요.") {
            }
        } else {
            AlertUtil.show("error locationManager", message: error.localizedDescription)
        }
    }
}

extension SelectLocationVC: FindAddressDelegate {
    func onSelectAddress(juso: Juso) {
        // 주소 받아서 좌표 찍기
        self.getLocationFromAddress(address: juso.roadAddr)
        
        // 도로명 주소 입력
        self.selectLocationView.addressLabel.text = juso.roadAddr
    }
}

extension SelectLocationVC: PlaceTitleDelegate {
    func onSelectName(name: String) {
        self.selectLocationView.removeBgDim()
        
        let location = Location.init(name: name, addr: self.selectLocationView.addressLabel.text!, latitude: currentLocation.0, longitude: currentLocation.1)
        self.delegate?.onSelectLocation(location: location)
        self.navigationController?.popViewController(animated: true)
    }
    
    func onClose() {
        self.selectLocationView.removeBgDim()
    }
}

extension SelectLocationVC: NMFMapViewDelegate {
    func mapViewIdle(_ mapView: NMFMapView) {
        self.getAddress(latitude: mapView.latitude, longitude: mapView.longitude)
    }
}
