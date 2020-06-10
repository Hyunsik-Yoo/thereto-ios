import UIKit
import SnapKit
import RxSwift
import Firebase

class SplashVC: BaseVC {
    
    private lazy var splashView = SplashView(frame: self.view.frame)
    private var viewModel = SplashViewModel(userDefaults: UserDefaultsUtil(),
                                            userService: UserService())
    
    static func instance() -> SplashVC {
        return SplashVC(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        view = splashView
        super.viewDidLoad()
        
        Observable<Void>.empty()
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe({ (_) in
                self.viewModel.input.checkAuth.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        viewModel.output.goToMain.bind(onNext: goToMain)
            .disposed(by: disposeBag)
        viewModel.output.goToSignIn.bind(onNext: goToSignIn)
            .disposed(by: disposeBag)
    }
    
    override func bindEvent() {
        
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
