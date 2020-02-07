import RxSwift

struct FindFriendViewModel {
    var friends = BehaviorSubject<[Friend]>.init(value: [])
    var totalFriends: [Friend] = []
}
