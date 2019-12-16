import Foundation
import RxSwift

class ProfileViewModel {
    var userId: String = ""
    var social: String = ""
    var profileImageUrl: BehaviorSubject<String> = BehaviorSubject(value: "")
    var name: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    init() {
    }
}
