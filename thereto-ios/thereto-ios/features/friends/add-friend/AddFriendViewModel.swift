import Foundation
import RxSwift
import RxCocoa

class AddFriendViewModel {
    var people: BehaviorRelay<[Friend?]> = BehaviorRelay(value: [])
    var friends: [Friend?] = []
}
