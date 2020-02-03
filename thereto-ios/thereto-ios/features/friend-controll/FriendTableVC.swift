import UIKit

class FriendTableVC: BaseVC {
    
    private lazy var friendTableView = FriendTableView.init(frame: self.view.frame)
    
    static func instance() -> FriendTableVC {
        return FriendTableVC.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = friendTableView
    }
    
    override func bindViewModel() {
        
    }
}
