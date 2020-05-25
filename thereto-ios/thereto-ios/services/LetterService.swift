import FirebaseStorage
import FirebaseFirestore
import RxSwift

protocol LetterServiceProtocol {
    func getLetters(receiverId: String, completion: @escaping ((Observable<[Letter]>) -> Void))
}

struct LetterSerivce: LetterServiceProtocol {
    func getLetters(receiverId: String, completion: @escaping ((Observable<[Letter]>) -> Void)) {
        Firestore.firestore().collection("letter")
            .whereField("to.id", isEqualTo: receiverId)
            .order(by: "createdAt", descending: true)
            .getDocuments { (snapShot, error) in
            if let error = error {
                completion(Observable.error(error))
            } else {
                var letters: [Letter] = []
                if let documents = snapShot?.documents {
                    for document in documents {
                        letters.append(Letter.init(map: document.data()))
                    }
                }
                completion(Observable.just(letters))
            }
        }
    }
    
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
        let documentRef = Firestore.firestore().collection("letter").document()
        var letterDict = letter.toDict()
        
        letterDict["id"] = documentRef.documentID
        documentRef.setData(letterDict) { (error) in
            if let error = error {
                AlertUtil.show(message: error.localizedDescription)
            } else {
                completion()
            }
        }
    }
    
    static func getSentLetters(completion: @escaping ((Result<[Letter]>) -> Void)) {
        let senderId = UserDefaultsUtil.getUserToken()!
        Firestore.firestore().collection("letter")
            .whereField("from.id", isEqualTo: senderId)
            .order(by: "timestamp", descending: false)
            .getDocuments { (snapShot, error) in
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
        
        Firestore.firestore().collection("letter")
            .whereField("to.id", isEqualTo: receiverId)
            .order(by: "timestamp", descending: false)
            .getDocuments { (snapShot, error) in
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
    
    static func searchLetters(keyword: String, type: String, completion: @escaping ((Result<[Letter]>) -> Void)) {
        let oppose = type == "from" ? "to" : "from"
        
        Firestore.firestore().collection("letter")
            .whereField("\(type).id", isEqualTo: UserDefaultsUtil.getUserToken()!)
            .whereField("\(oppose).nickname", isEqualTo: keyword)
            .order(by: "timestamp", descending: false)
            .getDocuments { (snapShot, error) in
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
    
    static func deleteLetter(letterId: String, completion: @escaping ((Result<Void>) -> Void)) {
        Firestore.firestore().collection("letter").document(letterId).delete { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    static func increaseReceiveCount(userId: String) {
        Firestore.firestore().collection("user").document(userId).updateData(["receivedCount": FieldValue.increment(Int64(1))])
    }
    
    static func increaseSentCount(userId: String) {
        Firestore.firestore().collection("user").document(userId).updateData(["sentCount": FieldValue.increment(Int64(1))])
    }
    
    static func increaseFriendCount(userId: String) {
        Firestore.firestore().collection("user").document(UserDefaultsUtil.getUserToken()!).collection("friends").document(userId).updateData(["sentCount": FieldValue.increment(Int64(1))])
        Firestore.firestore().collection("user").document(userId).collection("friends").document(UserDefaultsUtil.getUserToken()!).updateData(["receivedCount": FieldValue.increment(Int64(1))])
    }
    
    static func setRead(letterId: String) {
        Firestore.firestore().collection("letter").document(letterId).updateData(["isRead": true])
    }
}
