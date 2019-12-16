import UIKit

class LetterBoxVC: BaseVC {
    
    private lazy var letterBoxView: LetterBoxView = {
        let view = LetterBoxView(frame: self.view.bounds)
        
        return view
    }()
    
    
    static func instance() -> LetterBoxVC {
        return LetterBoxVC(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        view = letterBoxView
    }
    
    override func bindViewModel() {
        
    }
}
