import Foundation
import RxSwift
import RxCocoa

class FriendDetailViewModel: BaseViewModel {
    
    let input = Input()
    let output = Output()
    var userService: UserServiceProtocol
    var userDefaults: UserDefaultsProtocol
    
    struct Input {
        let tapFavorite = PublishSubject<Void>()
        let tapDelete = PublishSubject<Void>()
        let tapWrite = PublishSubject<Void>()
    }
    
    struct Output {
        let enableFavorite = PublishRelay<Bool>()
        let popup = PublishRelay<Void>()
        let friend = PublishRelay<Friend>()
        let showLoading = PublishRelay<Bool>()
        let showAlerts = PublishRelay<(String, String)>()
        let goToWrite = PublishRelay<Friend>()
    }
    
    
    init(userService: UserServiceProtocol,
         userDefaults: UserDefaultsProtocol) {
        self.userService = userService
        self.userDefaults = userDefaults
        
        super.init()
        
        input.tapFavorite.withLatestFrom(Observable.combineLatest(output.friend, output.enableFavorite)).bind {[weak self] (friend, isFavorite) in
            guard let self = self else { return }
            self.userService.favoriteFriend(userId: self.userDefaults.getUserToken()!, friendId: friend.id, isFavorite: !isFavorite)
            self.output.enableFavorite.accept((!isFavorite))
        }.disposed(by: disposeBag)
        
        input.tapDelete.withLatestFrom(output.friend).bind { [weak self] (friend) in
            guard let self = self else { return }
            self.output.showLoading.accept(true)
            self.userService.deleteFriend(userId: self.userDefaults.getUserToken()!, friendId: friend.id) { (observable) in
                observable.subscribe(onNext: { (_) in
                    self.output.showLoading.accept(false)
                    self.output.popup.accept(())
                }, onError: { (error) in
                    self.output.showAlerts.accept(("친구 삭제 오류", error.localizedDescription))
                    self.output.showLoading.accept(false)
                }).disposed(by: self.disposeBag)
            }
        }.disposed(by: disposeBag)
        
        input.tapWrite.withLatestFrom(output.friend).bind(to: output.goToWrite)
            .disposed(by: disposeBag)
    }
    
    func fetchFriend(friendId: String) {
        self.output.showLoading.accept(true)
        userService.findFriend(userId: self.userDefaults.getUserToken()!, friendId: friendId) { [weak self] (friendObservable) in
            guard let self = self else { return }
            friendObservable.subscribe(onNext: { (friend) in
                self.output.friend.accept(friend)
                self.output.enableFavorite.accept(friend.favorite)
                self.output.showLoading.accept(false)
            }, onError: { (error) in
                if let error = error as? CommonError {
                    self.output.showAlerts.accept(("내 정보 조회 오류", error.description))
                } else {
                    self.output.showAlerts.accept(("내 정보 조회 오류", error.localizedDescription))
                }
                self.output.showLoading.accept(false)
            }).disposed(by: self.disposeBag)
        }
    }
}
