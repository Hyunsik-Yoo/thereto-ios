import UIKit
import CoreLocation
import NMapsMap

protocol FarAwayDelegate: class {
    func onClose()
}

class FarAwayVC: BaseVC {
    
    private lazy var farAwayView = FarAwayView.init(frame: self.view.frame)
    
    weak var delegate: FarAwayDelegate?
    
    var myLocation: CLLocation!
    var letter: Letter!
    var myMarker: NMFMarker?
    var circle: NMFCircleOverlay?
    
    
    static func instance(letter: Letter, myLocation: CLLocation) -> FarAwayVC {
        return FarAwayVC.init(nibName: nil, bundle: nil).then {
            $0.modalPresentationStyle = .overFullScreen
            $0.letter = letter
            $0.myLocation = myLocation
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = farAwayView
        farAwayView.bind(letter: letter)
        setupMyLocation(lat: myLocation.coordinate.latitude, lng: myLocation.coordinate.longitude)
    }
    
    override func bindEvent() {
        farAwayView.confirmBtn.rx.tap.bind { [weak self] in
            self?.delegate?.onClose()
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
    
    private func setupMyLocation(lat: Double, lng: Double) {
        let myLocation = NMGLatLng.init(lat: lat, lng: lng)
        
        myMarker?.mapView = nil
        myMarker = NMFMarker.init(position: myLocation, iconImage: NMFOverlayImage.init(name: "ic_my_position"))
        
        myMarker?.mapView = farAwayView.mapView.mapView
        
        circle?.mapView = nil
        circle = NMFCircleOverlay.init(myLocation, radius: 300).then {
            $0.fillColor = UIColor.init(r: 106, g: 38, b: 255, a: 0.21)
        }
        circle?.mapView = farAwayView.mapView.mapView
    }
}
