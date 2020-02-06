import RxSwift

struct FriendControlViewModel {
    var friends = BehaviorSubject<[Friend]>.init(value: [])
}
