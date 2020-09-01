import UIKit
import RxSwift

class SentLetterVC: BaseVC {
  
  private lazy var sentLetterView = SentLetterView.init(frame: self.view.frame)
  private let viewModel = SentLetterViewModel(
    userDefaults: UserDefaultsUtil(),
    letterService: LetterSerivce()
  )
  
  
  static func instance() -> UINavigationController {
    let controller = SentLetterVC.init(nibName: nil, bundle: nil).then {
      $0.tabBarItem = UITabBarItem(
        title: "sent_letter_tab_title".localized,
        image: UIImage.init(named: "ic_sent_box_off"),
        selectedImage: UIImage.init(named: "ic_sent_box_on")
      )
    }
    
    return UINavigationController(rootViewController: controller).then {
      $0.interactivePopGestureRecognizer?.delegate = nil
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view = sentLetterView
    setupNavigationBar()
    setupTableView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.viewModel.fetchSentLetters()
  }
  
  override func bindViewModel() {
    viewModel.output.letters.bind(to: sentLetterView.tableView.rx.items(
      cellIdentifier: LetterCell.registerId,
      cellType: LetterCell.self
    )) { row, letter, cell in
      cell.bind(letter: letter, isSentMode: true)
    }.disposed(by: disposeBag)
    
    viewModel.output.showLoading
      .observeOn(MainScheduler.instance)
      .bind(onNext: self.sentLetterView.showLoading)
      .disposed(by: disposeBag)
    
    viewModel.output.showAlert
      .observeOn(MainScheduler.instance)
      .bind(onNext: self.showAlert)
      .disposed(by: disposeBag)
    
    viewModel.output.goToLetterDetail
      .observeOn(MainScheduler.instance)
      .bind(onNext: self.goToLetterDetail)
      .disposed(by: disposeBag)
  }
  
  override func bindEvent() {
    sentLetterView.emptyButton.rx.tap
      .bind { [weak self] in
        self?.present(WriteVC.instance(), animated: true, completion: nil)
    }.disposed(by: disposeBag)
    
    sentLetterView.topBar.searchBtn.rx.tap
      .bind { [weak self] in
        self?.navigationController?.pushViewController(
          LetterSearchVC.instance(type: "from"),
          animated: true
        )
    }.disposed(by: disposeBag)
  }
  
  private func setupNavigationBar() {
    navigationController?.isNavigationBarHidden = true
    sentLetterView.topBar.setSentLetterMode()
  }
  
  private func setupTableView() {
    sentLetterView.tableView.delegate = self
    sentLetterView.tableView.register(
      LetterCell.self,
      forCellReuseIdentifier: LetterCell.registerId
    )
  }
  
  private func goToLetterDetail(letter: Letter) {
    let letterDetailController = LetterDetailVC.instance(letter: letter, isSentMode: true)
    
    self.navigationController?.pushViewController(letterDetailController, animated: true)
  }
}

extension SentLetterVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.viewModel.input.tapLetter.onNext(indexPath.row)
  }
}
