//
//  UserDefaultsUtil.swift
//  thereto-ios
//
//  Created by Hyunsik Yoo on 2019/12/28.
//  Copyright © 2019 Macgongmon. All rights reserved.
//

import Foundation

protocol UserDefaultsProtocol {
    func setNormalLaunch(isNormal: Bool)
    func isNormalLaunch() -> Bool
    func setUserToken(token: String)
    func getUserToken() -> String?
    func isTutorialFinished() -> Bool
    func setTutorialFinish()
    func clearUserToken()
    func setFCMToken(token: String)
    func getFCMToken() -> String?
    func enableLetterNoti(isEnable: Bool)
    func isEnableLetterNoti() -> Bool
}

struct UserDefaultsUtil: UserDefaultsProtocol {
    
    static let KEY_TOKEN = "KEY_TOKEN"
    static let KEY_TUTORIAL_CARD = "KEY_TUTORIAL_CARD"
    static let KEY_IS_NORMAL_LAUNCH = "KEY_IS_NORMAL_LAUNCH"
    static let KEY_FCM_TOKEN = "KEY_FC_TOKEN"
    static let KEY_NOTI_LETTER = "KEY_PUSH_LETTER"
    
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
    
    func setNormalLaunch(isNormal: Bool) {
        UserDefaults.standard.set(isNormal, forKey: UserDefaultsUtil.KEY_IS_NORMAL_LAUNCH)
    }
    
    func isNormalLaunch() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsUtil.KEY_IS_NORMAL_LAUNCH)
    }
    
    func setUserToken(token: String) {
        UserDefaults.standard.set(token, forKey: UserDefaultsUtil.KEY_TOKEN)
    }
    
    func getUserToken() -> String? {
        UserDefaults.standard.string(forKey: UserDefaultsUtil.KEY_TOKEN)
    }
    
    func isTutorialFinished() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsUtil.KEY_TUTORIAL_CARD)
    }
    
    func setTutorialFinish() {
        UserDefaults.standard.set(true, forKey: UserDefaultsUtil.KEY_TUTORIAL_CARD)
    }
    
    func clearUserToken() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsUtil.KEY_TOKEN)
    }
    
    func setFCMToken(token: String) {
        UserDefaults.standard.set(token, forKey: UserDefaultsUtil.KEY_FCM_TOKEN)
    }
    
    func getFCMToken() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsUtil.KEY_FCM_TOKEN)
    }
    
    func enableLetterNoti(isEnable: Bool) {
        UserDefaults.standard.set(isEnable, forKey: UserDefaultsUtil.KEY_NOTI_LETTER)
    }
    
    func isEnableLetterNoti() -> Bool {
        UserDefaults.standard.bool(forKey: UserDefaultsUtil.KEY_NOTI_LETTER)
    }
}
