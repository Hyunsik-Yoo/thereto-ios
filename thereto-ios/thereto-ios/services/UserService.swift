import FirebaseFirestore
import RxSwift
import RxCocoa
import Firebase

protocol UserServiceProtocol {
    func signUp(user: User, completion: @escaping ((Observable<CommonResponse<User>>) -> Void))
    func isSessionExisted() -> Bool
}

struct UserService: UserServiceProtocol{
    func isSessionExisted() -> Bool {
        if let _ = Auth.auth().currentUser {
            return true
        } else {
            return false
        }
    }
    
    func signUp(user: User, completion: @escaping ((Observable<CommonResponse<User>>) -> Void)) {
        /**
         회원가입 로직
         동일한 아이디가 존재하면 에러를 반환
         */
        print("회원가입 함수가 호출되었습니다.")
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
    
    static func validateUser(token: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("user").document(token).getDocument { (snapshot, error) in
            if snapshot?.data() == nil {
                completion(false)
            } else {
                completion(true)
            }
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
}
