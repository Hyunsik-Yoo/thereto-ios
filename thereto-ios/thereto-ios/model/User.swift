import Foundation

struct User: Codable {
    var name: String
    var nickname: String
    var social: SocialType
    var profileURL: String?
    var receivedCount = 0
    var sentCount = 0
    var id: String
    
    init(nickname: String, name: String, social: String, id: String, profileURL: String) {
        self.nickname = nickname
        self.name = name
        self.social = SocialType(rawValue: social)!
        self.profileURL = profileURL
        self.id = "\(social)\(id)"
    }
    
    init(map: [String: Any]) {
        self.nickname = map["nickname"] as! String
        self.name = map["name"] as! String
        self.social = SocialType(rawValue: map["social"] as! String)!
        self.profileURL = map["profile_url"] as? String
        self.receivedCount = map["receive_count"] as! Int
        self.sentCount = map["sent_count"] as! Int
        self.id = map["id"] as! String
    }
    
    func toDict() -> [String: Any] {
        return ["name": name, "nickname": nickname, "social": social.rawValue,
                "id": id, "profile_url": profileURL!, "receive_count": receivedCount, "sent_count": sentCount]
    }
    
    func getSocial() -> String {
        return social.rawValue
    }
}
