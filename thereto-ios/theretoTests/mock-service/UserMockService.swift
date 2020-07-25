import RxSwift
import RxCocoa

@testable import thereto

struct UserMockService: UserServiceProtocol {
    func signUp(user: User) -> Observable<User> {
        if user.nickname == "error" {
            let error = CommonError(desc: "error")
            
            return Observable.error(error)
        } else {
            return Observable.just(user)
        }
    }
    
    func isSessionExisted() -> Bool {
        return true
    }
    
    func validateUser(token: String, completion: @escaping (Bool) -> Void) {
        
    }
    
    func validateUser(token: String) -> Observable<Bool> {
        if token.isEmpty {
            return Observable.just(false)
        } else {
            return Observable.just(true)
        }
    }
    
    func getUserInfo(token: String, completion: @escaping (Observable<User>) -> Void) {
        
    }
    
    func findUser(nickname: String, completion: @escaping (Observable<[User]>) -> Void) {
        
    }
    
    func getFriends(id: String, completion: @escaping (Observable<[Friend]>) -> Void) {
        
    }
    
    func requestFriend(id: String, friend: Friend, withAlarm: Bool, completion: @escaping (Observable<Void>) -> Void) {
        
    }
    
    func requestFriend(user: Friend, friend: Friend, completion: @escaping (Observable<Void>) -> Void) {
        
    }
    
    func favoriteFriend(userId: String, friendId: String, isFavorite: Bool) {
        
    }
    
    func findFriend(userId: String, friendId: String, completion: @escaping ((Observable<Friend>) -> Void)) {
        
    }
    
    func deleteFriend(userId: String, friendId: String, completion: @escaping ((Observable<Void>) -> Void)) {
        
    }
    
    func fetchAlarm(userId: String, completion: @escaping ((Observable<Alarm>) -> Void)) {
        
    }
    
    func insertAlarm(userId: String, type: AlarmType) {
        
    }
    
    func updateProfileURL(userId: String, image: UIImage, completion: @escaping ((Observable<String>) -> Void)) {
        
    }
    
    func updateFCMToken(userId: String, fcmToken: String) {
        
    }
    
    func deleteFCMToken(userId: String) {
        
    }
    
    
}
