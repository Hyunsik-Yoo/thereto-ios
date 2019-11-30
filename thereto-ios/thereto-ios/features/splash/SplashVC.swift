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
        
        let delay = Single<Void>.create { (observable) -> Disposable in
            observable(.success(()))
            
            return Disposables.create()
        }
        
        
        delay.delay(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe { (void) in
                // TODO: 다음 화면으로 넘어가기
        }
    }
}
