import UIKit

protocol SelectFriendDelegate: class {
    func onSelectFriend(friend: Friend)
}

class SelectFriendVC: BaseVC {
    private lazy var selectFriendView = SelectFirendView.init(frame: self.view.frame)
    
    private var viewModel = SelectFriendViewModel()
    
    weak var delegate: SelectFriendDelegate?
    
    static func instance() -> SelectFriendVC {
        return SelectFriendVC.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = selectFriendView
        setupTableView()
        getFriendList()
    }
    
    override func bindViewModel() {
        viewModel.friends.bind(to: selectFriendView.tableView.rx.items(cellIdentifier: FriendCell.registerId, cellType: FriendCell.self)) { row, friend, cell in
            cell.bind(friend: friend)
        }.disposed(by: disposeBag)
    }
    
    override func bindEvent() {
        selectFriendView.backBtn.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        selectFriendView.nicknameField.rx.controlEvent([.editingChanged]).subscribe { [weak self] _ in
            if let vc = self {
                let text = vc.selectFriendView.nicknameField.text!
                
                if !text.isEmpty {
                    let filteredFriends = vc.viewModel.totalFriends.filter { (friend) -> Bool in
                        friend.nickname.contains(text)
                    }
                    
                    vc.selectFriendView.setDataMode(isEmpty: filteredFriends.isEmpty)
                    vc.viewModel.friends.onNext(filteredFriends)
                } else {
                    vc.viewModel.friends.onNext(vc.viewModel.totalFriends)
                    vc.selectFriendView.setDataMode(isEmpty: !text.isEmpty)
                }
                
            }
        }.disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        selectFriendView.tableView.delegate = self
        selectFriendView.tableView.register(FriendCell.self, forCellReuseIdentifier: FriendCell.registerId)
    }
    
    private func getFriendList() {
        selectFriendView.startLoading()
        UserService.findFriends() { [weak self] (friendList) in
            if !friendList.isEmpty {
                self?.viewModel.friends.onNext(friendList)
            }
            self?.viewModel.totalFriends = friendList
            self?.selectFriendView.setDataMode(isEmpty: friendList.isEmpty)
            self?.selectFriendView.stopLoading()
        }
    }
}

extension SelectFriendVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let friends = try? self.viewModel.friends.value() {
            self.delegate?.onSelectFriend(friend: friends[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
    }
}
