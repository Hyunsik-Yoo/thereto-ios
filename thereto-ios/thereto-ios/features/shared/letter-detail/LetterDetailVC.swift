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
        
        letterDetailView.deleteBtn.rx.tap.bind { [weak self] in
            if let vc = self {
                AlertUtil.showWithCancel(controller: vc, message: "삭제하시겠습니까?") {
                    if UserDefaultsUtil.isTutorialFinished() { // 튜토리얼일 경우 UserDefault 에서 설정
                        vc.deleteLetter(letterId: vc.letter.id)
                    } else {
                        UserDefaultsUtil.setTutorialFinish()
                        vc.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }.disposed(by: disposeBag)
    }
    
    private func setRead() {
        if letter.id != "tutorial" {
            LetterSerivce.setRead(letterId: letter.id)
        }
    }
    
    private func deleteLetter(letterId: String) {
        LetterSerivce.deleteLetter(letterId: letterId) { [weak self] (result) in
            switch result {
            case .success(_):
                self?.navigationController?.popViewController(animated: true)
            case .failure(let error):
                AlertUtil.show("삭제 오류", message: error.localizedDescription)
            }
        }
    }
}
