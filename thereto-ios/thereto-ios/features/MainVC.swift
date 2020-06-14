import UIKit
import RxSwift


class MainVC: UITabBarController {
    
    let controllers = [LetterBoxVC.instance(), SentLetterVC.instance(), WriteVC.instance(),
                       FriendListVC.instance(), SetupVC.instance()]
    let disposeBag = DisposeBag()
    
    
    static func instance() -> MainVC {
        return MainVC.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers(controllers, animated: true)
        delegate = self
        
        setupTabBar()
        fetchAlarm()
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
        
//        UITabBar.appearance().tintColor = .greyishBrown
        UITabBar.appearance().barTintColor = .veryLightPink
        
        tabBar.shadowImage = UIImage()
        tabBar.backgroundColor = .veryLightPink
        tabBar.clipsToBounds = true
    }
    
    private func fetchAlarm() {
        UserService().fetchAlarm(userId: UserDefaultsUtil().getUserToken()) { [weak self] (alarmObservable) in
            guard let self = self else { return }
            alarmObservable.subscribe(onNext: { (alarm) in
                switch alarm.type {
                case .NEW_LETTER:
                    self.controllers[0].tabBarItem = UITabBarItem.init(title: "수신함", image: UIImage.init(named: "ic_letter_box_red_dot_off"), selectedImage: UIImage.init(named: "ic_letter_box_red_dot_on"))
                case .NEW_REQUEST:
                    self.controllers[3].tabBarItem = UITabBarItem.init(title: "수신함", image: UIImage.init(named: "ic_friend_red_dot_off"), selectedImage: UIImage.init(named: "ic_friend_red_dot_on"))
                default:
                    break
                }
                AlertUtil.showWithCancel(controller: self, title: alarm.title, message: alarm.message) {
                    switch alarm.type {
                    case .NEW_LETTER:
                        self.selectedIndex = 0
                    case .NEW_REQUEST:
                        self.selectedIndex = 3
                    default:
                        self.selectedIndex = 0
                    }
                }
            }, onError: { (error) in
                AlertUtil.show(controller: self, title: "알림 조회 오류", message: error.localizedDescription)
            }).disposed(by: self.disposeBag)
        }
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
            if rootVC is LetterBoxVC {
                self.controllers[0].tabBarItem = UITabBarItem.init(title: "수신함", image: UIImage.init(named: "ic_letter_box_off"), selectedImage: UIImage.init(named: "ic_letter_box_on"))
            }
            if rootVC is FriendListVC {
                self.controllers[3].tabBarItem = UITabBarItem.init(title: "친구관리", image: UIImage.init(named: "ic_friend_off"), selectedImage: UIImage.init(named: "ic_friend_on"))

            }
        }
        self.fetchAlarm()
        return true
    }
}
