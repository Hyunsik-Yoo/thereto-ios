import UIKit

class LetterBoxVC: BaseVC {
    
    private lazy var letterBoxView: LetterBoxView = {
        let view = LetterBoxView(frame: self.view.bounds)
        
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    static func instance() -> UINavigationController {
        let controller = LetterBoxVC(nibName: nil, bundle: nil)
        
        return UINavigationController(rootViewController: controller)
    }
    
    override func viewDidLoad() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(letterBoxView)
        letterBoxView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        initDrawer()
        
        letterBoxView.topBar.setLetterBoxMode()
        
        letterBoxView.tableView.separatorStyle = .none
        letterBoxView.tableView.delegate = self
        letterBoxView.tableView.dataSource = self
        letterBoxView.tableView.register(LetterCell.self, forCellReuseIdentifier: LetterCell.registerId)
    }
    
    private func initDrawer() {
        letterBoxView.topBar.hambugerBtn.rx.tap.bind { () in
            self.letterBoxView.showMenu()
        }.disposed(by: disposeBag)
        
        letterBoxView.drawer.closeBtn.rx.tap.bind {
            self.letterBoxView.hideMenu { }
        }.disposed(by: disposeBag)
        
        letterBoxView.drawer.friendBtn.rx.tap.bind { [weak self] in
            self?.letterBoxView.hideMenu {
                self?.goToFriend()
            }
        }.disposed(by: disposeBag)
        
        let tapGesture = UITapGestureRecognizer()
        
        letterBoxView.drawer.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind { _ in
            self.letterBoxView.hideMenu { }
        }.disposed(by: disposeBag)
        
        letterBoxView.drawer.friendControllBtn.rx.tap.bind {
            self.navigationController?.pushViewController(FriendControlVC.instance(), animated: true)
        }.disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        
    }
    
    private func goToFriend() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.goToFriend()
        }
    }
}

extension LetterBoxVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.letterBoxView.tableView.dequeueReusableCell(withIdentifier: LetterCell.registerId, for: indexPath) as? LetterCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.letterBoxView.hideWriteBtn()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            stoppedScrolling()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        stoppedScrolling()
    }
    
    func stoppedScrolling() {
        self.letterBoxView.showWrieBtn()
    }
    
}
