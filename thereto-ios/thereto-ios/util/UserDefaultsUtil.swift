import Foundation

struct UserDefaultsUtil {
    static let KEY_TOKEN = "KEY_TOKEN"
    static let KEY_TUTORIAL_CARD = "KEY_TUTORIAL_CARD"
    static let KEY_IS_NORMAL_LAUNCH = "KEY_IS_NORMAL_LAUNCH"
    static let KEY_FCM_TOKEN = "KEY_FC_TOKEN"
    static let KEY_NOTI_LETTER = "KEY_PUSH_LETTER"
    
    let instance: UserDefaults
    
    init(name: String? = nil) {
        if let name = name {
            UserDefaults().removePersistentDomain(forName: name)
            instance = UserDefaults(suiteName: name)!
        } else {
            instance = UserDefaults.standard
        }
    }
    
    func setUserToken(token: String) {
        instance.set(token, forKey: UserDefaultsUtil.KEY_TOKEN)
    }
    
    func getUserToken() -> String? {
        return instance.string(forKey: UserDefaultsUtil.KEY_TOKEN)
    }
    
    func clearUserToken() {
        instance.removeObject(forKey: UserDefaultsUtil.KEY_TOKEN)
    }
    
    func setTutorialFinish() {
        instance.set(true, forKey: UserDefaultsUtil.KEY_TUTORIAL_CARD)
    }
    
    func isTutorialFinished() -> Bool {
        return instance.bool(forKey: UserDefaultsUtil.KEY_TUTORIAL_CARD)
    }
    
    func isNormalLaunch() -> Bool {
        return instance.bool(forKey: UserDefaultsUtil.KEY_IS_NORMAL_LAUNCH)
    }
    
    func setNormalLaunch(isNormal: Bool) {
        instance.set(isNormal, forKey: UserDefaultsUtil.KEY_IS_NORMAL_LAUNCH)
    }
    
    func enableLetterNoti(isEnable: Bool) {
        instance.set(isEnable, forKey: UserDefaultsUtil.KEY_NOTI_LETTER)
    }
    
    func isEnableLetterNoti() -> Bool {
        instance.bool(forKey: UserDefaultsUtil.KEY_NOTI_LETTER)
    }
    
    func setFCMToken(token: String) {
        UserDefaults.standard.set(token, forKey: UserDefaultsUtil.KEY_FCM_TOKEN)
    }
    
    func getFCMToken() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsUtil.KEY_FCM_TOKEN)
    }
}
