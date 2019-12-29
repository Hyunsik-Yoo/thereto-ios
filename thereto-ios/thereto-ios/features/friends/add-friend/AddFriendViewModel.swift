import Foundation
import RxSwift
import RxCocoa

class AddFriendViewModel {
    var people: BehaviorRelay<[User?]> = BehaviorRelay(value: [])
    var friends: [User?] = []
}
