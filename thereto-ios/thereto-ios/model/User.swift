import Foundation

struct User {
    var name: String
    var nickname: String
    var social: SocialType
    var socialId: String
    var profileURL: String?
    var requestState: State
    var createdAt: String?
    
    init(nickname: String, name: String, social: String, id: String, profileURL: String) {
        self.nickname = nickname
        self.name = name
        self.social = SocialType(rawValue: social)!
        self.socialId = id
        self.profileURL = profileURL
        self.requestState = .NONE
        self.createdAt = DateUtil.date2String(date: Date())
    }
    
    init(map: [String: Any]) {
        self.nickname = map["nickname"] as! String
        self.name = map["name"] as! String
        self.social = SocialType(rawValue: map["social"] as! String)!
        self.socialId = map["social_id"] as! String
        self.profileURL = map["profile_url"] as? String
        self.requestState = State(rawValue: map["request_state"] as! String)!
        self.createdAt = map["createdAt"] as? String
    }
    
    func toDict() -> [String: Any] {
        return ["name": name, "nickname": nickname, "social": social.rawValue,
                "social_id": socialId, "profile_url": profileURL, "request_state": requestState.rawValue, "createdAt": createdAt]
    }
    
    func getSocial() -> String {
        return social.rawValue
    }
    
    enum SocialType: String {
        case FACEBOOK = "facebook"
    }
    
    enum State: String {
        case WAIT = "wait" // 수락 대기중
        case REQUEST_SENT = "request_sent" // 친구 요청 보냄
        case FRIEND = "friend"
        case NONE = "none"
    }
}
