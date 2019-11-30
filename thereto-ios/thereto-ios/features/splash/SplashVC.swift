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
        
        let disposable = Completable.create { (event) -> Disposable in
            event(.completed)
            
            return Disposables.create()
        }
        
        
        let _ = compositDisposable.insert(
            disposable.delay(.seconds(2), scheduler: MainScheduler.instance)
                .subscribe { (void) in
                    // TODO: 다음 화면으로 넘어가기
        })
    }
}
