import UIKit

class LetterBoxVC: BaseVC {
    
    private lazy var letterBoxView: LetterBoxView = {
        let view = LetterBoxView(frame: self.view.bounds)
        
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    static func instance() -> LetterBoxVC {
        return LetterBoxVC(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        view = letterBoxView
        initDrawer()
        
        self.letterBoxView.tableView.separatorStyle = .none
        self.letterBoxView.tableView.delegate = self
        self.letterBoxView.tableView.dataSource = self
        self.letterBoxView.tableView.register(LetterCell.self, forCellReuseIdentifier: LetterCell.registerId)
    }
    
    private func initDrawer() {
        letterBoxView.topBar.hambugerBtn.rx.tap.bind { () in
            self.letterBoxView.showMenu()
        }.disposed(by: disposeBag)
        
        letterBoxView.drawer.closeBtn.rx.tap.bind {
            self.letterBoxView.hideMenu { }
        }.disposed(by: disposeBag)
        
        let tapGesture = UITapGestureRecognizer()
        
        letterBoxView.drawer.isUserInteractionEnabled = true
        letterBoxView.drawer.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event.bind { _ in
            self.letterBoxView.hideMenu { }
        }.disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        
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
