import UIKit

class FindFriendVC: BaseVC {
    
    private lazy var findFriendView = FindFriendView.init(frame: self.view.frame)
    
    private var viewModel = FindFriendViewModel()
    
    
    static func instance() -> FindFriendVC {
        return FindFriendVC.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = findFriendView
        setupTableView()
        getFriendList()
    }
    
    override func bindViewModel() {
        viewModel.friends.bind(to: findFriendView.tableView.rx.items(cellIdentifier: FriendCell.registerId, cellType: FriendCell.self)) { row, friend, cell in
            cell.bind(friend: friend)
        }.disposed(by: disposeBag)
    }
    
    override func bindEvent() {
        findFriendView.backBtn.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        findFriendView.nicknameField.rx.controlEvent([.editingChanged]).subscribe { [weak self] _ in
            if let vc = self {
                let text = vc.findFriendView.nicknameField.text!
                
                if !text.isEmpty {
                    vc.viewModel.friends.onNext(vc.viewModel.totalFriends.filter { (friend) -> Bool in
                        friend.nickname.contains(text)
                    })
                }
                self?.findFriendView.setDataMode(isEmpty: text.isEmpty)
            }
        }.disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        findFriendView.tableView.delegate = self
        findFriendView.tableView.register(FriendCell.self, forCellReuseIdentifier: FriendCell.registerId)
    }
    
    private func getFriendList() {
        findFriendView.startLoading()
        UserService.findFriends() { [weak self] (friendList) in
            if !friendList.isEmpty {
                self?.viewModel.friends.onNext(friendList)
            }
            self?.viewModel.totalFriends = friendList
            self?.findFriendView.setDataMode(isEmpty: friendList.isEmpty)
            self?.findFriendView.stopLoading()
        }
    }
}

extension FindFriendVC: UITableViewDelegate {
    
}
