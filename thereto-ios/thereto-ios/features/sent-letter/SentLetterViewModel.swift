import RxSwift

struct SentLetterViewModel {
  var letters = BehaviorSubject<[Letter]>.init(value: [])
}
