import Foundation

struct User: Codable {
    var nickname: String
    var social: SocialType
    var profileURL: String?
    var receivedCount = 0
    var sentCount = 0
    var id: String
    
    init(nickname: String,social: String, id: String, profileURL: String) {
        self.nickname = nickname
        self.social = SocialType(rawValue: social)!
        self.profileURL = profileURL
        self.id = "\(social)\(id)"
    }
    
    init(map: [String: Any]) {
        self.nickname = map["nickname"] as! String
        self.social = SocialType(rawValue: map["social"] as! String)!
        self.profileURL = map["profileURL"] as? String
        self.receivedCount = map["receivedCount"] as! Int
        self.sentCount = map["sentCount"] as! Int
        self.id = map["id"] as! String
    }
    
    func toDict() -> [String: Any] {
        return ["nickname": nickname, "social": social.rawValue,
                "id": id, "profileURL": profileURL!, "receivedCount": receivedCount, "sentCount": sentCount]
    }
    
    func getSocial() -> String {
        return social.rawValue
    }
}
