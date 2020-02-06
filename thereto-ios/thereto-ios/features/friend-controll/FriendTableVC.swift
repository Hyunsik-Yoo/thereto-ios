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
        viewModel.friends.bind(to: friendTableView.tableView.rx.items(cellIdentifier: FriendControlCell.registerId, cellType: FriendControlCell.self)) { [weak self] row, friend, cell in
            cell.bind(friend: friend)
            if let vc = self {
                cell.setMode(mode: vc.mode)
                if vc.mode == .RECEIVE {
                    cell.leftBtn.rx.tap.bind { // 수락
                        self?.acceptFriendRequest(friendId: friend.id)
                    }.disposed(by: cell.disposeBag)
                    
                    cell.rightBtn.rx.tap.bind { // 거부
                        AlertUtil.showWithCancel(message: "거부하시겠습니까?") {
                            self?.cancelFriendRequest(friendId: friend.id)
                        }
                    }.disposed(by: cell.disposeBag)
                } else { // SENT
                    cell.setShowBtn(isShowBtn: DateUtil.isAfterDay(dateString: friend.createdAt!))
                    cell.leftBtn.rx.tap.bind { // 재요청
                        self?.updateFriendRequest(friendId: friend.id, complection: {
                            AlertUtil.show(message: "재요청하였습니다.")
                            cell.setShowBtn(isShowBtn: false)
                        })
                    }.disposed(by: cell.disposeBag)
                    
                    cell.rightBtn.rx.tap.bind { // 요청 취소
                        AlertUtil.showWithCancel(message: "친구요청을 취소하겠습니까?") {
                            self?.cancelFriendRequest(friendId: friend.id)
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
    
    private func acceptFriendRequest(friendId: String) {
        friendTableView.startLoading()
        UserService.acceptRequest(token: UserDefaultsUtil.getUserToken()!, friendToken: friendId) { [weak self] (isSuccess) in
            if isSuccess {
                UserService.acceptRequest(token: friendId, friendToken: UserDefaultsUtil.getUserToken()!) { (isSuccess) in
                    if isSuccess {
                        AlertUtil.show(message: "친구요청을 수락하였습니다.")
                        self?.getFriends()
                    }
                    self?.friendTableView.stopLoading()
                }
            } else {
                self?.friendTableView.stopLoading()
            }
        }
    }
    
    private func cancelFriendRequest(friendId: String) {
        friendTableView.startLoading()
        UserService.deleteFriend(token: UserDefaultsUtil.getUserToken()!, friendId: friendId) { [weak self] isSuccess in
            if isSuccess {
                UserService.deleteFriend(token: friendId, friendId: UserDefaultsUtil.getUserToken()!) { isSuccess in
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
    
    private func updateFriendRequest(friendId: String, complection: @escaping (() -> Void)) {
        friendTableView.startLoading()
        UserService.updateRequest(friendToken: friendId) { [weak self] (isSuccess) in
            if isSuccess {
                complection()
            }
            self?.friendTableView.stopLoading()
        }
    }
}

extension FriendTableVC: UITableViewDelegate {
    
}
