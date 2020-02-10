import RxSwift

struct SetupViewModel {
    var user = BehaviorSubject<User?>.init(value: nil)
}
