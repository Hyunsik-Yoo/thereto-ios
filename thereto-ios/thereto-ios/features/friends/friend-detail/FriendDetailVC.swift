import UIKit

class FriendDetailVC: BaseVC {
    
    private lazy var friendDetailView = FriendDetailView.init(frame: self.view.frame)
    
    private let viewModel = FriendDetailViewModel(userService: UserService(),
                                                  userDefaults: UserDefaultsUtil())
    
    private var friendId: String!
    
    
    static func instance(friendId: String) -> FriendDetailVC {
        return FriendDetailVC.init(nibName: nil, bundle: nil).then {
            $0.hidesBottomBarWhenPushed = true
            $0.friendId = friendId
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = friendDetailView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchFriend(friendId: friendId)
    }
    
    override func bindViewModel() {
        // Bind input
        friendDetailView.favoriteBtn.rx.tap.bind(to: viewModel.input.tapFavorite)
            .disposed(by: disposeBag)
        friendDetailView.writeBtn.rx.tap.bind(to: viewModel.input.tapWrite)
            .disposed(by: disposeBag)
        
        // Bind output
        viewModel.output.enableFavorite.bind { [weak self] (isFavorite) in
            guard let self = self else { return }
            self.friendDetailView.favoriteDot.isEnabled = isFavorite
            if (isFavorite) {
                self.friendDetailView.favoriteDot.backgroundColor = .orangeRed
            } else {
                self.friendDetailView.favoriteDot.backgroundColor = .mushroom
            }
        }.disposed(by: disposeBag)
        viewModel.output.enableFavorite.bind(to: friendDetailView.favoriteDot.rx.isEnabled)
            .disposed(by: disposeBag)
        viewModel.output.friend.bind(onNext: friendDetailView.bind(friend:))
            .disposed(by: disposeBag)
        viewModel.output.popup.bind { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        viewModel.output.showLoading.bind(onNext: friendDetailView.showLoading(isShow:))
            .disposed(by: disposeBag)
        viewModel.output.showAlerts.bind { [weak self] (title, message) in
            guard let self = self else { return }
            AlertUtil.show(controller: self, title: title, message: message)
        }.disposed(by: disposeBag)
        viewModel.output.goToWrite.bind(onNext: presentWriteVC(friend:))
            .disposed(by: disposeBag)
    }
    
    override func bindEvent() {
        friendDetailView.backBtn.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        friendDetailView.deleteBtn1.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            AlertUtil.showWithCancel(controller: self, title: "친구삭제", message: "친구를 삭제하면 엽서를 보낼 수 없습니다.\n삭제하시겠습니까?") {
                self.viewModel.input.tapDelete.onNext(())
            }
        }.disposed(by: disposeBag)
        
        friendDetailView.deleteBtn2.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            AlertUtil.showWithCancel(controller: self, title: "친구삭제", message: "친구를 삭제하면 엽서를 보낼 수 없습니다.\n삭제하시겠습니까?") {
                self.viewModel.input.tapDelete.onNext(())
            }
        }.disposed(by: disposeBag)
    }
    
    private func presentWriteVC(friend: Friend) {
        present(WriteVC.instance(user: User(friend: friend)), animated: true, completion: nil)
    }
}
