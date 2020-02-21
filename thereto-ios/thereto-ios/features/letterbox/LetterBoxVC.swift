import UIKit
import CoreLocation

class LetterBoxVC: BaseVC {
    
    private lazy var letterBoxView = LetterBoxView.init(frame: self.view.frame)
    
    private var viewModel = LetterBoxViewModel.init()
    
    private var locationManager = CLLocationManager()
    
    private var myLocation: CLLocation!
    
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
    
    
    static func instance() -> UINavigationController {
        let controller = LetterBoxVC(nibName: nil, bundle: nil).then {
            $0.tabBarItem = UITabBarItem.init(title: "수신함", image: UIImage.init(named: "ic_letter_box_off"), selectedImage: UIImage.init(named: "ic_letter_box_on"))
        }
        
        return UINavigationController(rootViewController: controller)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view = letterBoxView
        
        letterBoxView.topBar.setLetterBoxMode()
        setupTableView()
        setupLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLetters()
    }
    
    override func bindViewModel() {
        viewModel.letters.bind(to: letterBoxView.tableView.rx.items(cellIdentifier: LetterCell.registerId, cellType: LetterCell.self)) { row, letter, cell in
            cell.bind(letter: letter, isSentLetter: false)
        }.disposed(by: disposeBag)
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupTableView() {
        letterBoxView.tableView.delegate = self
        letterBoxView.tableView.register(LetterCell.self, forCellReuseIdentifier: LetterCell.registerId)
    }
    
    private func getLetters() {
        letterBoxView.startLoading()
        LetterSerivce.getLetters { [weak self] (result) in
            switch result {
            case .success(let letters):
                self?.letterBoxView.setEmpty(isEmpty: letters.isEmpty)
                self?.viewModel.letters.onNext(letters)
            case .failure(let error):
                if let vc = self {
                    AlertUtil.show(controller: vc, title: "error", message: error.localizedDescription)
                }
            }
            self?.letterBoxView.stopLoading()
        }
    }
    
    private func getDistanceToLetter(latitude: Double, longitude: Double) -> Int {
        let letterLocation = CLLocation.init(latitude: latitude, longitude: longitude)
        
        return Int(myLocation.distance(from: letterLocation))
    }
}

extension LetterBoxVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let letters = try? self.viewModel.letters.value() {
            let letter = letters[indexPath.row]
            
            if getDistanceToLetter(latitude: letter.location.latitude, longitude: letter.location.longitude) <= 300 {
                self.navigationController?.pushViewController(LetterDetailVC.instance(letter: letter), animated: true)
            } else {
                self.letterBoxView.addBgDim()
                let farAwayVC = FarAwayVC.instance(letter: letter, myLocation: myLocation).then {
                    $0.delegate = self
                }
                self.present(farAwayVC, animated: true, completion: nil)
            }
        }
    }
}

extension LetterBoxVC: FarAwayDelegate {
    func onClose() {
        self.letterBoxView.removeBgDim()
    }
}

extension LetterBoxVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.myLocation = locations.last
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

