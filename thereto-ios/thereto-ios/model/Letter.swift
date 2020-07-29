import Foundation

struct Letter: Equatable {
    
    var id: String
    var from: User
    var to: Friend
    var location: Location
    var photo: String
    var message: String
    var createdAt: String
    var timestamp: Double
    var isRead: Bool = false
    
    init(map: [String: Any]) {
        self.id = map["id"] as! String
        self.from =  User.init(map: map["from"] as! [String: Any])
        self.to = Friend.init(map: map["to"] as! [String: Any])
        self.location = Location.init(map: map["location"] as! [String: Any])
        self.photo = map["photo"] as! String
        self.message = map["message"] as! String
        self.createdAt = map["createdAt"] as! String
        self.isRead = map["isRead"] as! Bool
        self.timestamp = map["timestamp"] as! Double
    }
    
    init(from: User, to: Friend, location: Location, photo: String, message: String, createdAt: String? = nil, timestamp: Double? = nil) {
        self.id = ""
        self.from = from
        self.to = to
        self.location = location
        self.photo = photo
        self.message = message
        if let createdAt = createdAt {
            self.createdAt = createdAt
        } else {
            self.createdAt = DateUtil.date2String(date: Date.init())
        }
        if let timestamp = timestamp {
            self.timestamp = timestamp
        } else {
            self.timestamp = NSDate().timeIntervalSince1970
        }
        self.isRead = false
    }
    
    
    func toDict() -> [String: Any] {
        return ["from": from.toDict(), "to": to.toDict(), "location": location.toDict(),
                "photo": photo, "message": message, "createdAt": createdAt, "isRead": isRead, "timestamp": timestamp]
    }
    
    static func createTutorialCard(user: User) -> Letter {
        let thereto = User.init(nickname: "thereto", social: "facebook", id: "tutorial", profileURL: "")
        let me = Friend.init(nickname: user.nickname, social: user.getSocial(), id: user.id, profileURL: user.profileURL!)
        let location = Location.init(name: "데얼투", addr: "서울 강남구 삼성로85길 26", latitude: 37.504884, longitude: 127.055053)
        var letter = Letter.init(from: thereto, to: me, location: location, photo: "https://firebasestorage.googleapis.com/v0/b/there-to.appspot.com/o/img%402x.png?alt=media&token=cdab7112-0702-490f-8d82-eac91213f044", message: "\(user.nickname)님, thereto에 오신것을 환영합니다. 특별한 장소에서 친구에게특별한 엽서를 남겨보세요.\n친구는 해당 장소에 도착해야지만 엽서를 볼 수 있습니다.\n\n감사합니다.", createdAt: user.createdAt)
        
        letter.id = "tutorial"
        
        return letter
    }
    
    static func == (lhs: Letter, rhs: Letter) -> Bool {
        return lhs.id == rhs.id
    }
}
