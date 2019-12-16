import Foundation

struct User {
    var name: String
    var nickname: String
    var social: SocialType
    var id: String
    var profileURL: String
    
    init(nickname: String, name: String, social: String, id: String, profileURL: String) {
        self.nickname = nickname
        self.name = name
        self.social = SocialType(rawValue: social)!
        self.id = id
        self.profileURL = profileURL
    }
    
    func toDict() -> [String: Any] {
        return ["name": name, "nickname": nickname, "social": social.rawValue,
                "id": id, "profile_url": profileURL]
    }
    
    enum SocialType: String {
        case FACEBOOK = "facebook"
    }
}
