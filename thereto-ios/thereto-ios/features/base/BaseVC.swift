import UIKit
import RxSwift

class BaseVC: UIViewController {
    
    let compositDisposable: CompositeDisposable = CompositeDisposable()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if(!compositDisposable.isDisposed) {
            compositDisposable.dispose()
        }
    }
}
