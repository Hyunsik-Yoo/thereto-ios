import UIKit
import SnapKit
import RxSwift
import Firebase

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
                if !UserDefaultsUtil.isNormalLaunch() || !self.isSessionExisted() {
                    self.goToSignIn()
                } else {
                    self.goToMain()
                }
        }.disposed(by: disposeBag)
    }
    
    private func isSessionExisted() -> Bool {
        if let _ = Auth.auth().currentUser {
            return true
        } else {
            return false
        }
    }
    
    private func goToSignIn() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.goToSignIn()
        }
    }
    
    private func goToMain() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.goToMain()
        }
    }
}
