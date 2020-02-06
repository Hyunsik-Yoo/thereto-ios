import Foundation
import RxSwift

struct FriendListViewModel {
    
    var friends = BehaviorSubject<[Friend]>.init(value: [])
}
