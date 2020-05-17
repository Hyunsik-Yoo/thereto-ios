import Foundation
import RxSwift

class FriendListViewModel: BaseViewModel {
    
    var output: Output
    var userService: UserServiceProtocol
    var userDefaults: UserDefaultsProtocol
    
    struct Output {
        var friends: Observable<(User, [Friend])>
        var showAlerts: Observable<(String, String)>
        var showLoading: Observable<Bool>
    }
    
    let friendsPublisher = PublishSubject<(User, [Friend])>()
    let showAlertPublisher = PublishSubject<(String, String)>()
    let showLoadingPublisher = PublishSubject<Bool>()
    
    
    init(userService: UserServiceProtocol,
         userDefaults: UserDefaultsProtocol) {
        self.userService = userService
        self.userDefaults = userDefaults
        
        output = Output(friends: friendsPublisher,
                        showAlerts: showAlertPublisher,
                        showLoading: showLoadingPublisher)
    }
    
    func fetchFriends() {
        self.showLoadingPublisher.onNext(true)
        userService.getUserInfo(token: userDefaults.getUserToken()) { [weak self] (userObservable) in
            guard let self = self else { return }
            userObservable.subscribe(onNext: { (user) in
                self.userService.getFriends(id: self.userDefaults.getUserToken()) { (friendsObservable) in
                    friendsObservable.subscribe(onNext: { (friends) in
                        self.friendsPublisher.onNext((user, friends))
                        self.showLoadingPublisher.onNext(false)
                    }, onError: { (error) in
                        if let error = error as? CommonError {
                            self.showAlertPublisher.onNext(("친구 조회 오류", error.description))
                        } else {
                            self.showAlertPublisher.onNext(("친구 조회 오류", error.localizedDescription))
                        }
                        self.showLoadingPublisher.onNext(false)
                    }).disposed(by: self.disposeBag)
                }
            }, onError: { (error) in
                if let error = error as? CommonError {
                    self.showAlertPublisher.onNext(("내 정보 조회 오류", error.description))
                } else {
                    self.showAlertPublisher.onNext(("내 정보 조회 오류", error.localizedDescription))
                }
                self.showLoadingPublisher.onNext(false)
            }).disposed(by: self.disposeBag)
        }
        
    }
}
