//
//  UserDefaultsUtil.swift
//  thereto-ios
//
//  Created by Hyunsik Yoo on 2019/12/28.
//  Copyright © 2019 Macgongmon. All rights reserved.
//

import Foundation

struct UserDefaultsUtil {
    
    static let KEY_TOKEN = "KEY_TOKEN"
    static let KEY_TUTORIAL_CARD = "KEY_TUTORIAL_CARD"
    static let KEY_IS_NORMAL_LAUNCH = "KEY_IS_NORMAL_LAUNCH"
    
    static func setUserToken(token: String) {
        UserDefaults.standard.set(token, forKey: UserDefaultsUtil.KEY_TOKEN)
    }
    
    static func getUserToken() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsUtil.KEY_TOKEN)
    }
    
    static func clearUserToken() {
        UserDefaults.standard.removeObject(forKey: KEY_TOKEN)
    }
    
    static func setTutorialFinish() {
        UserDefaults.standard.set(true, forKey: UserDefaultsUtil.KEY_TUTORIAL_CARD)
    }
    
    static func isTutorialFinished() -> Bool {
        return UserDefaults.standard.bool(forKey: KEY_TUTORIAL_CARD)
    }
    
    static func isNormalLaunch() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsUtil.KEY_IS_NORMAL_LAUNCH)
    }
    
    static func setNormalLaunch(isNormal: Bool) {
        UserDefaults.standard.set(isNormal, forKey: UserDefaultsUtil.KEY_IS_NORMAL_LAUNCH)
    }
}
