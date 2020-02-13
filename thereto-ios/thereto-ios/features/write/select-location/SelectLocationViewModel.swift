import Foundation
import RxSwift
import NMapsMap

struct SelectLocationViewModel {
    var address = BehaviorSubject<String>.init(value: "")
    var marker = BehaviorSubject<NMFMarker>.init(value: NMFMarker.init())
}
