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
        
        
        viewModel.people.asObservable().bind(to: addFriendView.tableView.rx.items(cellIdentifier: AddFriendCell.registerId, cellType: AddFriendCell.self)) { index, user, cell in
            if user != nil {
                self.addFriendView.setDataMode(isDataMode: true)
                cell.bind(user: user)
            } else {
                self.addFriendView.setDataMode(isDataMode: false)
            }
        }.disposed(by: disposeBag)
        
        addFriendView.linkBtn.rx.tap.bind {
            self.viewModel.people.accept([User.init(nickname: "", name: "", social: "facebook", id: "", profileURL: "")])
        }.disposed(by: disposeBag)
    }
}

extension AddFriendVC: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (self.lastContentOffset > scrollView.contentOffset.y) {
//            self.letterBoxView.tableView.transform = self.letterBoxView.tableView.transform.translatedBy(x: 0, y: 2)
//        }
//        else if (self.lastContentOffset < scrollView.contentOffset.y) {
//            self.letterBoxView.tableView.transform = self.letterBoxView.tableView.transform.translatedBy(x: 0, y: -2)
//        }
//        self.letterBoxView.tableView.layoutIfNeeded()
        print(scrollView.contentOffset.y)
    }
}
