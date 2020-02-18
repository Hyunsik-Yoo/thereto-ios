import UIKit
import RxSwift
import RxCocoa

class FriendListVC: BaseVC {
    
    private var viewModel = FriendListViewModel()
    
    private lazy var friendListView = FriendListView(frame: self.view.frame)
    
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
        
        getFriendList()
    }
    
    override func bindEvent() {
        friendListView.topBar.addFriendBtn.rx.tap.bind { [weak self] in
            self?.navigationController?.pushViewController(AddFriendVC.instance(), animated: true)
        }.disposed(by: disposeBag)
        
        friendListView.topBar.searchBtn.rx.tap.bind { [weak self] in
            self?.navigationController?.pushViewController(FindFriendVC.instance(), animated: true)
        }.disposed(by: disposeBag)
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
    
    private func getFriendList() {
        friendListView.startLoading()
        UserService.findFriends() { [weak self] (friendList) in
            self?.viewModel.friends = friendList
            self?.friendListView.tableView.reloadData()
            self?.friendListView.stopLoading()
        }
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
            return self.viewModel.friends.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendAdminCell.registerId, for: indexPath) as? FriendAdminCell else {
                return BaseTableViewCell()
            }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.registerId, for: indexPath) as? FriendCell else {
                return BaseTableViewCell()
            }
            
            cell.bind(friend: self.viewModel.friends[indexPath.row])
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.navigationController?.pushViewController(FriendControlVC.instance(), animated: true)
        } else {
            let friendId = self.viewModel.friends[indexPath.row].id
            
            self.navigationController?.pushViewController(FriendDetailVC.instance(friendId: friendId), animated: true)
        }
    }
}
