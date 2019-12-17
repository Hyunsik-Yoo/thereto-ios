import UIKit

class LetterBoxView: BaseView {
    
    let topBar : BoxNavigationBar = {
        let topBar = BoxNavigationBar()
        
        topBar.isUserInteractionEnabled = true
        return topBar
    }()

    private let rightWhiteView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        return view
    }()
    
    let drawer: DrawerView = {
        let view = DrawerView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.themeColor
        addSubViews(topBar, rightWhiteView, drawer)
    }
    
    override func bindConstraints() {
        topBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
        }
        
        rightWhiteView.snp.makeConstraints { (make) in
            make.top.equalTo(topBar.snp.bottom)
            make.bottom.right.equalToSuperview()
            make.width.equalTo(70)
        }
        
        drawer.snp.makeConstraints { (make) in
            make.left.equalTo(topBar.snp.right)
            make.top.equalTo(safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    func showMenu() {
        drawer.snp.remakeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        }) { (_) in
            self.drawer.backgroundColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.5)
            self.layoutIfNeeded()
        }
    }
    
    func hideMenu(completion: @escaping () -> Void) {
        drawer.snp.remakeConstraints { (make) in
            make.left.equalTo(topBar.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        self.drawer.backgroundColor = .clear
        
        
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        }) { (_) in
            completion()
        }
    }
}
