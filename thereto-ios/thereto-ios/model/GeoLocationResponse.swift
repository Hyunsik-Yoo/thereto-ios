import Foundation

struct GeoLocationResponse: Codable {
    var errorMessage: String!
    var addresses: [Address]
}


struct Address: Codable {
    var x: String!
    var y: String!
    var roadAddress: String!
    var jibunAddress: String!
    var distance: Double!
}
