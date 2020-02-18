import RxSwift

struct FindAddressViewModel {
    var jusoList = BehaviorSubject<[Juso]>.init(value: [])
}
