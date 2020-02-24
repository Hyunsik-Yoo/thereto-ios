import UIKit
import RxSwift
import RxCocoa

class AddFriendVC: BaseVC {
    
    private lazy var addFriendView = AddFriendView(frame: self.view.frame)
    
    private let viewModel = AddFriendViewModel()
    
    
    static func instance() -> AddFriendVC {
        return AddFriendVC(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = addFriendView
        getFriendList()
        setupTableView()
    }
    
    override func bindViewModel() {
        viewModel.people.bind(to: addFriendView.tableView.rx.items(cellIdentifier: AddFriendCell.registerId, cellType: AddFriendCell.self)) { index, friend, cell in
            if let friend = friend { // 검색 결과가 있을 때
                self.addFriendView.setDataMode(isDataMode: true)
                cell.bind(friend: friend)
                cell.addBtn.rx.tap.bind {
                    AlertUtil.showWithCancel(title: "친구 요청", message: "친구 요청을 보내시겠습니까?") {
                        var friend = friend
                        
                        friend.requestState = .REQUEST_SENT
                        self.requestFriend(friend: friend)
                    }
                }.disposed(by: self.disposeBag)
            } else { // 검색 결과가 없을 떄
                self.addFriendView.setDataMode(isDataMode: false)
            }
        }.disposed(by: disposeBag)
        
        addFriendView.linkBtn.rx.tap.bind {
            
        }.disposed(by: disposeBag)
    }
    
    override func bindEvent() {
        addFriendView.backBtn.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        addFriendView.nicknameField.rx.controlEvent(.editingDidEndOnExit).bind { [weak self] in
            if let vc = self {
                vc.findUser(inputNickname: vc.addFriendView.nicknameField.text!)
            }
        }.disposed(by: disposeBag)
        
        addFriendView.searchBtn.rx.tap.bind { [weak self] in
            if let vc = self {
                vc.findUser(inputNickname: vc.addFriendView.nicknameField.text!)
            }
        }.disposed(by: disposeBag)
        
        addFriendView.linkBtn.rx.tap.bind { [weak self] in
//            self?.showSharedVC()
            if let vc = self {
                AlertUtil.show(controller: vc, title: "", message: "준비중입니다.")
            }
        }.disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        addFriendView.tableView.delegate = self
        addFriendView.tableView.register(AddFriendCell.self, forCellReuseIdentifier: AddFriendCell.registerId)
    }
    
    private func requestFriend(friend: Friend) {
        self.addFriendView.startLoading()
        // 내 User document에 상대방 넣고 state는 request_sent
        let myToken = UserDefaultsUtil.getUserToken()!
        
        UserService.addFriend(token: myToken, friend: friend) { (isSuccess) in
            if isSuccess {
                // 상대방 user document에 내 User넣고 state는 wait
                UserService.getMyUser { (user) in
                    var myUser = Friend.init(user: user)
                    myUser.requestState = State.WAIT
                    UserService.addFriend(token: friend.id, friend: myUser) { (isSuccess) in
                        if isSuccess {
                            AlertUtil.show(message: "친구 요청 성공")
                            self.addFriendView.nicknameField.text = ""
                            self.addFriendView.setDataMode(isDataMode: false)
                        } else {
                            // 실패한 경우 다시 지워야 함
                            UserService.deleteFriend(token: myToken, friendId: friend.id) { _ in }
                        }
                        self.addFriendView.stopLoading()
                    }
                }
            } else {
                self.addFriendView.stopLoading()
            }
        }
    }
    
    private func findUser(inputNickname: String) {
        self.addFriendView.startLoading()
        if inputNickname.isEmpty {
            AlertUtil.show(message: "닉네임을 제대로 입력해주세요.")
        } else {
            UserService.findUser(nickname: inputNickname) { (userList) in
                if userList.isEmpty {
                    self.viewModel.people.accept([nil])
                } else {
                    // 내 친구가 아닌 사람들만 보여줘야하므로 필터링!
                    let filteredList = userList.filter { (user) -> Bool in
                        !self.viewModel.friends.contains { (friend) -> Bool in
                            friend?.nickname == user.nickname && friend?.requestState == State.FRIEND
                        }
                    }.map { (user) -> Friend in // 친구요청 수락을 이미 보냈거나 대기중인 사람에게는 기다림 표시 떠야함
                        if (self.viewModel.friends.contains { (friend) -> Bool in
                            friend?.nickname == user.nickname
                        }) {
                            var newUser = Friend.init(user: user)
                            
                            newUser.requestState = State.REQUEST_SENT
                            return newUser
                        } else {
                            return Friend.init(user: user)
                        }
                    }
                    self.viewModel.people.accept(filteredList.isEmpty ? [nil] : filteredList)
                }
                self.addFriendView.stopLoading()
            }
        }
    }
    
    private func getFriendList() {
        UserService.findFriends() { (friends) in
            self.viewModel.friends = friends
        }
    }
    
    private func showSharedVC() {
        let activityVC = UIActivityViewController(activityItems: ["보낸이가 있던 장소에 가야만 확인할 수 있는 엽서 서비스 데얼투.\n지금 앱스토어에서 다운받으세요.\n"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        present(activityVC, animated: true, completion: nil)
        activityVC.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
            
            if completed  {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension AddFriendVC: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        
        if 130 - contentOffset > 0 && contentOffset > 0 && scrollView.contentSize.height > scrollView.frame.height {
            self.addFriendView.titleLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(self.addFriendView.backBtn.snp.left)
                make.top.equalTo(self.view.safeAreaLayoutGuide).offset(40 - contentOffset)
            }
            self.addFriendView.titleLabel.alpha = CGFloat((130 - contentOffset)/130)
            
            self.addFriendView.nicknameField.snp.remakeConstraints { (make) in
                make.left.equalTo(self.addFriendView.backBtn.snp.left).offset(contentOffset * 34 / 130)
                make.centerY.equalTo(self.addFriendView.searchBtn.snp.centerY)
                make.right.equalTo(self.addFriendView.searchBtn.snp.left).offset(-10)
            }
        }
    }
}
