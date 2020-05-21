import Foundation

public enum State: String, Codable {
    case WAIT = "wait" // 수락 대기중
    case REQUEST_SENT = "request_sent" // 친구 요청 보냄
    case FRIEND = "friend"
    case NONE = "none"
}
