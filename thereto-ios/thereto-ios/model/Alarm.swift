struct Alarm: Codable {
    var type: String
    var title: String?
    var message: String
    
    init(map: [String: Any]) {
        self.type = map["type"] as! String
        self.title =  map["title"] as? String
        self.message = map["message"] as! String
    }
    
    init(type: String) {
        self.type = type
        switch type {
        case "NEW_LETTER":
            self.title = "편지 도착"
            self.message = "친구에게 엽서가 도착했습니다!"
        case "NEW_REQUEST":
            self.title = "친구요청"
            self.message = "수락 시 엽서를 쓰고 받을 수 있으며 친구관리에서 친구삭제가 가능합니다."
        default:
            self.type = ""
            self.message = ""
            break
        }
    }
    
    func toDict() -> [String: Any] {
        return ["type": type,
                "title": title,
                "message": message]
    }
}
