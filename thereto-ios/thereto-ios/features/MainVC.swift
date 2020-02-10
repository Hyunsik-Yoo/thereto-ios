import UIKit


class MainVC: UITabBarController {
    
    let controllers = [LetterBoxVC.instance(), LetterBoxVC.instance(), FriendListVC.instance(),
                       FriendListVC.instance(), SetupVC.instance()]
    static func instance() -> MainVC {
        return MainVC.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        delegate = self
        
        setViewControllers(controllers, animated: true)
        
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont(name:"SpoqaHanSans-Regular", size:10)!,
             NSAttributedString.Key.foregroundColor: UIColor.greyishBrown],
            for: UIControl.State.selected)
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont(name:"SpoqaHanSans-Regular", size:11)!,
             NSAttributedString.Key.foregroundColor: UIColor.mushroom],
            for: UIControl.State.normal)
        
        tabBar.shadowImage = UIImage()
        tabBar.backgroundColor = .veryLightPink
        tabBar.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
}

extension MainVC: UITabBarControllerDelegate {
    
}
