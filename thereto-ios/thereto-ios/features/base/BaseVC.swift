import UIKit
import RxSwift

class BaseVC: UIViewController {
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindEvent()
    }
    
    func bindViewModel() { }
    
    func bindEvent() { }
}
