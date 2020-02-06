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
        viewModel.friend.bind { [weak self] (user) in
            self?.friendDetailView.bind(friend: user)
        }.disposed(by: disposeBag)
    }
    
    override func bindEvent() {
        friendDetailView.backBtn.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func getFriendInfo() {
        friendDetailView.startLoading()
        UserService.findFriend(id: friendId) { [weak self] (result) in
            switch result {
            case .success(let user):
                self?.viewModel.friend.onNext(user)
            case .failure(let error):
                AlertUtil.show("findFriend error", message: error.localizedDescription)
            }
            self?.friendDetailView.stopLoading()
        }
    }
}
