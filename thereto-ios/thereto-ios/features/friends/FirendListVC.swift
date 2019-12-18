import UIKit

class FriendListVC: BaseVC {
    
    private let friendListView: FriendListView = {
        let view = FriendListView()
        
        view.isUserInteractionEnabled = true
        return view
    }()
    
    static func instance() -> UINavigationController {
        let controller = FriendListVC(nibName: nil, bundle: nil)
        let navi = UINavigationController(rootViewController: controller)
        
        return navi
    }
    
    
    override func viewDidLoad() {
        view.addSubview(friendListView)
        initDrawer()
        friendListView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        navigationController?.isNavigationBarHidden = true
        friendListView.topBar.setFriendListMode()
        
        // TODO: UserDefaults 만들어서 내 정보 저장해야함
        UserService.findFriend(id: "facebook2574917595938223") { (friendList) in
            if friendList.isEmpty {
                print("friendList is empty")
            } else {
                print("friendList is not empty")
            }
        }
    }
    
    override func bindViewModel() {
        
    }
    
    private func initDrawer() {
        friendListView.topBar.hambugerBtn.rx.tap.bind { () in
            self.friendListView.showMenu()
        }.disposed(by: disposeBag)
        
        friendListView.drawer.closeBtn.rx.tap.bind {
            self.friendListView.hideMenu { }
        }.disposed(by: disposeBag)
        
        
        let letterboxLabelTap = UITapGestureRecognizer()
        
        friendListView.drawer.letterboxLabel.addGestureRecognizer(letterboxLabelTap)
        letterboxLabelTap.rx.event.bind { (_) in
            self.friendListView.hideMenu {
                self.goToLetterBox()
            }
        }.disposed(by: disposeBag)
        
        let tapGesture = UITapGestureRecognizer()
        
        friendListView.drawer.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind { _ in
            self.friendListView.hideMenu { }
        }.disposed(by: disposeBag)
    }
    
    private func goToLetterBox() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.goToLetterbox()
        }
    }
}
