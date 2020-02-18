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
    
    override func bindViewModel() {
        viewModel.letters.bind(to: sentLetterView.tableView.rx.items(cellIdentifier: LetterCell.registerId, cellType: LetterCell.self)) { row, letter, cell in
            
        }.disposed(by: disposeBag)
    }
    
    private func setupNavigationBar() {
        sentLetterView.topBar.setSentLetterMode()
    }
    
    private func setupTableView() {
        sentLetterView.tableView.delegate = self
        sentLetterView.tableView.register(LetterCell.self, forCellReuseIdentifier: LetterCell.registerId)
    }
}

extension SentLetterVC: UITableViewDelegate{
    
}
