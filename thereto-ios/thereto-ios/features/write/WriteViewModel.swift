import RxSwift

struct WriteViewModel {
    var mainImg = BehaviorSubject<UIImage>.init(value: UIImage.init())
    var location = BehaviorSubject<Location?>.init(value: nil)
    var friend = BehaviorSubject<Friend?>.init(value: nil)
}
