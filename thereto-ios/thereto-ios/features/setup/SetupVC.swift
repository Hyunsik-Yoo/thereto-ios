import UIKit

class SetupVC: BaseVC {
    
    private lazy var setupView = SetupView.init(frame: self.view.frame)
    
    private var viewModel = SetupViewModel()
    
    static func instance() -> UINavigationController {
        return UINavigationController.init(rootViewController: SetupVC.init(nibName: nil, bundle: nil))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        view = setupView
        setupTableView()
        getMyInfo()
    }
    
    override func bindViewModel() {
        viewModel.user.bind { [weak self] (user) in
            self?.setupView.bind(user: user)
        }.disposed(by: disposeBag)
    }
    
    override func bindEvent() {
        initDrawer()
        
        setupView.topBar.hambugerBtn.rx.tap.bind { () in
            self.setupView.showMenu()
        }.disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        setupView.tableView.delegate = self
        setupView.tableView.dataSource = self
        setupView.tableView.register(SetupCell.self, forCellReuseIdentifier: SetupCell.registerId)
    }
    
    private func initDrawer() {
        setupView.drawer.closeBtn.rx.tap.bind {
            self.setupView.hideMenu { }
        }.disposed(by: disposeBag)
        
        setupView.drawer.letterboxBtn.rx.tap.bind { [weak self] in
            self?.setupView.hideMenu {
                self?.goToLetterBox()
            }
        }.disposed(by: disposeBag)
        
        setupView.drawer.friendBtn.rx.tap.bind { [weak self] in
            self?.setupView.hideMenu {
                self?.goToFriend()
            }
        }.disposed(by: disposeBag)
        
        setupView.drawer.setupBtn.rx.tap.bind { [weak self] in
            self?.setupView.hideMenu { }
        }.disposed(by: disposeBag)
        
        let tapGesture = UITapGestureRecognizer()
        
        setupView.drawer.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind { _ in
            self.setupView.hideMenu { }
        }.disposed(by: disposeBag)
        
        setupView.drawer.friendControllBtn.rx.tap.bind {
            self.navigationController?.pushViewController(FriendControlVC.instance(), animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func getMyInfo() {
        setupView.startLoading()
        UserService.getMyUser { [weak self] (user) in
            self?.viewModel.user.onNext(user)
            self?.setupView.stopLoading()
        }
    }
    
    private func goToFriend() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.goToFriend()
        }
    }
    
    private func goToLetterBox() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.goToLetterbox()
        }
    }
}

extension SetupVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SetupCell.registerId, for: indexPath) as? SetupCell else {
            return BaseTableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "알림설정"
        case 1:
            cell.titleLabel.text = "로그아웃"
        case 2:
            cell.titleLabel.text = "계정삭제"
        default:
            break
        }
        return cell
    }
}
