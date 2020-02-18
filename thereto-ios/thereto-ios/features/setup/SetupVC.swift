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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: // 알람 설정
            break
        case 1: // 로그아웃
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
        case 2: // 계정 삭제
            AlertUtil.showWithCancel(title: "계정삭제", message: "계정을 삭제하시겠습니까?\n삭제 시 모든 데이터가 사라지고 재복구할 수 없습니다.") {
                
            }
        default:
            break
        }
    }
}
