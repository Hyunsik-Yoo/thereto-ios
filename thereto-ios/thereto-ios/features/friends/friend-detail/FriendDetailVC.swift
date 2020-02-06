import UIKit

class FriendDetailVC: BaseVC {
    private lazy var friendDetailView = FriendDetailView.init(frame: self.view.frame)
    
    static func instance() -> FriendDetailVC {
        return FriendDetailVC.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = friendDetailView
    }
}
