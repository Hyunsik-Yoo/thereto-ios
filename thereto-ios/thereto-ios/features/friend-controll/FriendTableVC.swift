import UIKit

class FriendTableVC: BaseVC {
    
    private lazy var friendTableView = FriendTableView.init(frame: self.view.frame)
    private var mode: ControlMode!
    private var viewModel = FriendControlViewModel()
    
    static func instance(mode: ControlMode) -> FriendTableVC {
        return FriendTableVC.init(nibName: nil, bundle: nil).then {
            $0.mode = mode
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = friendTableView
        setupTableView()
        getFriends()
    }
    
    override func bindViewModel() {
        viewModel.friends.bind(to: friendTableView.tableView.rx.items(cellIdentifier: FriendControlCell.registerId, cellType: FriendControlCell.self)) { [weak self] row, user, cell in
            cell.bind(user: user)
            if let vc = self {
                cell.setMode(mode: vc.mode)
                if vc.mode == .RECEIVE {
                    
                } else { // SENT
                    cell.leftBtn.rx.tap.bind {
                        AlertUtil.show(message: "재요청하였습니다.")
                    }.disposed(by: cell.disposeBag)
                    
                    cell.rightBtn.rx.tap.bind { [weak self] in
                        AlertUtil.showWithCancel(message: "친구요청을 취소하겠습니까?") {
                            // 친구 요청 삭제
                            self?.cancelFriendRequest(friendToken: "\(user.getSocial())\(user.socialId)")
                        }
                    }.disposed(by: cell.disposeBag)
                    
                }
            }
        }.disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        friendTableView.tableView.delegate = self
        friendTableView.tableView.register(FriendControlCell.self, forCellReuseIdentifier: FriendControlCell.registerId)
    }
    
    private func getFriends() {
        switch mode {
        case .RECEIVE:
            getReceivedFriends()
        case .SENT:
            getSentFriends()
        case .none:
            break
        }
    }
    
    private func getReceivedFriends() {
        friendTableView.startLoading()
        UserService.getReceivedFriends { [weak self] (friends) in
            self?.friendTableView.emptyLabel.isHidden = !friends.isEmpty
            self?.viewModel.friends.onNext(friends)
            self?.friendTableView.stopLoading()
        }
    }
    
    private func getSentFriends() {
        friendTableView.startLoading()
        UserService.getSentFriends { [weak self] (friends) in
            self?.friendTableView.emptyLabel.isHidden = !friends.isEmpty
            self?.viewModel.friends.onNext(friends)
            self?.friendTableView.stopLoading()
        }
    }
    
    private func cancelFriendRequest(friendToken: String) {
        friendTableView.startLoading()
        UserService.deleteFriend(token: UserDefaultsUtil.getUserToken()!, friendToken: friendToken) { [weak self] isSuccess in
            if isSuccess {
                UserService.deleteFriend(token: friendToken, friendToken: UserDefaultsUtil.getUserToken()!) { isSuccess in
                    if isSuccess {
                        AlertUtil.show(message: "삭제하였습니다.")
                        self?.getFriends()
                    }
                    self?.friendTableView.stopLoading()
                }
            } else {
                self?.friendTableView.stopLoading()
            }
        }
    }
}

extension FriendTableVC: UITableViewDelegate {
    
}
