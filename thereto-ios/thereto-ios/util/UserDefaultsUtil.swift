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
    
    static func setUserToken(token: String) {
        UserDefaults.standard.set(token, forKey: UserDefaultsUtil.KEY_TOKEN)
    }
    
    static func getUserToken() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsUtil.KEY_TOKEN)
    }
    
    static func clearUserToken() {
        UserDefaults.standard.removeObject(forKey: KEY_TOKEN)
    }
}
