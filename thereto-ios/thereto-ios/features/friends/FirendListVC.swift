import UIKit
import RxSwift
import RxCocoa

class FriendListVC: BaseVC {
    
    private var viewModel = FriendListViewModel(userService: UserService(),
                                                userDefaults: UserDefaultsUtil())
    
    private lazy var friendListView = FriendListView(frame: self.view.frame)
    
    var user: User? = nil
    var friends: [Friend] = []
    
    static func instance() -> UINavigationController {
        let controller = FriendListVC.init(nibName: nil, bundle: nil)
        
        controller.tabBarItem = UITabBarItem.init(title: "친구관리", image: UIImage.init(named: "ic_friend_off"), selectedImage: UIImage.init(named: "ic_friend_on"))
        return UINavigationController.init(rootViewController: controller)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = friendListView
        setupTableView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.fetchFriends()
    }
    
    override func bindEvent() {
        friendListView.topBar.addFriendBtn.rx.tap.bind { [weak self] in
            self?.navigationController?.pushViewController(AddFriendVC.instance(), animated: true)
        }.disposed(by: disposeBag)
        
        friendListView.topBar.searchBtn.rx.tap.bind { [weak self] in
            self?.navigationController?.pushViewController(FindFriendVC.instance(), animated: true)
        }.disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        viewModel.output.friends.bind(onNext: refreshTableView)
            .disposed(by: disposeBag)
        viewModel.output.showAlerts.bind { (title, message) in
            AlertUtil.show(controller: self, title: title, message: message)
        }.disposed(by: disposeBag)
        viewModel.output.showLoading.bind(onNext: friendListView.showLoading(isShow:))
            .disposed(by: disposeBag)
    }
    
    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        friendListView.topBar.setFriendListMode()
    }
    
    private func setupTableView() {
        friendListView.tableView.delegate = self
        friendListView.tableView.dataSource = self
        friendListView.tableView.register(FriendCell.self, forCellReuseIdentifier: FriendCell.registerId)
        friendListView.tableView.register(FriendAdminCell.self, forCellReuseIdentifier: FriendAdminCell.registerId)
    }
    
    private func refreshTableView(user: User, friends: [Friend]) {
        self.user = user
        self.friends = friends
        self.friendListView.tableView.reloadData()
    }
}

extension FriendListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.friends.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendAdminCell.registerId, for: indexPath) as? FriendAdminCell else {
                return BaseTableViewCell()
            }
            
            if let user = self.user {
                cell.bind(user: user)
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.registerId, for: indexPath) as? FriendCell else {
                return BaseTableViewCell()
            }
            
            cell.bind(friend: self.friends[indexPath.row])
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.navigationController?.pushViewController(FriendControlVC.instance(), animated: true)
        } else {
            let friendId = self.friends[indexPath.row].id
            
            self.navigationController?.pushViewController(FriendDetailVC.instance(friendId: friendId), animated: true)
        }
    }
}
