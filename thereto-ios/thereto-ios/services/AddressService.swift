import Alamofire

struct AddressService {
    
    static func searchAddress(keyword: String, page: Int, completion: @escaping (([Juso]) -> Void)) {
        let urlString = "http://www.juso.go.kr/addrlink/addrLinkApi.do"
        let parameters: [String: Any] = ["confmKey": "U01TX0FVVEgyMDIwMDIxMjE1MjkxOTEwOTQ2MTU=",
                                         "currentPage": page, "keyword": keyword, "resultType": "json"]
        
        Alamofire.request(urlString, method: .get, parameters: parameters).responseJSON { (response) in
            
            let decoder = JSONDecoder()
            
            if let data = response.data,
                let jusoResponse = try? decoder.decode(JusoResponse.self, from: data) {
                
                completion(jusoResponse.results.juso)
            } else {
                AlertUtil.show("error", message: "주소 가져오기는 도중 에러가 발생했습니다.\n잠시후 다시 시도해주세요.")
            }
        }
    }
}
