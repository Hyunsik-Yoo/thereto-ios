import UIKit

class WriteVC: BaseVC {
    
    private lazy var writeView = WriteView.init(frame: self.view.frame)
    
    static func instance() -> UINavigationController {
        let controller = WriteVC.init(nibName: nil, bundle: nil)
        
        controller.tabBarItem = UITabBarItem.init(title: "엽서쓰기", image: UIImage.init(named: "ic_write"), selectedImage: UIImage.init(named: "ic_write"))
        
        return UINavigationController.init(rootViewController: controller).then {
            $0.modalPresentationStyle = .fullScreen
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        view = writeView
    }
    
    override func bindEvent() {
        writeView.closeBtn.rx.tap.bind { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
}
