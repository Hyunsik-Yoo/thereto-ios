import FirebaseFirestore

struct UserService {
    
    static func saveUser(user: User, completion: @escaping () -> Void) {
        Firestore.firestore().collection("user").addDocument(data: user.toDict()) { (error) in
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
}
