import Foundation
import RxSwift

class FriendDetailViewModel: BaseViewModel {
    
    var input: Input
    var output: Output
    var userService: UserServiceProtocol
    var userDefaults: UserDefaultsProtocol
    
    struct Input {
        var tapFavorite: AnyObserver<Void>
        var tapDelete: AnyObserver<Void>
        var tapWrite: AnyObserver<Void>
    }
    
    struct Output {
        var enableFavorite: Observable<Bool>
        var friend: Observable<Friend>
        var popup: Observable<Void>
        var showLoading: Observable<Bool>
        var showAlerts: Observable<(String, String)>
    }
    
    let tapFavoritePublisher = PublishSubject<Void>()
    let tapDeletePublisher = PublishSubject<Void>()
    let tapWritePublisher = PublishSubject<Void>()
    
    let enableFavoritePublisher = PublishSubject<Bool>()
    let friendPublisher = PublishSubject<Friend>()
    let popupPublisher = PublishSubject<Void>()
    let showLoadingPublisher = PublishSubject<Bool>()
    let showAlertsPublisher = PublishSubject<(String, String)>()
    
    init(userService: UserServiceProtocol,
         userDefaults: UserDefaultsProtocol) {
        self.userService = userService
        self.userDefaults = userDefaults
        
        input = Input(tapFavorite: tapFavoritePublisher.asObserver(),
                      tapDelete: tapDeletePublisher.asObserver(),
                      tapWrite: tapWritePublisher.asObserver())
        output = Output(enableFavorite: enableFavoritePublisher,
                        friend: friendPublisher,
                        popup: popupPublisher,
                        showLoading: showLoadingPublisher,
                        showAlerts: showAlertsPublisher)
        super.init()
        
        tapFavoritePublisher.withLatestFrom(Observable.combineLatest(friendPublisher, enableFavoritePublisher)).bind {[weak self] (friend, isFavorite) in
            guard let self = self else { return }
            self.userService.favoriteFriend(userId: self.userDefaults.getUserToken(), friendId: friend.id, isFavorite: !isFavorite)
            self.enableFavoritePublisher.onNext(!isFavorite)
        }.disposed(by: disposeBag)
        
        tapDeletePublisher.withLatestFrom(friendPublisher).bind { [weak self] (friend) in
            guard let self = self else { return }
            self.showLoadingPublisher.onNext(true)
            self.userService.deleteFriend(userId: self.userDefaults.getUserToken(), friendId: friend.id) { (observable) in
                observable.subscribe(onNext: { (_) in
                    self.showLoadingPublisher.onNext(false)
                    self.popupPublisher.onNext(())
                }, onError: { (error) in
                    self.showAlertsPublisher.onNext(("친구 삭제 오류", error.localizedDescription))
                    self.showLoadingPublisher.onNext(false)
                }).disposed(by: self.disposeBag)
            }
        }.disposed(by: disposeBag)
    }
    
    func fetchFriend(friendId: String) {
        self.showLoadingPublisher.onNext(true)
        userService.findFriend(userId: self.userDefaults.getUserToken(), friendId: friendId) { [weak self] (friendObservable) in
            guard let self = self else { return }
            friendObservable.subscribe(onNext: { (friend) in
                self.friendPublisher.onNext(friend)
                self.enableFavoritePublisher.onNext(friend.favorite)
                self.showLoadingPublisher.onNext(false)
            }, onError: { (error) in
                if let error = error as? CommonError {
                    self.showAlertsPublisher.onNext(("내 정보 조회 오류", error.description))
                } else {
                    self.showAlertsPublisher.onNext(("내 정보 조회 오류", error.localizedDescription))
                }
                self.showLoadingPublisher.onNext(false)
            }).disposed(by: self.disposeBag)
        }
    }
}
