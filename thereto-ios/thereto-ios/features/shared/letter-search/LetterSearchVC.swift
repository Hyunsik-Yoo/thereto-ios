import UIKit

class LetterSearchVC: BaseVC {
    
    private lazy var letterSearchView = LetterSearchView.init(frame: self.view.frame)
    
    
    static func instance() -> LetterSearchVC {
        return LetterSearchVC.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = letterSearchView
    }
    
    override func bindViewModel() {
        
    }
    
    override func bindEvent() {
        letterSearchView.backBtn.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
}
