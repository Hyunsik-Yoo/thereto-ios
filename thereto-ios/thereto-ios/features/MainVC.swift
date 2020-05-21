import UIKit


class MainVC: UITabBarController {
    
    let controllers = [LetterBoxVC.instance(), SentLetterVC.instance(), WriteVC.instance(),
                       FriendListVC.instance(), SetupVC.instance()]
    
    
    static func instance() -> MainVC {
        return MainVC.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers(controllers, animated: true)
        delegate = self
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont(name:"SpoqaHanSans-Regular", size:10)!,
             NSAttributedString.Key.foregroundColor: UIColor.greyishBrown],
            for: UIControl.State.selected)
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont(name:"SpoqaHanSans-Regular", size:11)!,
             NSAttributedString.Key.foregroundColor: UIColor.mushroom],
            for: UIControl.State.normal)
        UITabBar.appearance().tintColor = .greyishBrown
        UITabBar.appearance().barTintColor = .veryLightPink
        
        tabBar.shadowImage = UIImage()
        tabBar.backgroundColor = .veryLightPink
        tabBar.clipsToBounds = true
    }
}

extension MainVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // 쓰기 탭 버튼 눌렀을때는 탭이 아니라 하단에서 올라오는 식으로 적용
        if let navi = viewController as? UINavigationController,
            let rootVC = navi.viewControllers.first {
            if rootVC is WriteVC {
                self.present(WriteVC.instance(), animated: true)
                return false
            }
        }
        return true
    }
}
