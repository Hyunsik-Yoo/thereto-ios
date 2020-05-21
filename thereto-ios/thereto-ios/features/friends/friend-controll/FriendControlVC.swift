import UIKit

class FriendControlVC: BaseVC {
    
    private lazy var friendControlView = FriendControlView(frame: self.view.frame)
    private var previousOffset: CGFloat = 0
    let pageVC = FriendPageVC.instance()
    
    static func instance() -> FriendControlVC {
        return FriendControlVC(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = friendControlView
        setupPageVC()
        fetchRedDot()
    }
    
    override func bindViewModel() {
        friendControlView.backBtn.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        friendControlView.receivedBtn.rx.tap.bind { [weak self] in
            self?.friendControlView.selectTab(index: 0)
            self?.pageVC.scrollToIndex(index: 0)
        }.disposed(by: disposeBag)
        
        friendControlView.sentBtn.rx.tap.bind { [weak self] in
            self?.friendControlView.selectTab(index: 1)
            self?.pageVC.scrollToIndex(index: 1)
        }.disposed(by: disposeBag)
    }
    
    private func setupPageVC() {
        addChild(pageVC)
        pageVC.friendPageDelegate = self
        friendControlView.pageView.addSubview(pageVC.view)
        pageVC.view.snp.makeConstraints { (make) in
            make.edges.equalTo(friendControlView.pageView)
        }
    }
    
    private func fetchRedDot() {
        UserService.fetchRedDot(token: UserDefaultsUtil().getUserToken())
    }
}

extension FriendControlVC: FriendPageDelegate {
    func onSelectTap(index: Int) {
        self.friendControlView.selectTab(index: index)
        self.pageVC.scrollToIndex(index: index)
    }
}

