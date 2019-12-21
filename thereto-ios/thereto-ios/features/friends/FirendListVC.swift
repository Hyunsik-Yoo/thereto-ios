import UIKit
import RxSwift
import RxCocoa

class FriendListVC: BaseVC {
    
    private let viewModel = FriendListViewModel()
    
    private let friendListView: FriendListView = {
        let view = FriendListView()
        
        view.isUserInteractionEnabled = true
        return view
    }()
    
    static func instance() -> UINavigationController {
        let controller = FriendListVC(nibName: nil, bundle: nil)
        let navi = UINavigationController(rootViewController: controller)
        
        return navi
    }
    
    
    override func viewDidLoad() {
        view.addSubview(friendListView)
        initDrawer()
        friendListView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        navigationController?.isNavigationBarHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        friendListView.topBar.setFriendListMode()
        
        // TODO: UserDefaults 만들어서 내 정보 저장해야함
        UserService.findFriend(id: "facebook2574917595938223") { (friendList) in
            if friendList.isEmpty {
                print("friendList is empty")
            } else {
                print("friendList is not empty")
            }
        }
        friendListView.tableView.delegate = self
        friendListView.tableView.dataSource = self
        friendListView.tableView.register(FriendCell.self, forCellReuseIdentifier: FriendCell.registerId)
        friendListView.tableView.rowHeight = UITableView.automaticDimension
        friendListView.tableView.separatorStyle = .none
    }
    
    override func bindViewModel() {
        
    }
    
    private func initDrawer() {
        friendListView.topBar.hambugerBtn.rx.tap.bind {
            self.friendListView.showMenu()
        }.disposed(by: disposeBag)
        
        friendListView.drawer.closeBtn.rx.tap.bind {
            self.friendListView.hideMenu { }
        }.disposed(by: disposeBag)
        
        friendListView.topBar.addFriendBtn.rx.tap.bind {
            self.navigationController?.pushViewController(AddFriendVC.instance(), animated: true)
        }.disposed(by: disposeBag)
        
        let letterboxLabelTap = UITapGestureRecognizer()
        
        friendListView.drawer.letterboxLabel.addGestureRecognizer(letterboxLabelTap)
        letterboxLabelTap.rx.event.bind { (_) in
            self.friendListView.hideMenu {
                self.goToLetterBox()
            }
        }.disposed(by: disposeBag)
        
        let tapGesture = UITapGestureRecognizer()
        
        friendListView.drawer.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind { _ in
            self.friendListView.hideMenu { }
        }.disposed(by: disposeBag)
    }
    
    private func goToLetterBox() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.goToLetterbox()
        }
    }
}

extension FriendListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.registerId, for: indexPath) as? FriendCell else {
            return BaseTableViewCell()
        }
        
        return cell
    }
}
