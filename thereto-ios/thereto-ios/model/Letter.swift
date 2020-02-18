import Foundation

struct Letter {
    var from: User
    var to: Friend
    var location: Location
    var photo: String
    var message: String
    
    func toDict() -> [String: Any] {
        return ["from": from.toDict(), "to": to.toDict(), "location": location.toDict(),
                "photo": photo, "message": message]
    }
}
