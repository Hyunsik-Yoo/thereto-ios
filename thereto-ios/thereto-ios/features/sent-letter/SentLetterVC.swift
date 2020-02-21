import UIKit

class SentLetterVC: BaseVC {
    
    private lazy var sentLetterView = SentLetterView.init(frame: self.view.frame)
    
    private var viewModel = SentLetterViewModel.init()
    
    static func instance() -> UINavigationController {
        let controller = SentLetterVC.init(nibName: nil, bundle: nil)
        
        controller.tabBarItem = UITabBarItem.init(title: "발신함", image: UIImage.init(named: "ic_sent_box_off"), selectedImage: UIImage.init(named: "ic_sent_box_on"))
        return UINavigationController(rootViewController: controller)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view = sentLetterView
        
        setupNavigationBar()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getSentLetters()
    }
    
    override func bindViewModel() {
        viewModel.letters.bind(to: sentLetterView.tableView.rx.items(cellIdentifier: LetterCell.registerId, cellType: LetterCell.self)) { row, letter, cell in
            cell.bind(letter: letter, isSentLetter: true)
        }.disposed(by: disposeBag)
    }
    
    override func bindEvent() {
        sentLetterView.emptyBtn.rx.tap.bind { [weak self] in
            self?.present(WriteVC.instance(), animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
    
    private func setupNavigationBar() {
        sentLetterView.topBar.setSentLetterMode()
    }
    
    private func setupTableView() {
        sentLetterView.tableView.delegate = self
        sentLetterView.tableView.register(LetterCell.self, forCellReuseIdentifier: LetterCell.registerId)
    }
    
    private func getSentLetters() {
        sentLetterView.startLoading()
        LetterSerivce.getSentLetters { [weak self] (result) in
            switch result {
            case .success(let letters):
                self?.sentLetterView.setEmpty(isEmpty: letters.isEmpty)
                self?.viewModel.letters.onNext(letters)
            case .failure(let error):
                if let vc = self {
                    AlertUtil.show(controller: vc, title: "error", message: error.localizedDescription)
                }
            }
            self?.sentLetterView.stopLoading()
        }
    }
}

extension SentLetterVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let letters = try? self.viewModel.letters.value() {
            self.navigationController?.pushViewController(LetterDetailVC.instance(letter: letters[indexPath.row]), animated: true)
        }
    }
}
