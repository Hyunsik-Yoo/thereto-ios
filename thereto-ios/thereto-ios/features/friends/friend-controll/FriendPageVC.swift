import UIKit

protocol FriendPageDelegate: class {
    func onSelectTap(index: Int)
}

class FriendPageVC: UIPageViewController {
    
    weak var friendPageDelegate: FriendPageDelegate?
    let controllers = [FriendTableVC.instance(mode: .RECEIVE), FriendTableVC.instance(mode: .SENT)]
    
    static func instance() -> FriendPageVC {
        return FriendPageVC.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        setViewControllers([controllers[0]], direction: .forward, animated: true, completion: nil)
    }
    
    func scrollToIndex(index: Int) {
        if index == 0 {
            setViewControllers([controllers[0]], direction: .reverse, animated: true, completion: nil)
        } else {
            setViewControllers([controllers[1]], direction: .forward, animated: true, completion: nil)
        }
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
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let selectedIndex = abs(self.controllers.firstIndex(of: previousViewControllers.first as! FriendTableVC)! - 1)
            friendPageDelegate?.onSelectTap(index: selectedIndex)
        }
    }
}
