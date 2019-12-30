import UIKit

protocol FriendTabBarProtocol {
    func friendTabBar(scrollTo index: Int)
}

class FriendTabBar: BaseView {
    
    var deleagte: FriendTabBarProtocol?
    
    let tabBarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        $0.collectionViewLayout = layout
        $0.backgroundColor = UIColor.themeColor
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
    }
    
    let indicatorView = UIView().then {
        $0.backgroundColor = UIColor.init(r: 66, g: 40, b: 15)
    }
    
    let containerView = UIView()
    
    
    override func setup() {
        containerView.addSubViews(tabBarCollectionView, indicatorView)
        addSubViews(containerView)
        
        tabBarCollectionView.delegate = self
        tabBarCollectionView.dataSource = self
        tabBarCollectionView.register(TabBarCell.self, forCellWithReuseIdentifier: TabBarCell.registerId)
    }
    
    override func bindConstraints() {
        containerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(42)
        }
        
        tabBarCollectionView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        indicatorView.snp.makeConstraints { (make) in
            make.left.equalTo(tabBarCollectionView.snp.left)
            make.height.equalTo(1)
            make.width.equalTo(UIScreen.main.bounds.width / 2)
            make.bottom.equalToSuperview()
        }
    }
}

extension FriendTabBar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabBarCell.registerId, for: indexPath) as? TabBarCell else {
            return BaseCollectionViewCell()
        }
        
        if indexPath.row == 1 {
            cell.titleLabel.textColor = UIColor.init(r: 206, g: 176, b: 164)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 2, height: 42)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TabBarCell else {return}
        cell.titleLabel.textColor = UIColor.init(r: 60, g: 46, b: 42)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.indicatorView.snp.updateConstraints { (make) in
                make.left.equalTo(self.tabBarCollectionView.snp.left).offset((self.frame.width / 2) * CGFloat((indexPath.row)))
            }
            self.layoutIfNeeded()
        }, completion: nil)
        self.deleagte?.friendTabBar(scrollTo: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TabBarCell else {return}
        cell.titleLabel.textColor = UIColor.init(r: 206, g: 176, b: 164)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

