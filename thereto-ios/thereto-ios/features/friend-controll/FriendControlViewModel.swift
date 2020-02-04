import RxSwift

struct FriendControlViewModel {
    var friends = BehaviorSubject<[User]>.init(value: [])
}
