import UIKit

class AddFriendVC: BaseVC {
    
    private lazy var addFriendView = AddFriendView(frame: self.view.frame)
    
    
    static func instance() -> AddFriendVC {
        return AddFriendVC(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = addFriendView
    }
    
    override func bindViewModel() {
        addFriendView.backBtn.rx.tap.bind {
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
}
