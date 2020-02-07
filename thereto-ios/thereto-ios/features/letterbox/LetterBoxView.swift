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
    
    let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    let writeBtn: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.backgroundColor = UIColor.init(r: 255, g: 84, b: 41)
        button.setImage(UIImage.init(named: "ic_write"), for: .normal)
        return button
    }()
    
    override func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.themeColor
        addSubViews(topBar, rightWhiteView, drawer, tableView, writeBtn)
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
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        writeBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-30)
            make.right.equalToSuperview().offset(-30)
            make.width.height.equalTo(60)
        }
    }
    
    func showMenu() {
        bringSubviewToFront(drawer)
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
    
    func hideWriteBtn() {
        if writeBtn.alpha != 0 {
            let originalTransform = self.writeBtn.transform
            
            UIView.animateKeyframes(withDuration: 0.2, delay: 0, animations: {
                self.writeBtn.transform = originalTransform.translatedBy(x: 0.0, y: 90)
                self.writeBtn.alpha = 0
            })
        }
    }
    
    func showWrieBtn() {
        if writeBtn.alpha != 1 {
            let originalTransform = self.writeBtn.transform
            
            UIView.animateKeyframes(withDuration: 0.2, delay: 0, animations: {
                self.writeBtn.transform = originalTransform.translatedBy(x: 0.0, y: -90)
                self.writeBtn.alpha = 1
            })
        }
    }
}
