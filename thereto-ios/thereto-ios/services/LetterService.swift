import FirebaseStorage
import FirebaseFirestore

struct LetterSerivce {
    
    static func saveLetterPhoto(image: UIImage, name: String, completion: @escaping ((Result<String>) -> Void)) {
        let storageRef = Storage.storage().reference()
        let imagesRef = storageRef.child("letterbox/\(name).jpg")
        
        if let data = image.pngData() {
            let _ = imagesRef.putData(data, metadata: nil) { (metadata, error) in
                guard let _ = metadata else {
                    completion(.failure(CommonError.init(desc: "metadata is nil")))
                    return
                }
                
                imagesRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        completion(.failure(CommonError.init(desc: "downloadURL is nil")))
                        return
                    }
                    completion(.success(downloadURL.absoluteString))
                }
            }
        } else {
            completion(.failure(CommonError.init(desc: "image.pngData() is nil")))
        }
    }
    
    static func sendLetter(letter: Letter, completion: @escaping (() -> Void)) {
        Firestore.firestore().collection("letter").document().setData(letter.toDict()) { (error) in
            if let error = error {
                AlertUtil.show(message: error.localizedDescription)
            } else {
                completion()
            }
        }
    }
    
    static func getSentLetters(completion: @escaping ((Result<[Letter]>) -> Void)) {
        let senderId = UserDefaultsUtil.getUserToken()!
        Firestore.firestore().collection("letter").whereField("from.id", isEqualTo: senderId).getDocuments { (snapShot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                var letters: [Letter] = []
                if let documents = snapShot?.documents {
                    for document in documents {
                        letters.append(Letter.init(map: document.data()))
                    }
                    completion(.success(letters))
                }
            }
        }
    }
    
    static func getLetters(completion: @escaping ((Result<[Letter]>) -> Void)) {
        let receiverId = UserDefaultsUtil.getUserToken()!
        
        Firestore.firestore().collection("letter").whereField("to.id", isEqualTo: receiverId).getDocuments { (snapShot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                var letters: [Letter] = []
                if let documents = snapShot?.documents {
                    for document in documents {
                        letters.append(Letter.init(map: document.data()))
                    }
                    completion(.success(letters))
                }
            }
        }
    }
    
    static func increaseReceiveCount(userId: String) {
        Firestore.firestore().collection("user").document(userId).updateData(["receive_count": FieldValue.increment(Int64(1))])
    }
    
    static func increaseSentCount(userId: String) {
        Firestore.firestore().collection("user").document(userId).updateData(["sent_count": FieldValue.increment(Int64(1))])
    }
}
