import UIKit

class FriendDetailVC: BaseVC {
    
    private lazy var friendDetailView = FriendDetailView.init(frame: self.view.frame)
    
    private let viewModel = FriendDetailViewModel()
    
    private var friendId: String!
    
    
    static func instance(friendId: String) -> FriendDetailVC {
        return FriendDetailVC.init(nibName: nil, bundle: nil).then {
            $0.friendId = friendId
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = friendDetailView
        getFriendInfo()
    }
    
    override func bindViewModel() {
        viewModel.friend.bind { [weak self] (friend) in
            self?.friendDetailView.bind(friend: friend)
        }.disposed(by: disposeBag)
    }
    
    override func bindEvent() {
        friendDetailView.backBtn.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        friendDetailView.deleteBtn1.rx.tap.bind { [weak self] in
            AlertUtil.showWithCancel(title: "친구삭제", message: "친구를 삭제하면 엽서를 보낼 수 없습니다.\n삭제하시겠습니까?") {
                self?.deleteFriend()
            }
        }.disposed(by: disposeBag)
        
        friendDetailView.deleteBtn2.rx.tap.bind { [weak self] in
            AlertUtil.showWithCancel(title: "친구삭제", message: "친구를 삭제하면 엽서를 보낼 수 없습니다.\n삭제하시겠습니까?") {
                self?.deleteFriend()
            }
        }.disposed(by: disposeBag)
    }
    
    private func getFriendInfo() {
        friendDetailView.startLoading()
        UserService.findFriend(id: friendId) { [weak self] (result) in
            switch result {
            case .success(let friend):
                self?.viewModel.friend.onNext(friend)
            case .failure(let error):
                AlertUtil.show("findFriend error", message: error.localizedDescription)
            }
            self?.friendDetailView.stopLoading()
        }
    }
    
    private func deleteFriend() {
        friendDetailView.startLoading()
        UserService.deleteFriend(token: UserDefaultsUtil.getUserToken()!, friendId: friendId) {[weak self] (isSuccess) in
            if let vc = self {
                if isSuccess {
                    UserService.deleteFriend(token: vc.friendId, friendId: UserDefaultsUtil.getUserToken()!) { isSuccess in
                        if isSuccess {
                            vc.navigationController?.popViewController(animated: true)
                        }
                        self?.friendDetailView.stopLoading()
                    }
                } else {
                    self?.friendDetailView.stopLoading()
                }
            }
        }
    }
}
