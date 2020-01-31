import UIKit

class FriendPageVC: UIPageViewController {
    
    let controllers = [FriendTableVC.instance(a: 0), FriendTableVC.instance(a: 1)]
    
    static func instance() -> FriendPageVC {
        return FriendPageVC.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        setViewControllers([controllers[0]], direction: .forward, animated: true, completion: nil)
    }
}

extension FriendPageVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController as! FriendTableVC) else {
            return nil
        }
        let previousIndex = index - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard controllers.count > previousIndex else {
            return nil
        }
        return controllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController as! FriendTableVC) else {
            return nil
        }
        let nextIndex = index + 1
        guard nextIndex < controllers.count else {
            return nil
        }
        guard controllers.count > nextIndex else {
            return nil
        }
        return controllers[nextIndex]
    }
}
