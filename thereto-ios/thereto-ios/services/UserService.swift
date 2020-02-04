import FirebaseFirestore

struct UserService {
    
    static func saveUser(user: User, completion: @escaping () -> Void) {
        Firestore.firestore().collection("user").document("\(user.getSocial())\(user.socialId)").setData(user.toDict()) { (error) in
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
    
    static func findFriend(id: String, completion: @escaping ([User]) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("user").document(id).collection("friends").limit(to: 20).getDocuments { (snapshot, error) in
            if let error = error {
                AlertUtil.show(message: error.localizedDescription)
            }
            guard let snapshot = snapshot else {
                AlertUtil.show(message: "snapshot is nil")
                return
            }
            
            var friendList:[User] = []
            for document in snapshot.documents {
                let user = User(map: document.data())
                
                friendList.append(user)
            }
            completion(friendList)
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
    
    static func addFriend(token: String, friend: User, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let friendToken = "\(friend.getSocial())\(friend.socialId)"
        
        db.collection("user/\(token)/friends").document(friendToken).setData(friend.toDict()) { (error) in
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
    
    static func deleteFriend(token: String, friendToken: String, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        db.collection("user").document(token).collection("friends").document(friendToken).delete { (error) in
            if let error = error {
                AlertUtil.show("error", message: error.localizedDescription)
            } else {
                completion()
            }
        }
    }
    
    static func getReceivedFriends(completion: @escaping (([User]) -> Void)) {
        let db = Firestore.firestore()
        
        db.collection("user").document(UserDefaultsUtil.getUserToken()!).collection("friends").whereField("request_state", isEqualTo: "wait").getDocuments { (snapShot, error) in
            if let error = error {
                AlertUtil.show("error", message: error.localizedDescription)
                print(error.localizedDescription)
            } else {
                if let snapShot = snapShot {
                    var friends:[User] = []
                    for document in snapShot.documents {
                        let user = User(map: document.data())
                        
                        friends.append(user)
                    }
                    completion(friends)
                } else {
                    AlertUtil.show("error", message: "snapShots is nil")
                }
            }
        }
    }
    
    static func getSentFriends(completion: @escaping (([User]) -> Void)) {
        let db = Firestore.firestore()
        
        db.collection("user").document(UserDefaultsUtil.getUserToken()!).collection("friends").whereField("request_state", isEqualTo: "request_sent").getDocuments { (snapShot, error) in
            if let error = error {
                AlertUtil.show("error", message: error.localizedDescription)
                print(error.localizedDescription)
            } else {
                if let snapShot = snapShot {
                    var friends:[User] = []
                    for document in snapShot.documents {
                        let user = User(map: document.data())
                        
                        friends.append(user)
                    }
                    completion(friends)
                } else {
                    AlertUtil.show("error", message: "snapShots is nil")
                }
            }
        }
    }
}
