import Foundation

struct User {
    var name: String
    var nickname: String
    var social: SocialType
    var socialId: String
    var profileURL: String
    
    init(nickname: String, name: String, social: String, id: String, profileURL: String) {
        self.nickname = nickname
        self.name = name
        self.social = SocialType(rawValue: social)!
        self.socialId = id
        self.profileURL = profileURL
    }
    
    init(map: [String: Any]) {
        self.nickname = map["nickname"] as! String
        self.name = map["name"] as! String
        self.social = SocialType(rawValue: map["social"] as! String)!
        self.socialId = map["social_id"] as! String
        self.profileURL = map["profile_url"] as! String
    }
    
    func toDict() -> [String: Any] {
        return ["name": name, "nickname": nickname, "social": social.rawValue,
                "social_id": socialId, "profile_url": profileURL]
    }
    
    func getSocial() -> String {
        return social.rawValue
    }
    
    enum SocialType: String {
        case FACEBOOK = "facebook"
    }
}
