import UIKit
import CoreLocation
import NMapsMap

class SelectLocationVC: BaseVC {
    
    private lazy var selectLocationView = SelectLocationView.init(frame: self.view.frame)
    
    var locationManager = CLLocationManager()
    
    private var mapAnimationFlag = false
    
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
    
    override func bindEvent() {
        selectLocationView.backBtn.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        selectLocationView.myLocationBtn.rx.tap.bind { [weak self] in
            self?.mapAnimationFlag = true
            self?.locationManager.startUpdatingLocation()
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
            self?.selectLocationView.addressLabel.text = address
        }
    }
}

extension SelectLocationVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: location!.coordinate.latitude - 0.005, lng: location!.coordinate.longitude))
        
        print("lat: \(location!.coordinate.latitude), lng: \(location!.coordinate.longitude)")
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

