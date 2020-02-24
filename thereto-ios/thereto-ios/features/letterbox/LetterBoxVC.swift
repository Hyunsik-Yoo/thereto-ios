import UIKit
import CoreLocation

class LetterBoxVC: BaseVC {
    
    private lazy var letterBoxView = LetterBoxView.init(frame: self.view.frame)
    
    private var viewModel = LetterBoxViewModel.init()
    
    private var locationManager = CLLocationManager()
    
    private var myLocation: CLLocation!
    
    private var myInfo: User!
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
    
    
    static func instance() -> UINavigationController {
        let controller = LetterBoxVC(nibName: nil, bundle: nil).then {
            $0.tabBarItem = UITabBarItem.init(title: "수신함", image: UIImage.init(named: "ic_letter_box_off"), selectedImage: UIImage.init(named: "ic_letter_box_on"))
        }
        
        return UINavigationController(rootViewController: controller).then {
            $0.interactivePopGestureRecognizer?.delegate = nil
        }
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
        if !UserDefaultsUtil.isTutorialFinished() {
            getMyInfo()
        } else {
            getLetters()
        }
    }
    
    override func bindViewModel() {
        viewModel.letters.bind(to: letterBoxView.tableView.rx.items(cellIdentifier: LetterCell.registerId, cellType: LetterCell.self)) { row, letter, cell in
            cell.bind(letter: letter, isSentLetter: false)
        }.disposed(by: disposeBag)
    }
    
    override func bindEvent() {
        letterBoxView.topBar.searchBtn.rx.tap.bind { [weak self] in
            self?.navigationController?.pushViewController(LetterSearchVC.instance(type: "to"), animated: true)
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
    
    private func getMyInfo() {
        UserService.getMyUser { [weak self] (user) in
            self?.myInfo = user
            self?.getLetters()
        }
    }
    
    private func getLetters() {
        letterBoxView.startLoading()
        LetterSerivce.getLetters { [weak self] (result) in
            if let vc = self {
                switch result {
                case .success(var letters):
                    if !UserDefaultsUtil.isTutorialFinished() {
                        // 튜토리얼 카드 넣어야합니다.
                        letters.insert(vc.getTutorialCard(), at: 0)
                    }
                    self?.letterBoxView.setEmpty(isEmpty: letters.isEmpty)
                    self?.viewModel.letters.onNext(letters)
                case .failure(let error):
                    AlertUtil.show(controller: vc, title: "error", message: error.localizedDescription)
                }
                self?.letterBoxView.stopLoading()
            }
        }
    }
    
    private func getDistanceToLetter(latitude: Double, longitude: Double) -> Int {
        let letterLocation = CLLocation.init(latitude: latitude, longitude: longitude)
        
        return Int(myLocation.distance(from: letterLocation))
    }
    
    private func getTutorialCard() -> Letter {
        let thereto = User.init(nickname: "thereto", name: "thereto", social: "facebook", id: "tutorial", profileURL: "")
        let me = Friend.init(nickname: myInfo.nickname, name: myInfo.name, social: myInfo.getSocial(), id: myInfo.id, profileURL: myInfo.profileURL!)
        let location = Location.init(name: "데얼투", addr: "서울 강남구 삼성로85길 26", latitude: 37.504884, longitude: 127.055053)
        var letter = Letter.init(from: thereto, to: me, location: location, photo: "https://firebasestorage.googleapis.com/v0/b/there-to.appspot.com/o/img%402x.png?alt=media&token=cdab7112-0702-490f-8d82-eac91213f044", message: "\(myInfo.nickname)님, thereto에 오신것을 환영합니다. 특별한 장소에서 친구에게특별한 엽서를 남겨보세요.\n친구는 해당 장소에 도착해야지만 엽서를 볼 수 있습니다.\n\n감사합니다.")
        
        letter.id = "tutorial"
        
        return letter
    }
}

extension LetterBoxVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let letters = try? self.viewModel.letters.value() {
            let letter = letters[indexPath.row]
            
            if letter.id == "tutorial" {
                self.navigationController?.pushViewController(LetterDetailVC.instance(letter: letter), animated: true)
            } else {
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

