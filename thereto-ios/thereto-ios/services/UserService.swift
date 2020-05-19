import FirebaseFirestore
import RxSwift
import RxCocoa
import Firebase
import Alamofire

protocol UserServiceProtocol {
    func signUp(user: User, completion: @escaping ((Observable<User>) -> Void))
    func isSessionExisted() -> Bool
    func validateUser(token: String, completion: @escaping (Bool) -> Void)
    func getUserInfo(token: String, completion: @escaping (Observable<User>) -> Void)
    func findUser(nickname: String, completion: @escaping (Observable<[User]>) -> Void)
    func getFriends(id: String, completion: @escaping (Observable<[Friend]>) -> Void)
    func requestFriend(id: String, friend: Friend, completion: @escaping (Observable<Void>) -> Void)
    func requestFriend(user: Friend, friend: Friend, completion: @escaping (Observable<Void>) -> Void)
    func favoriteFriend(userId: String, friendId: String, isFavorite: Bool)
    func findFriend(userId: String, friendId: String, completion: @escaping ((Observable<Friend>) -> Void))
    func deleteFriend(userId: String, friendId: String, completion: @escaping ((Observable<Void>) -> Void))
}

struct UserService: UserServiceProtocol{
    
    func signUp(user: User, completion: @escaping ((Observable<User>) -> Void)) {
        let url = "\(HTTPUtils.url)/signUp"
        let headers = HTTPUtils.jsonHeader()
        let params = user.toDict()
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if let value = response.value {
                if let commonResponse: CommonResponse<User> = JsonUtils.toJson(object: value) {
                    if commonResponse.error.isEmpty {
                        completion(Observable.just(commonResponse.data))
                    } else {
                        let error = CommonError(desc: commonResponse.error)
                        completion(Observable.error(error))
                    }
                } else {
                    let error = CommonError(desc: "Error in serilization.")
                    completion(Observable.error(error))
                }
            } else {
                let error = CommonError(desc: "데이터가 비어있습니다.")
                completion(Observable.error(error))
            }
        }
    }
    
    func isSessionExisted() -> Bool {
        if let _ = Auth.auth().currentUser {
            return true
        } else {
            return false
        }
    }
    
    func validateUser(token: String, completion: @escaping (Bool) -> Void) {
        Firestore.firestore()
            .collection("user")
            .document(token)
            .getDocument { (snapshot, error) in
            if snapshot?.data() == nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func getUserInfo(token: String, completion: @escaping (Observable<User>) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("user").document(token).getDocument { (snapshot, error) in
            if let error = error {
                completion(Observable.error(error))
            } else {
                if let data = snapshot?.data() {
                    let user = User(map: data)
                    completion(Observable.just(user))
                }
            }
        }
    }
    
    func findUser(nickname: String, completion: @escaping (Observable<[User]>) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("user").whereField("nickname", isEqualTo: nickname).getDocuments { (snapshot, error) in
            if let error = error {
                completion(Observable.error(error))
            }
            guard let snapshot = snapshot else {
                completion(Observable.error(CommonError(desc: "Snapshot is nil")))
                return
            }
            
            var userList:[User] = []
            for document in snapshot.documents {
                let user = User(map: document.data())
                
                userList.append(user)
            }
            completion(Observable.just(userList))
        }
    }
    
    func getFriends(id: String, completion: @escaping (Observable<[Friend]>) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("user").document(id).collection("friends").getDocuments { (snapshot, error) in
            if let error = error {
                completion(Observable.error(error))
            }
            guard let snapshot = snapshot else {
                let error = CommonError(desc: "Snapshot is nil")
                completion(Observable.error(error))
                return
            }
            
            var friendList:[Friend] = []
            for document in snapshot.documents {
                let user = Friend(map: document.data())
                
                friendList.append(user)
            }
            completion(Observable.just(friendList))
        }
    }
    
    func requestFriend(id: String, friend: Friend, completion: @escaping (Observable<Void>) -> Void) {
        let db = Firestore.firestore()
        
        var friendDict = friend.toDict()
        friendDict["createdAt"] = DateUtil.date2String(date: Date())
        db.document("user/\(id)").updateData(["newFriendRequest": true])
        db.collection("user/\(id)/friends").document(friend.id).setData(friendDict) { (error) in
            if let error = error {
                completion(Observable.error(error))
            } else {
                completion(Observable.just(()))
            }
        }
    }
    
    func requestFriend(user: Friend, friend: Friend, completion: @escaping (Observable<Void>) -> Void) {
        let url = "\(HTTPUtils.url)/requestFriend"
        let headers = HTTPUtils.jsonHeader()
        let params: [String: Any] = ["user": user.toDict(),
                                     "friend": friend.toDict()]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if let _ = response.value {
                completion(Observable.just(()))
            } else {
                let error = CommonError(desc: "데이터가 비어있습니다.")
                completion(Observable.error(error))
            }
        }
    }
    
    func favoriteFriend(userId: String, friendId: String, isFavorite: Bool) {
        Firestore.firestore().collection("user").document(userId).collection("friends").document(friendId).updateData(["favorite": isFavorite])
    }
    
    func findFriend(userId: String, friendId: String, completion: @escaping ((Observable<Friend>) -> Void)) {
        let db = Firestore.firestore()
        
        db.collection("user").document(userId).collection("friends").document(friendId).getDocument { (snapShot, error) in
            if let error = error {
                completion(Observable.error(error))
            } else {
                if let data = snapShot?.data() {
                    completion(Observable.just(Friend(map: data)))
                } else {
                    let error = CommonError(desc: "Snapshot is nil")
                    completion(Observable.error(error))
                }
            }
        }
    }
    
    func deleteFriend(userId: String, friendId: String, completion: @escaping ((Observable<Void>) -> Void)) {
        let db = Firestore.firestore()
        
        db.collection("user").document(userId).collection("friends").document(friendId).delete { (error) in
            if let error = error {
                completion(Observable.error(error))
            } else {
                completion(Observable.just(()))
            }
        }
    }
    
    static func saveUser(user: User, completion: @escaping () -> Void) {
        Firestore.firestore().collection("user").document("\(user.id)").setData(user.toDict()) { (error) in
            if let error = error {
                AlertUtil.show(message: error.localizedDescription)
            } else {
                completion()
            }
        }
    }
    
    static func isExistingUser(nickname: String, completion: @escaping (_ isExisted: Bool) -> Void) {
        Firestore.firestore()
            .collection("user")
            .whereField("nickname", isEqualTo: nickname)
            .getDocuments { (snapShot, error) in
                if let error = error {
                    AlertUtil.show(message: error.localizedDescription)
                } else {
                    if let snapshot = snapShot {
                        completion(!snapshot.isEmpty)
                    } else {
                        completion(false)
                    }
                }
        }
    }
    
    static func findFriends(completion: @escaping ([Friend]) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("user").document(UserDefaultsUtil.getUserToken()!).collection("friends").whereField("request_state", isEqualTo: "friend").limit(to: 20).getDocuments { (snapshot, error) in
            if let error = error {
                AlertUtil.show(message: error.localizedDescription)
            }
            guard let snapshot = snapshot else {
                AlertUtil.show(message: "snapshot is nil")
                return
            }
            
            var friendList:[Friend] = []
            for document in snapshot.documents {
                let user = Friend(map: document.data())
                
                friendList.append(user)
            }
            completion(friendList)
        }
    }
    
    static func findFriend(id: String, completion: @escaping ((Result<Friend>) -> Void)) {
        let db = Firestore.firestore()
        
        db.collection("user").document(UserDefaultsUtil.getUserToken()!).collection("friends").document(id).getDocument { (snapShot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                if let data = snapShot?.data() {
                    completion(.success(Friend.init(map: data)))
                } else {
                    completion(.failure(CommonError.init(desc: "snapShot is nil")))
                }
            }
        }
    }
    
    static func findUser(nickname: String, completion: @escaping ([User]) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("user").whereField("nickname", isEqualTo: nickname).getDocuments { (snapshot, error) in
            if let error = error {
                AlertUtil.show(message: error.localizedDescription)
            }
            guard let snapshot = snapshot else {
                AlertUtil.show(message: "snapshot is nil")
                return
            }
            
            var userList:[User] = []
            for document in snapshot.documents {
                let user = User(map: document.data())
                
                userList.append(user)
            }
            completion(userList)
        }
    }
    
    static func addFriend(token: String, friend: Friend, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        var friendDict = friend.toDict()
        friendDict["createdAt"] = DateUtil.date2String(date: Date())
        db.collection("user/\(token)/friends").document(friend.id).setData(friendDict) { (error) in
            if let error = error {
                AlertUtil.show("error", message: error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    static func getMyUser(completion: @escaping (User) -> Void) {
        let db = Firestore.firestore()
        let token = UserDefaultsUtil.getUserToken()!
        
        db.collection("user").document(token).getDocument { (snapshot, error) in
            if let error = error {
                AlertUtil.show("error", message: error.localizedDescription)
            } else {
                if let data = snapshot?.data() {
                    completion(User(map: data))
                }
            }
        }
    }
    
    static func deleteFriend(token: String, friendId: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("user").document(token).collection("friends").document(friendId).delete { (error) in
            if let error = error {
                AlertUtil.show("error", message: error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    static func getReceivedFriends(completion: @escaping (([Friend]) -> Void)) {
        let db = Firestore.firestore()
        
        db.collection("user").document(UserDefaultsUtil.getUserToken()!).collection("friends").whereField("request_state", isEqualTo: "wait").getDocuments { (snapShot, error) in
            if let error = error {
                AlertUtil.show("error", message: error.localizedDescription)
                print(error.localizedDescription)
            } else {
                if let snapShot = snapShot {
                    var friends:[Friend] = []
                    for document in snapShot.documents {
                        let user = Friend(map: document.data())
                        
                        friends.append(user)
                    }
                    completion(friends)
                } else {
                    AlertUtil.show("error", message: "snapShots is nil")
                }
            }
        }
    }
    
    static func getSentFriends(completion: @escaping (([Friend]) -> Void)) {
        let db = Firestore.firestore()
        
        db.collection("user").document(UserDefaultsUtil.getUserToken()!).collection("friends").whereField("request_state", isEqualTo: "request_sent").getDocuments { (snapShot, error) in
            if let error = error {
                AlertUtil.show("error", message: error.localizedDescription)
            } else {
                if let snapShot = snapShot {
                    var friends:[Friend] = []
                    for document in snapShot.documents {
                        let user = Friend(map: document.data())
                        
                        friends.append(user)
                    }
                    completion(friends)
                } else {
                    AlertUtil.show("error", message: "snapShots is nil")
                }
            }
        }
    }
    
    static func updateRequest(friendToken: String, completion: @escaping ((Bool) -> Void)) {
        let db = Firestore.firestore()
        
        db.collection("user").document(UserDefaultsUtil.getUserToken()!).collection("friends").document(friendToken).updateData(["createAt" : Date()]) { error in
            if let error = error {
                AlertUtil.show("error", message: error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    static func acceptRequest(token: String, friendToken: String, completion: @escaping ((Bool) -> Void)) {
        let db = Firestore.firestore()
        
        db.collection("user").document(token).collection("friends").document(friendToken).updateData(["request_state" : "friend"]) { error in
            if let error = error {
                AlertUtil.show("error", message: error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    static func fetchRedDot(token: String) {
        let db = Firestore.firestore()
        
        db.document("user/\(token)").updateData(["newFriendRequest": false])
    }
}
