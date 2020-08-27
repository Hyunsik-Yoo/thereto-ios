import UIKit
import CoreLocation

class LetterBoxVC: BaseVC {
  
  private lazy var letterBoxView = LetterBoxView(frame: self.view.frame)
  private let viewModel = LetterBoxViewModel(
    userDefaults: UserDefaultsUtil(),
    letterService: LetterSerivce(),
    userService: UserService()
  )
  
  
  static func instance() -> UINavigationController {
    let controller = LetterBoxVC(nibName: nil, bundle: nil).then {
      $0.tabBarItem = UITabBarItem.init(
        title: "letterbox_tab_title".localized,
        image: UIImage.init(named: "ic_letter_box_off"),
        selectedImage: UIImage.init(named: "ic_letter_box_on")
      )
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
    viewModel.setupLocationManager()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    viewModel.fetchLetters()
  }
  
  override func bindViewModel() {
    // Bind output
    viewModel.output.letters.bind(to: letterBoxView.tableView.rx.items(
      cellIdentifier: LetterCell.registerId,
      cellType: LetterCell.self
    )) { row, letter, cell in
      cell.bind(letter: letter, isSentMode: false)
    }.disposed(by: disposeBag)
    viewModel.output.showAlerts
      .bind(onNext: self.showAlert)
      .disposed(by: disposeBag)
    viewModel.output.showLoading
      .bind(onNext: letterBoxView.showLoading(isShow:))
      .disposed(by: disposeBag)
    viewModel.output.showLocationError
      .bind(onNext: showLocationError)
      .disposed(by: disposeBag)
    viewModel.output.goToLetterDetail
      .bind(onNext: goToLetterDetail(letter:))
      .disposed(by: disposeBag)
    viewModel.output.showFarAway
      .bind(onNext: showFarAway)
      .disposed(by: disposeBag)
  }
  
  override func bindEvent() {
    letterBoxView.topBar.searchBtn.rx.tap
      .bind { [weak self] in
        self?.navigationController?.pushViewController(
          LetterSearchVC.instance(type: "to"),
          animated: true
        )
    }.disposed(by: disposeBag)
  }
  
  private func setupNavigation() {
    navigationController?.isNavigationBarHidden = true
  }
  
  private func setupTableView() {
    letterBoxView.tableView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    letterBoxView.tableView.register(
      LetterCell.self,
      forCellReuseIdentifier: LetterCell.registerId
    )
  }
    
  private func showLocationError() {
    AlertUtil.showWithAction(title: "위치 권한 오류", message: "letterbox_location_error".localized) {
    }
  }
  
  private func goToLetterDetail(letter: Letter) {
    navigationController?.pushViewController(
      LetterDetailVC.instance(letter: letter, isSentMode: false),
      animated: true
    )
  }
  
  private func showFarAway(letter: Letter, myLocation: CLLocation) {
    letterBoxView.addBgDim()
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
