import Foundation
import RxSwift

class FriendListViewModel: BaseViewModel {
    
    var output: Output
    var userService: UserServiceProtocol
    var userDefaults: UserDefaultsUtil
    
    struct Output {
        var friends: Observable<(User, [Friend])>
        var showAlerts: Observable<(String, String)>
        var showLoading: Observable<Bool>
    }
    
    let friendsPublisher = PublishSubject<(User, [Friend])>()
    let showAlertPublisher = PublishSubject<(String, String)>()
    let showLoadingPublisher = PublishSubject<Bool>()
    
    
    init(userService: UserServiceProtocol,
         userDefaults: UserDefaultsUtil) {
        self.userService = userService
        self.userDefaults = userDefaults
        
        output = Output(friends: friendsPublisher,
                        showAlerts: showAlertPublisher,
                        showLoading: showLoadingPublisher)
    }
    
    func fetchFriends() {
        showLoadingPublisher.onNext(true)
        userService.getUserInfo(token: userDefaults.getUserToken()!).subscribe(onNext: { [weak self] (user) in
            guard let self = self else { return }
            self.userService.getFriends(id: self.userDefaults.getUserToken()!) { (friendsObservable) in
                friendsObservable.subscribe(onNext: { (friends) in
                    let filterFriends = friends.filter { $0.requestState == .FRIEND }.sorted { (friend1, friend2) -> Bool in
                        friend1.favorite && !friend2.favorite
                    }
                    self.friendsPublisher.onNext((user, filterFriends))
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
            }, onError: { [weak self] (error) in
                guard let self = self else { return }
                if let error = error as? CommonError {
                    self.showAlertPublisher.onNext(("내 정보 조회 오류", error.description))
                } else {
                    self.showAlertPublisher.onNext(("내 정보 조회 오류", error.localizedDescription))
                }
                self.showLoadingPublisher.onNext(false)
        }).disposed(by: disposeBag)
    }
}
