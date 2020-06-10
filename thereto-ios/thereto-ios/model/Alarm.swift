struct Alarm: Codable {
    var type: AlarmType
    var title: String?
    var message: String
    
    init(map: [String: Any]) {
        self.type = AlarmType(rawValue: map["type"] as! String)!
        self.title =  map["title"] as? String
        self.message = map["message"] as! String
    }
    
    init(type: AlarmType) {
        self.type = type
        switch type {
        case .NEW_LETTER:
            self.title = "편지 도착"
            self.message = "친구에게 엽서가 도착했습니다!\n수신함에서 확인할 수 있습니다."
        case .NEW_REQUEST:
            self.title = "친구요청 도착"
            self.message = "친구관리 > 친구 요청 관리 에서 확인할 수 있습니다."
        default:
            self.type = .ERROR
            self.message = ""
            break
        }
    }
    
    func toDict() -> [String: Any] {
        return ["type": type.rawValue,
                "title": title,
                "message": message]
    }
}

enum AlarmType: String, Codable {
    case NEW_LETTER = "NEW_LETTER"
    case NEW_REQUEST = "NEW_REQUEST"
    case ERROR = "ERROR"
}
