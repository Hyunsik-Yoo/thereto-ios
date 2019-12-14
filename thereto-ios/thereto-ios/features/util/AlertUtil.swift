import UIKit

struct AlertUtil {
    
    static func show(vc: UIViewController, title: String? = nil, message: String? = nil) {
        let okAction = UIAlertAction(title: "확인", style: .default)
        
        show(vc: vc, title: nil, message: message, [okAction])
    }
    
    static func showWithCancel(vc: UIViewController, title: String? = nil, message: String? = nil) {
        let okAction = UIAlertAction(title: "확인", style: .default)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        show(vc: vc, title: title, message: message, [okAction, cancelAction])
    }
    
    static func show(vc: UIViewController, title: String?, message: String?, _ actions: [UIAlertAction]) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in actions {
            controller.addAction(action)
        }
        vc.present(controller, animated: true)
    }
}
