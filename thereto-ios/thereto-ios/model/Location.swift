import Foundation

struct Location {
    var addr: String!
    var name: String!
    var latitude: Double!
    var longitude: Double!
    
    
    init(name: String, addr: String, latitude: Double, longitude: Double) {
        self.name = name
        self.addr = addr
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func toDict() -> [String: Any] {
        return ["addr": addr!, "name": name!, "latitude": latitude!, "longitude": longitude!]
    }
}
