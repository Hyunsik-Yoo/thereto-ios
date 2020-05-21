import Foundation
import RxSwift
import RxCocoa

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
}

class BaseViewModel: NSObject {
    let disposeBag = DisposeBag()
}
