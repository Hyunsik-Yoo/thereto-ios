import UIKit

class LetterDetailVC: BaseVC {
    
    private lazy var letterDetailView = LetterDetailView.init(frame: self.view.frame)
    
    var letter: Letter!
    
    static func instance(letter: Letter) -> LetterDetailVC {
        return LetterDetailVC.init(nibName: nil, bundle: nil).then {
            $0.letter = letter
            $0.hidesBottomBarWhenPushed = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = letterDetailView
        letterDetailView.bind(letter: letter)
        setRead()
    }
    
    override func bindEvent() {
        letterDetailView.backBtn.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func setRead() {
        LetterSerivce.setRead(letterId: letter.id)
    }
}
