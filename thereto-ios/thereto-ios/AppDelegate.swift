import UIKit
import Firebase
import FBSDKCoreKit
import AlamofireNetworkActivityLogger
import SwiftyBeaver
import FirebaseMessaging

typealias Log = SwiftyBeaver

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize firebase
        FirebaseApp.configure()
        
        // Initialize facebook
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Initialize AlmofireNetworkActivityLogger
        NetworkActivityLogger.shared.startLogging()
        NetworkActivityLogger.shared.level = .debug
        
        initilizeSwiftyBeaver()
        initilizeFCM(application: application)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.themeColor
        window?.rootViewController = SplashVC.instance()
        window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = ApplicationDelegate.shared.application(app, open: url, options: options)
        
        return handled
    }
    
    func goToSignIn() {
        window?.rootViewController = SignInVC.instance()
        window?.makeKeyAndVisible()
    }
    
    func goToLetterbox() {
        window?.rootViewController = LetterBoxVC.instance()
        window?.makeKeyAndVisible()
    }
    
    func goToFriend() {
        window?.rootViewController = FriendListVC.instance()
        window?.makeKeyAndVisible()
    }
    
    func goToSetup() {
        window?.rootViewController = SetupVC.instance()
        window?.makeKeyAndVisible()
    }
    
    func goToMain() {
        window?.rootViewController = MainVC.instance()
        window?.makeKeyAndVisible()
    }
    
    private func initilizeSwiftyBeaver() {
        // add log destinations. at least one is needed!
        let console = ConsoleDestination()  // log to Xcode Console
        let cloud = SBPlatformDestination(appID: "bJPO03",
                                          appSecret: "4f8tnYymJhvze9hvJc50irhwzmnlablw",
                                          encryptionKey: "oltisgoyhfZvnqxQo7xvjgbupcKxdqwy")
        cloud.minLevel = .debug
        
        console.format = "$DHH:mm:ss$d $N.$F():$l $L: $M"
        // or use this for JSON output: console.format = "$J"

        // add the destinations to SwiftyBeaver
        Log.addDestination(console)
        Log.addDestination(cloud)
    }
    
    private func initilizeFCM(application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions,
                                                                completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        Log.debug("fcmToken: \(fcmToken)")
    }
}
