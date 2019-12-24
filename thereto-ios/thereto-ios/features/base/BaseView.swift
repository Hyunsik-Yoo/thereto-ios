import UIKit

class BaseView: UIView {
    
    private let loadingView = UIActivityIndicatorView().then {
        $0.style = .large
        $0.hidesWhenStopped = true
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
}
