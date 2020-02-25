import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class SetupVC: BaseVC {
    
    private lazy var setupView = SetupView.init(frame: self.view.frame)
    
    private var viewModel = SetupViewModel()
    
    static func instance() -> UINavigationController {
        let controller = SetupVC.init(nibName: nil, bundle: nil)
        
        controller.tabBarItem = UITabBarItem.init(title: "설정", image: UIImage.init(named: "ic_setting_off"), selectedImage: UIImage.init(named: "ic_setting_on"))
        return UINavigationController.init(rootViewController: controller)
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
    
    private func setupTableView() {
        setupView.tableView.delegate = self
        setupView.tableView.dataSource = self
        setupView.tableView.register(SetupCell.self, forCellReuseIdentifier: SetupCell.registerId)
    }
    
    private func getMyInfo() {
        setupView.startLoading()
        UserService.getMyUser { [weak self] (user) in
            self?.viewModel.user.onNext(user)
            self?.setupView.stopLoading()
        }
    }
    
    private func goToSignIn() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.goToSignIn()
        }
    }
}

extension SetupVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SetupCell.registerId, for: indexPath) as? SetupCell else {
            return BaseTableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "로그아웃"
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: // 로그아웃
            AlertUtil.showWithCancel(title: "로그아웃", message: "로그아웃하시겠습니까?") { [weak self] in
                UserDefaultsUtil.clearUserToken()
                FirebaseUtil.signOut()
                
                if let vc = self {
                    if let user = try! vc.viewModel.user.value(),
                        user.social == .FACEBOOK {
                        LoginManager().logOut()
                    }
                }
                self?.goToSignIn()
            }
        default:
            break
        }
    }
}
