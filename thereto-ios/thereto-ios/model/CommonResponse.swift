struct CommonResponse<T: Codable>: Codable {
    var data: T
    var error: String?
}
