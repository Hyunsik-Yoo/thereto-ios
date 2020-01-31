import UIKit

class FriendTableVC: BaseVC {
    
    var a: Int!
    private lazy var friendTableView = FriendTableView.init(frame: self.view.frame)
    
    static func instance(a: Int) -> FriendTableVC {
        return FriendTableVC.init(nibName: nil, bundle: nil).then {
            $0.a = a
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view = friendTableView
        
        if a == 0 {
            view.backgroundColor = .yellow
        } else {
            view.backgroundColor = .red
        }
    }
    
    override func bindViewModel() {
        
    }
}
