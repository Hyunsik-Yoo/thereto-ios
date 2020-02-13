import UIKit

protocol PlaceTitleDelegate: class {
    func onClose()
}

class PlaceTitleVC: BaseVC {
    private lazy var placeTitleView = PlaceTitleView.init(frame: self.view.frame)
    
    var delegate: PlaceTitleDelegate?
    
    static func instance() -> PlaceTitleVC {
        return PlaceTitleVC.init(nibName: nil, bundle: nil).then {
            $0.modalPresentationStyle = .overCurrentContext
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = placeTitleView
    }
    
    override func bindEvent() {
        placeTitleView.closeBtn.rx.tap.bind {[weak self] in
            self?.delegate?.onClose()
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
}
