import Foundation
import RxSwift

struct FriendDetailViewModel {
    var friend = BehaviorSubject<Friend?>.init(value: nil)
}
