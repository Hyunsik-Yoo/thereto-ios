import UIKit
import CoreLocation

class LetterBoxVC: BaseVC {
    
    private lazy var letterBoxView = LetterBoxView(frame: self.view.frame)
    private var viewModel = LetterBoxViewModel(userDefaults: UserDefaultsUtil(),
                                               letterService: LetterSerivce(),
                                               userService: UserService())
    
    
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
        view = letterBoxView
        
        setupNavigation()
        letterBoxView.topBar.setLetterBoxMode()
        setupTableView()
        viewModel.input.setupLocationManager.onNext(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.getLetters.onNext(())
    }
    
    override func bindViewModel() {
        // Bind input
        
        // Bind output
        viewModel.output.letters.bind(to: letterBoxView.tableView.rx.items(cellIdentifier: LetterCell.registerId, cellType: LetterCell.self)) { row, letter, cell in
            cell.bind(letter: letter)
        }.disposed(by: disposeBag)
        viewModel.output.showAlerts.bind(onNext: showAlerts)
            .disposed(by: disposeBag)
        viewModel.output.showLoading.bind(onNext: letterBoxView.showLoading(isShow:))
            .disposed(by: disposeBag)
        viewModel.output.showLocationError.bind(onNext: showLocationError)
            .disposed(by: disposeBag)
        viewModel.output.goToLetterDetail.bind(onNext: goToLetterDetail(letter:))
            .disposed(by: disposeBag)
        viewModel.output.showFarAway.bind(onNext: showFarAway)
            .disposed(by: disposeBag)
    }
    
    override func bindEvent() {
        letterBoxView.topBar.searchBtn.rx.tap.bind { [weak self] in
            self?.navigationController?.pushViewController(LetterSearchVC.instance(type: "to"), animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func setupNavigation() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupTableView() {
        letterBoxView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        letterBoxView.tableView.register(LetterCell.self, forCellReuseIdentifier: LetterCell.registerId)
    }
    
    private func showAlerts(title: String, message: String) {
        AlertUtil.show(controller: self, title: title, message: message)
    }
    
    private func showLocationError() {
        AlertUtil.showWithCancel(title: "위치 권한 오류", message: "") {
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        }
    }
    
    private func goToLetterDetail(letter: Letter) {
        self.navigationController?.pushViewController(LetterDetailVC.instance(letter: letter, isSentMode: false), animated: true)
    }
    
    private func showFarAway(letter: Letter, myLocation: CLLocation) {
        self.letterBoxView.addBgDim()
        let farAwayVC = FarAwayVC.instance(letter: letter, myLocation: myLocation).then {
            $0.delegate = self
        }
        self.present(farAwayVC, animated: true, completion: nil)
    }
}

extension LetterBoxVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.input.selectItem.onNext(indexPath.row)
    }
}

extension LetterBoxVC: FarAwayDelegate {
    func onClose() {
        self.letterBoxView.removeBgDim()
    }
}
