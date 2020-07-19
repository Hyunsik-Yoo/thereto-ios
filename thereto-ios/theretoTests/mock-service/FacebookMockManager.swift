import RxSwift
import RxCocoa

@testable import thereto


struct FacebookMockManager: FaceboookManagerProtocol {
    func getFBProfile(id: String) -> Observable<(name: String, profileURL: String?)> {
        if id == "error" {
            let error = CommonError(desc: "error")
            
            return Observable.error(error)
        } else {
            return Observable.just(("name", "url"))
        }
    }
}
