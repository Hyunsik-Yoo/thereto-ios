import UIKit

struct AlertUtil {
    
    static func show(_ title: String? = nil, message: String? = nil) {
        let okAction = UIAlertAction(title: "확인", style: .default)
        
        show(title: nil, message: message, [okAction])
    }
    
    static func showWithCancel(title: String? = nil, message: String? = nil, onTapOk: @escaping () -> Void) {
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            onTapOk()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        show(title: title, message: message, [okAction, cancelAction])
    }
    
    static func show(title: String?, message: String?, _ actions: [UIAlertAction]) {
        if let appDelegate = UIApplication.shared.delegate,
            let rootVC = appDelegate.window??.rootViewController {
            let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            for action in actions {
                controller.addAction(action)
            }
            rootVC.present(controller, animated: true)
        }
    }
}
