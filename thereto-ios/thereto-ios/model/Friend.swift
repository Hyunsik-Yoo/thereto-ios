import Foundation

struct Friend {
    var nickname: String
    var social: SocialType
    var profileURL: String?
    var requestState: State
    var createdAt: String?
    var receivedCount = 0
    var sentCount = 0
    var id: String
    var favorite: Bool = false
    
    init(nickname: String, social: String, id: String, profileURL: String) {
        self.nickname = nickname
        self.social = SocialType(rawValue: social)!
        self.profileURL = profileURL
        self.requestState = .NONE
        self.createdAt = DateUtil.date2String(date: Date())
        self.id = "\(social)\(id)"
    }
    
    init(map: [String: Any]) {
        self.nickname = map["nickname"] as! String
        self.social = SocialType(rawValue: map["social"] as! String)!
        self.profileURL = map["profile_url"] as? String
        self.requestState = State(rawValue: map["request_state"] as! String)!
        self.createdAt = map["createdAt"] as? String
        self.receivedCount = map["receivedCount"] as! Int
        self.sentCount = map["sentCount"] as! Int
        self.id = map["id"] as! String
        self.favorite = map["favorite"] as! Bool
    }
    
    init(user: User) {
        self.nickname = user.nickname
        self.social = user.social
        self.profileURL = user.profileURL
        self.requestState = .NONE
        self.createdAt = DateUtil.date2String(date: Date())
        self.id = user.id
    }
    
    func toDict() -> [String: Any] {
        return ["nickname": nickname, "social": social.rawValue,
                "profile_url": profileURL, "request_state": requestState.rawValue, "createdAt": createdAt,
                "receivedCount": receivedCount, "sentCount": sentCount, "id": id, "favorite": favorite]
    }
    
    func getSocial() -> String {
        return social.rawValue
    }
}
