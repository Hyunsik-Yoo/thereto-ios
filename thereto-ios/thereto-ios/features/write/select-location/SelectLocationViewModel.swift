import Foundation
import RxSwift
import NMapsMap

struct SelectLocationViewModel {
    var address = BehaviorSubject<String>.init(value: "")
    var marker = BehaviorSubject<NMFMarker>.init(value: NMFMarker.init())
    var myLocation = BehaviorSubject<NMFMarker>.init(value: NMFMarker.init())
    var myCircle = BehaviorSubject<NMFCircleOverlay?>.init(value: nil)
}
