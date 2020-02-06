import UIKit
import RxSwift
import RxCocoa

class FriendListVC: BaseVC {
    
    private let viewModel = FriendListViewModel()
    
    private lazy var friendListView = FriendListView(frame: self.view.frame)
    
    static func instance() -> UINavigationController {
        return UINavigationController.init(rootViewController: FriendListVC.init(nibName: nil, bundle: nil))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = friendListView
        setupDrawer()
        setupTableView()
        setupNavigationBar()
        getFriendList()
    }
    
    override func bindViewModel() {
        viewModel.friends.bind(to: friendListView.tableView.rx.items(cellIdentifier: FriendCell.registerId, cellType: FriendCell.self)) { row, user, cell in
            cell.bind(user: user)
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
        
        friendListView.drawer.letterboxBtn.rx.tap.bind { [weak self] in
            if let vc = self {
                vc.friendListView.hideMenu {
                    vc.goToLetterBox()
                }
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
        UserService.findFriend(id: UserDefaultsUtil.getUserToken()!) { [weak self] (friendList) in
            if !friendList.isEmpty {
                self?.viewModel.friends.onNext(friendList)
            }
            self?.friendListView.emptyLabel.isHidden = !friendList.isEmpty
        }
    }
    
    private func goToLetterBox() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.goToLetterbox()
        }
    }
}

extension FriendListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(FriendDetailVC.instance(), animated: true)
    }
}
