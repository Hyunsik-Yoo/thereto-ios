import Foundation
import RxSwift

struct FriendListViewModel {
    
    var friends = BehaviorSubject<[User]>.init(value: [])
}
