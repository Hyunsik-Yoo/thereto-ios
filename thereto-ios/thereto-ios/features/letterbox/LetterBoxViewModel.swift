import RxSwift

struct LetterBoxViewModel {
    var letters = BehaviorSubject<[Letter]>.init(value: [])
}
