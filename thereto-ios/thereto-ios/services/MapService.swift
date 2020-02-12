import Foundation
import Alamofire

struct MapService {
    
    static func getAddressFromLocation(latitude: Double, longitude: Double, completion: @escaping ((String) -> Void)) {
        let urlString = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc"
        let headers: [String: String] = ["X-NCP-APIGW-API-KEY-ID": "b7agu1h5c2",
                                         "X-NCP-APIGW-API-KEY": "XXQown7wQLSB7oa5aHR21nJLyEHF2RK9kYe8Zcmt"]
        let parameters: [String: Any] = ["coords": "\(longitude),\(latitude)", "output": "json"]
        
        Alamofire.request(urlString, method: .get, parameters: parameters, headers: headers).responseJSON { (response) in
            let decoder = JSONDecoder()
            
            if let data = response.data,
                let geoLocation = try? decoder.decode(NaverResponse.self, from: data) {
                
                if !geoLocation.results.isEmpty {
                    let address = "\(geoLocation.results[0].region.area1.name!) \(geoLocation.results[0].region.area2.name!) \(geoLocation.results[0].region.area3.name!) \(geoLocation.results[0].region.area4.name!)"
                    completion(address)
                }
            } else {
                AlertUtil.show("error", message: "주소 가져오기는 도중 에러가 발생했습니다.\n잠시후 다시 시도해주세요.")
            }
            
        }
    }
}
