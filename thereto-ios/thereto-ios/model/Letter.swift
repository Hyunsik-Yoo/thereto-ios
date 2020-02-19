import Foundation

struct Letter {
    var from: User
    var to: Friend
    var location: Location
    var photo: String
    var message: String
    var createdAt: String
    
    init(map: [String: Any]) {
        self.from =  User.init(map: map["from"] as! [String: Any])
        self.to = Friend.init(map: map["to"] as! [String: Any])
        self.location = Location.init(map: map["location"] as! [String: Any])
        self.photo = map["photo"] as! String
        self.message = map["message"] as! String
        self.createdAt = map["createdAt"] as! String
    }
    
    init(from: User, to: Friend, location: Location, photo: String, message: String) {
        self.from = from
        self.to = to
        self.location = location
        self.photo = photo
        self.message = message
        self.createdAt = DateUtil.date2String(date: Date.init())
    }
    
    func toDict() -> [String: Any] {
        return ["from": from.toDict(), "to": to.toDict(), "location": location.toDict(),
                "photo": photo, "message": message, "createdAt": createdAt]
    }
}
