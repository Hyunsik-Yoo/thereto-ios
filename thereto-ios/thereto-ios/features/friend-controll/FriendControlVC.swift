import UIKit

class FriendControlVC: BaseVC {
    
    private lazy var friendControlView = FriendControlView(frame: self.view.frame)
    
    
    static func instance() -> FriendControlVC {
        return FriendControlVC(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = friendControlView
        
        friendControlView.friendTabBar.deleagte = self
        friendControlView.pageCollectionView.delegate = self
        friendControlView.pageCollectionView.dataSource = self
        friendControlView.pageCollectionView.isPagingEnabled = true
        friendControlView.pageCollectionView.register(PageCell.self, forCellWithReuseIdentifier: PageCell.registerId)
    }
    
    override func bindViewModel() {
        friendControlView.backBtn.rx.tap.bind {
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
}

extension FriendControlVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FriendTabBarProtocol {
    func friendTabBar(scrollTo index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        
        self.friendControlView.pageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCell.registerId, for: indexPath) as? PageCell else {
            return BaseCollectionViewCell()
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.friendControlView.friendTabBar.indicatorView.snp.updateConstraints { (make) in
            make.left.equalTo(self.friendControlView.friendTabBar.tabBarCollectionView.snp.left).offset((scrollView.contentOffset.x / 2))
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemAt = Int(targetContentOffset.pointee.x / self.view.frame.width)
        let selectedIndex = IndexPath(item: itemAt, section: 0)
        let deSelectedIndex = IndexPath(item: itemAt == 0 ? 1 : 0, section: 0)
        
        self.friendControlView.friendTabBar.collectionView(self.friendControlView.friendTabBar.tabBarCollectionView, didSelectItemAt: selectedIndex)
        self.friendControlView.friendTabBar.collectionView(self.friendControlView.friendTabBar.tabBarCollectionView, didDeselectItemAt: deSelectedIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.friendControlView.pageCollectionView.frame.width, height: self.friendControlView.pageCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


