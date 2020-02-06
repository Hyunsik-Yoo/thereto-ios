import UIKit

class FriendDetailVC: BaseVC {
    private lazy var friendDetailView = FriendDetailView.init(frame: self.view.frame)
    private var friendId: String!
    
    static func instance(friendId: String) -> FriendDetailVC {
        return FriendDetailVC.init(nibName: nil, bundle: nil).then {
            $0.friendId = friendId
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = friendDetailView
    }
    
    private func getFriendInfo() {
        
    }
}
