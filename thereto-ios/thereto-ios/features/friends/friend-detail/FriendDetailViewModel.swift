import Foundation
import RxSwift

struct FriendDetailViewModel {
    var friend = BehaviorSubject<User?>.init(value: nil)
}
