import UIKit
import CoreLocation
import NMapsMap

class SelectLocationVC: BaseVC {
    
    private lazy var selectLocationView = SelectLocationView.init(frame: self.view.frame)
    
    var locationManager = CLLocationManager()
    
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
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension SelectLocationVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: location!.coordinate.latitude - 0.005, lng: location!.coordinate.longitude))
        
        print("lat: \(location!.coordinate.latitude), lng: \(location!.coordinate.longitude)")
        self.selectLocationView.mapView.mapView.moveCamera(cameraUpdate)
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

