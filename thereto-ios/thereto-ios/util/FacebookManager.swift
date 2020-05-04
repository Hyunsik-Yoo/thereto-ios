import FBSDKCoreKit
import RxSwift
import RxCocoa


protocol FaceboookManagerProtocol {
    func getFBProfile(id: String, completion: @escaping (Observable<(name: String, fbId: String)>) -> Void)
}


struct FacebookManager: FaceboookManagerProtocol {
    
    func getFBProfile(id: String, completion: @escaping (Observable<(name: String, fbId: String)>) -> Void) {
        let connection = GraphRequestConnection()
        
        connection.add(GraphRequest(graphPath: "/me")) { (httpResponse, result, error) in
            if let error = error {
                completion(Observable.error(error))
            } else {
                
                if let result = result as? [String:String],
                    let name: String = result["name"],
                    let fbId: String = result["id"] {
                    completion(Observable.just((name, fbId)))
                }
            }
        }
        connection.start()
    }
}
