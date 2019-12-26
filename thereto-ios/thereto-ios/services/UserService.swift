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
        
        db.collection("user").whereField("nickname", isGreaterThan: nickname).addSnapshotListener { (snapshot, error) in
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
}
