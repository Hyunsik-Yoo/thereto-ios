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
        setupDrawer()
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
    
    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        friendListView.topBar.setFriendListMode()
    }
    
    private func setupDrawer() {
        friendListView.topBar.hambugerBtn.rx.tap.bind { [weak self] in
            self?.friendListView.showMenu()
        }.disposed(by: disposeBag)
        
        friendListView.drawer.closeBtn.rx.tap.bind { [weak self] in
            self?.friendListView.hideMenu { }
        }.disposed(by: disposeBag)
        
        friendListView.topBar.addFriendBtn.rx.tap.bind { [weak self] in
            self?.navigationController?.pushViewController(AddFriendVC.instance(), animated: true)
        }.disposed(by: disposeBag)
        
        friendListView.topBar.searchBtn.rx.tap.bind { [weak self] in
            self?.navigationController?.pushViewController(FindFriendVC.instance(), animated: true)
        }.disposed(by: disposeBag)
        
        friendListView.drawer.letterboxBtn.rx.tap.bind { [weak self] in
            if let vc = self {
                vc.friendListView.hideMenu {
                    vc.goToLetterBox()
                }
            }
        }.disposed(by: disposeBag)
        
        friendListView.drawer.friendBtn.rx.tap.bind { [weak self] in
            self?.friendListView.hideMenu { }
        }.disposed(by: disposeBag)
        
        friendListView.drawer.setupBtn.rx.tap.bind { [weak self] in
            self?.friendListView.hideMenu {
                self?.goToSetup()
            }
        }.disposed(by: disposeBag)
        
        friendListView.drawer.friendControllBtn.rx.tap.bind { [weak self] in
            self?.navigationController?.pushViewController(FriendControlVC.instance(), animated: true)
        }.disposed(by: disposeBag)
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
    
    private func goToLetterBox() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.goToLetterbox()
        }
    }
    
    private func goToSetup() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.goToSetup()
        }
    }
}

extension FriendListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friends = try! self.viewModel.friends.value()
        
        self.navigationController?.pushViewController(FriendDetailVC.instance(friendId: friends[indexPath.row].id), animated: true)
    }
}
