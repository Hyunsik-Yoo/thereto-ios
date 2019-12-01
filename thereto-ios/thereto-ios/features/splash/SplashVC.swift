import UIKit
import SnapKit
import RxSwift

class SplashVC: BaseVC {
    
    private lazy var splashView: SplashView = {
        let view = SplashView(frame: self.view.frame)
        
        return view
    }()
    
    
    static func instance() -> SplashVC {
        return SplashVC(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        view = splashView
        
        Observable<Void>.empty()
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe { (event) in
                self.goToSignIn()
        }.disposed(by: disposeBag)
    }
    
    private func goToSignIn() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.goToSignIn()
    }
}
