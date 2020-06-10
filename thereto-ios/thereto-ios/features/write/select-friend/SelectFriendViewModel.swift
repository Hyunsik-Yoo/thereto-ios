import Foundation
import RxSwift

struct SelectFriendViewModel {
    var friends = BehaviorSubject<[Friend]>.init(value: [])
    var totalFriends: [Friend] = []
}
