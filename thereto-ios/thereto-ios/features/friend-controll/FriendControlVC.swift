import UIKit

class FriendControlVC: BaseVC {
    
    private lazy var friendControlView = FriendControlView(frame: self.view.frame)
    let pageVC = FriendPageVC.instance()
    
    static func instance() -> FriendControlVC {
        return FriendControlVC(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = friendControlView
        setupPageVC()
//        friendControlView.friendTabBar.deleagte = self
    }
    
    override func bindViewModel() {
        friendControlView.backBtn.rx.tap.bind {
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func setupPageVC() {
        addChild(pageVC)
        friendControlView.pageView.addSubview(pageVC.view)
        pageVC.view.snp.makeConstraints { (make) in
            make.edges.equalTo(friendControlView.pageView)
        }
        
        for v in pageVC.view.subviews{
            if v is UIScrollView{
                (v as! UIScrollView).delegate = self
            }
        }
    }
}

extension FriendControlVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.friendControlView.indicatorView.snp.updateConstraints { (make) in
            print(scrollView.contentOffset.x)
            make.left.equalToSuperview().offset(scrollView.contentOffset.x / 2)
        }
    }
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let itemAt = Int(targetContentOffset.pointee.x / self.view.frame.width)
//        let selectedIndex = IndexPath(item: itemAt, section: 0)
//        let deSelectedIndex = IndexPath(item: itemAt == 0 ? 1 : 0, section: 0)
//
//        self.friendControlView.friendTabBar.collectionView(self.friendControlView.friendTabBar.tabBarCollectionView, didSelectItemAt: selectedIndex)
//        self.friendControlView.friendTabBar.collectionView(self.friendControlView.friendTabBar.tabBarCollectionView, didDeselectItemAt: deSelectedIndex)
//    }
}

