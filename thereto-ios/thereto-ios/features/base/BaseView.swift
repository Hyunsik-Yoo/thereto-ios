import UIKit

class BaseView: UIView {
    
    private let loadingView = UIActivityIndicatorView().then {
        if #available(iOS 13.0, *) {
            $0.style = .large
        } else {
            // Fallback on earlier versions
            $0.style = .gray
        }
        $0.hidesWhenStopped = true
    }
    
    lazy var dimView = UIView(frame: self.frame).then {
        $0.backgroundColor = .clear
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        bindConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        bindConstraints()
    }
    
    func setup() { }
    
    func bindConstraints() { }
    
    func startLoading() {
        addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        isUserInteractionEnabled = false
        loadingView.startAnimating()
    }
    
    func stopLoading() {
        loadingView.stopAnimating()
        isUserInteractionEnabled = true
        loadingView.removeFromSuperview()
    }
    
    func showLoading(isShow: Bool) {
        if isShow {
            addSubview(loadingView)
            loadingView.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
            }
            isUserInteractionEnabled = false
            loadingView.startAnimating()
        } else {
            loadingView.stopAnimating()
            isUserInteractionEnabled = true
            loadingView.removeFromSuperview()
        }
    }
    
    func addBgDim() {
        DispatchQueue.main.async { [weak self] in
            if let view = self {
                view.addSubview(view.dimView)
                UIView.animate(withDuration: 0.3) {
                    view.dimView.backgroundColor = UIColor.init(r: 0, g: 0, b: 0, a:0.5)
                }
            }
            
        }
    }
    
    
    func removeBgDim() {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.3, animations: {
                self?.dimView.backgroundColor = .clear
            }) { (_) in
                self?.dimView.removeFromSuperview()
            }
        }
    }
}
