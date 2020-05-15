import UIKit
import RxSwift
import RxCocoa

class AddFriendVC: BaseVC {
    
    private lazy var addFriendView = AddFriendView(frame: self.view.frame)
    
    private let viewModel = AddFriendViewModel(userService: UserService(),
                                               userDefaults: UserDefaultsUtil())
    
    
    static func instance() -> AddFriendVC {
        return AddFriendVC(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = addFriendView
        setupTableView()
        viewModel.fetchFriend()
    }
    
    override func bindViewModel() {
        // Bind Input
        addFriendView.nicknameField.rx.text.orEmpty.bind(to: viewModel.input.nicknameText)
            .disposed(by: disposeBag)
        addFriendView.searchBtn.rx.tap.bind(to: viewModel.input.tapSearch)
            .disposed(by: disposeBag)
        
        // Bind Output
        viewModel.output.userList.bind(to: addFriendView.tableView.rx.items(cellIdentifier: AddFriendCell.registerId, cellType: AddFriendCell.self)) { [weak self] row, user, cell in
            guard let self = self else { return }
            cell.bind(friend: user)
            cell.addBtn.rx.tap.bind { (_) in
                AlertUtil.showWithCancel(title: "친구 요청", message: "친구 요청을 보내시겠습니까?") {
                    self.viewModel.input.requestFriend.onNext(row)
                }
            }.disposed(by: cell.disposeBag)
        }.disposed(by: disposeBag)
        viewModel.output.dataMode.bind(onNext: addFriendView.setDataMode(isDataMode:))
            .disposed(by: disposeBag)
        viewModel.output.showLoading.bind(onNext: addFriendView.showLoading(isShow:))
            .disposed(by: disposeBag)
        viewModel.output.showAlert.bind { [weak self] (title, message) in
            guard let self = self else { return }
            AlertUtil.show(controller: self, title: title, message: message)
        }.disposed(by: disposeBag)
    }
    
    override func bindEvent() {
        addFriendView.backBtn.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        addFriendView.linkBtn.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            AlertUtil.show(controller: self, title: "", message: "준비중입니다.")
        }.disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        addFriendView.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        addFriendView.tableView.register(AddFriendCell.self, forCellReuseIdentifier: AddFriendCell.registerId)
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
