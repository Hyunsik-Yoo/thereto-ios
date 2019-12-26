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
        addFriendView.tableView.delegate = self
        addFriendView.tableView.register(AddFriendCell.self, forCellReuseIdentifier: AddFriendCell.registerId)
    }
    
    override func bindViewModel() {
        addFriendView.backBtn.rx.tap.bind {
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        addFriendView.nicknameField.rx.controlEvent(.editingDidEndOnExit).bind {
            self.findUser(inputNickname: self.addFriendView.nicknameField.text!)
        }.disposed(by: disposeBag)
        
        addFriendView.searchBtn.rx.tap.bind {
            self.findUser(inputNickname: self.addFriendView.nicknameField.text!)
        }.disposed(by: disposeBag)
        
        
        viewModel.people.asObservable().bind(to: addFriendView.tableView.rx.items(cellIdentifier: AddFriendCell.registerId, cellType: AddFriendCell.self)) { index, user, cell in
            if let user = user {
                self.addFriendView.setDataMode(isDataMode: true)
                cell.bind(user: user)
            } else {
                self.addFriendView.setDataMode(isDataMode: false)
            }
        }.disposed(by: disposeBag)
        
        addFriendView.linkBtn.rx.tap.bind {

        }.disposed(by: disposeBag)
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
                    self.viewModel.people.accept(userList)

                }
                self.addFriendView.stopLoading()
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
