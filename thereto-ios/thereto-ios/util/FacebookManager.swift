import FBSDKCoreKit
import RxSwift
import RxCocoa


protocol FaceboookManagerProtocol {
    func getFBProfile(id: String, completion: @escaping (Observable<(name: String, profileURL: String?)>) -> Void)
}


struct FacebookManager: FaceboookManagerProtocol {
    
    func getFBProfile(id: String, completion: @escaping (Observable<(name: String, profileURL: String?)>) -> Void) {
        let connection = GraphRequestConnection()
        
        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "email, name, picture.type(large)"])) { (httpResponse, result, error) in
            if let error = error {
                completion(Observable.error(error))
            } else {
                
                if let result = result as? NSDictionary {
                    let name: String = result["name"] as! String
                    var profileURL: String? = nil
                    
                    if let picture = result["picture"] as? [String: Any],
                        let data = picture["data"] as? [String: Any],
                        let url = data["url"] as? String {
                        profileURL = url
                    }
                    
                    completion(Observable.just((name, profileURL)))
                }
            }
        }
        connection.start()
    }
}
