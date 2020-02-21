import UIKit

protocol PlaceTitleDelegate: class {
    func onClose()
    
    func onSelectName(name: String)
}

class PlaceTitleVC: BaseVC {
    private lazy var placeTitleView = PlaceTitleView.init(frame: self.view.frame)
    
    var delegate: PlaceTitleDelegate?
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    static func instance() -> PlaceTitleVC {
        return PlaceTitleVC.init(nibName: nil, bundle: nil).then {
            $0.modalPresentationStyle = .overCurrentContext
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = placeTitleView
        setupKeyboardEvent()
    }
    
    override func bindEvent() {
        placeTitleView.swipeDownGesture.rx.event.subscribe { (event) in
            if let direction = event.element?.direction,
            direction == .down {
                self.delegate?.onClose()
                self.dismiss(animated: true, completion: nil)
            }
        }.disposed(by: disposeBag)
        
        placeTitleView.closeBtn.rx.tap.bind {[weak self] in
            self?.delegate?.onClose()
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        placeTitleView.confirmBtn.rx.tap.bind { [weak self] in
            if let vc = self {
                let name = vc.placeTitleView.placeField.text!
                vc.dismiss(animated: true, completion: {
                    vc.delegate?.onSelectName(name: name)
                })
            }
        }.disposed(by: disposeBag)
        
        placeTitleView.placeField.rx.controlEvent(.editingChanged).bind { [weak self] (_) in
            if let vc = self {
                vc.placeTitleView.setbtnEnable(isEnable: !vc.placeTitleView.placeField.text!.isEmpty)
            }
        }.disposed(by: disposeBag)
    }
    
    private func setupKeyboardEvent() {
        NotificationCenter.default.addObserver(self, selector: #selector(onShowKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onHideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func onShowKeyboard(notification: NSNotification) {
        guard let userInfo = notification.userInfo as? [String:Any] else {return}
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.cgRectValue.height + 60)
    }
    
    @objc func onHideKeyboard(notification: NSNotification) {
        self.view.transform = .identity
    }
}
