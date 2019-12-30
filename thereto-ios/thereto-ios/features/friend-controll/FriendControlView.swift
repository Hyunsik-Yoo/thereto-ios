import UIKit

class FriendControlView: BaseView {
    
    let backBtn = UIButton().then {
        $0.setImage(UIImage.init(named: "ic_back"), for: .normal)
    }
    
    let friendTabBar = FriendTabBar()
    
    let pageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        $0.collectionViewLayout = layout
        $0.backgroundColor = UIColor.themeColor
        $0.showsHorizontalScrollIndicator = false
    }
    
    
    override func setup() {
        backgroundColor = UIColor.themeColor
        addSubViews(backBtn, friendTabBar, pageCollectionView)
    }
    
    override func bindConstraints() {
        backBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.width.height.equalTo(24)
        }
        
        friendTabBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(backBtn.snp.bottom)
            make.height.equalTo(58)
        }
        
        pageCollectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(friendTabBar.snp.bottom)
        }
    }
}
