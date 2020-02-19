import UIKit

class LetterBoxVC: BaseVC {
    
    private lazy var letterBoxView = LetterBoxView.init(frame: self.view.frame)
    
    private var viewModel = LetterBoxViewModel.init()
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLetters()
    }
    
    override func bindViewModel() {
        viewModel.letters.bind(to: letterBoxView.tableView.rx.items(cellIdentifier: LetterCell.registerId, cellType: LetterCell.self)) { row, letter, cell in
            cell.bind(letter: letter)
        }.disposed(by: disposeBag)
        
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
                self?.viewModel.letters.onNext(letters)
            case .failure(let error):
                if let vc = self {
                    AlertUtil.show(controller: vc, title: "error", message: error.localizedDescription)
                }
            }
            self?.letterBoxView.stopLoading()
        }
    }
}

extension LetterBoxVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let letters = try? self.viewModel.letters.value() {
            self.letterBoxView.addBgDim()
            let farAwayVC = FarAwayVC.instance(letter: letters[indexPath.row]).then {
                $0.delegate = self
            }
            self.present(farAwayVC, animated: true, completion: nil)
        }
    }
}

extension LetterBoxVC: FarAwayDelegate {
    func onClose() {
        self.letterBoxView.removeBgDim()
    }
}
