import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .clear
        window?.rootViewController = SplashVC.instance()
        window?.makeKeyAndVisible()
        return true
    }
    
    func goToSignIn() {
        window?.rootViewController = SignInVC.instance()
        window?.makeKeyAndVisible()
    }
}

