import UIKit
import RxSwift
import RxCocoa

class FriendListVC: BaseVC {
    
    private let viewModel = FriendListViewModel()
    
    private lazy var friendListView = FriendListView(frame: self.view.frame)
    
    static func instance() -> UINavigationController {
        let controller = FriendListVC.init(nibName: nil, bundle: nil)
        
        controller.tabBarItem = UITabBarItem.init(title: "친구관리", image: UIImage.init(named: "ic_add_friend"), selectedImage: UIImage.init(named: "ic_add_friend"))
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
    
    override func bindViewModel() {
        viewModel.friends.bind(to: friendListView.tableView.rx.items(cellIdentifier: FriendCell.registerId, cellType: FriendCell.self)) { row, friend, cell in
            cell.bind(friend: friend)
        }.disposed(by: disposeBag)
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
        friendListView.tableView.register(FriendCell.self, forCellReuseIdentifier: FriendCell.registerId)
    }
    
    private func getFriendList() {
        friendListView.startLoading()
        UserService.findFriends() { [weak self] (friendList) in
            if !friendList.isEmpty {
                self?.viewModel.friends.onNext(friendList)
            }
            self?.friendListView.emptyLabel.isHidden = !friendList.isEmpty
            self?.friendListView.tableView.isHidden = friendList.isEmpty
            self?.friendListView.stopLoading()
        }
    }
}

extension FriendListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friends = try! self.viewModel.friends.value()
        
        self.navigationController?.pushViewController(FriendDetailVC.instance(friendId: friends[indexPath.row].id), animated: true)
    }
}
