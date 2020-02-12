import Foundation

struct Juso: Codable {
    var roadAddr: String!
    var jibunAddr: String!
    var rnMgtSn: String! // 도로명 코드
    var admCd: String! // 행정구역 코드
    var udrtYn: String! // 지하여부
    var buldMnnm: String! // 건물 본번
    var buldSlno: String! // 건물 부번
}
