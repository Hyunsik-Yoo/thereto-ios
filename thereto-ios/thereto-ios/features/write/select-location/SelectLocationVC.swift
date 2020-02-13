import UIKit
import CoreLocation
import NMapsMap

class SelectLocationVC: BaseVC {
    
    private lazy var selectLocationView = SelectLocationView.init(frame: self.view.frame)
    
    private var viewModel = SelectLocationViewModel()
    
    private var mapAnimationFlag = false
    
    private var locationManager = CLLocationManager()
    
    private var currentLocation: (latitude: Double, longitude: Double)!
    
    
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
    }
    
    override func bindViewModel() {
        viewModel.address.bind(to: selectLocationView.addressLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.marker.subscribe(onNext: { [weak self] (marker) in
            if let vc = self {
                marker.mapView = vc.selectLocationView.mapView.mapView
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
            self?.selectLocationView.addBgDim()
            
            let controller = PlaceTitleVC.instance().then {
                $0.delegate = self
            }
            self?.present(controller, animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
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
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: location!.coordinate.latitude - 0.005, lng: location!.coordinate.longitude))
        
        currentLocation = (location!.coordinate.latitude, location!.coordinate.longitude)
        
        if self.mapAnimationFlag {
            cameraUpdate.animation = .easeIn
        }
        self.selectLocationView.mapView.mapView.moveCamera(cameraUpdate)
        self.getAddress(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if (error as NSError).code == 1 {
            AlertUtil.showWithCancel(title: "위치 권한 오류", message: "설정 > 가슴속 3천원 > 위치 > 앱을 사용하는 동안으로 선택해주세요.") {
                UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
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
    func onClose() {
        self.selectLocationView.removeBgDim()
    }
}

