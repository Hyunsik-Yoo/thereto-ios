import Foundation
import RxSwift

struct SelectLocationViewModel {
    var address = BehaviorSubject<String>.init(value: "")
}
