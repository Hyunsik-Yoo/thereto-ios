import UIKit

class ProfileVC: BaseVC {
    
    private lazy var profileView: ProfileView =  {
        let profileView = ProfileView(frame: self.view.bounds)
        
        return profileView
    }()
    
    
    static func instance() -> ProfileVC {
        return ProfileVC(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        view = profileView
    }
}
