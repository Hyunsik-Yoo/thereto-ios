struct HTTPUtils {
    static let url = "https://us-central1-there-to.cloudfunctions.net/"
    
    static func jsonHeader() -> [String: String] {
        return ["Accept": "application/json"]
    }
}
