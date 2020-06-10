import RxSwift

struct LetterSearchViewModel {
    var letters = BehaviorSubject<[Letter]>.init(value: [])
}
