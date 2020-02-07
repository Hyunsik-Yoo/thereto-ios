import Foundation
import RxSwift

struct ProfileViewModel {
    var profileImageUrl: BehaviorSubject<String> = BehaviorSubject(value: "")
    var name: BehaviorSubject<String> = BehaviorSubject(value: "")
}
