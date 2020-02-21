import RxSwift

struct WriteViewModel {
    var mainImg = BehaviorSubject<UIImage?>.init(value: nil)
    var location = BehaviorSubject<Location?>.init(value: nil)
    var friend = BehaviorSubject<Friend?>.init(value: nil)
}
