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
