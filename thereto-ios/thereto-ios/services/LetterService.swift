import FirebaseStorage
import FirebaseFirestore
import RxSwift

protocol LetterServiceProtocol {
  func fetchLetters(receiverId: String) -> Observable<[Letter]>
  func getSentLetters(senderId: String) -> Observable<[Letter]>
  func saveLetterImage(image: UIImage, name: String) -> Observable<String>
  func sendLetter(letter: Letter) -> Observable<Void>
  func increaseSentCount(userId: String)
  func increaseReceiveCount(userId: String)
  func increaseFriendCount(userId: String)
}

struct LetterSerivce: LetterServiceProtocol {
  
  func fetchLetters(receiverId: String) -> (Observable<[Letter]>) {
    return Observable.create { observer -> Disposable in
      Firestore.firestore()
        .collection("letter")
        .whereField("to.id", isEqualTo: receiverId)
        .order(by: "createdAt", descending: true)
        .getDocuments { (snapShot, error) in
          if let error = error {
            observer.onError(error)
          }
          
          var letters: [Letter] = []
          if let documents = snapShot?.documents {
            for document in documents {
              letters.append(Letter.init(map: document.data()))
            }
          }
          observer.onNext(letters)
          observer.onCompleted()
      }
      return Disposables.create()
    }
  }
  
  func getSentLetters(senderId: String) -> Observable<[Letter]> {
    return Observable.create { observer -> Disposable in
      Firestore.firestore().collection("letter")
        .whereField("from.id", isEqualTo: senderId)
        .order(by: "timestamp", descending: true)
        .getDocuments { (snapShot, error) in
          if let error = error {
            let commonError = CommonError(error: error)
            
            observer.onError(commonError)
          } else {
            var letters: [Letter] = []
            
            if let documents = snapShot?.documents {
              for document in documents {
                letters.append(Letter.init(map: document.data()))
              }
              observer.onNext(letters)
              observer.onCompleted()
            }
          }
      }
      return Disposables.create()
    }
  }
  
  func saveLetterImage(image: UIImage, name: String) -> Observable<String> {
    return Observable.create { observer -> Disposable in
      let storageRef = Storage.storage().reference()
      let imagesRef = storageRef.child("letterbox/\(name).jpg")
      
      if let data = image.pngData() {
        let _ = imagesRef.putData(data, metadata: nil) { (metadata, error) in
          if metadata == nil {
            let error = CommonError(desc: "metadata is nil")
            
            observer.onError(error)
          }
          
          imagesRef.downloadURL { (url, error) in
            if url == nil {
              let error = CommonError(desc: "downloadURL is nil")
              
              observer.onError(error)
            }
            observer.onNext(url!.absoluteString)
            observer.onCompleted()
          }
        }
      } else {
        let error = CommonError(desc: "image.pngData() is nil")
        
        observer.onError(error)
      }
      return Disposables.create()
    }
  }
  
  func sendLetter(letter: Letter) -> Observable<Void> {
    return Observable.create { observer -> Disposable in
      let documentRef = Firestore.firestore().collection("letter").document()
      var letterDict = letter.toDict()
      
      letterDict["id"] = documentRef.documentID
      documentRef.setData(letterDict) { (error) in
        if let error = error {
          observer.onError(error)
        } else {
          observer.onNext(())
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
  
  func increaseSentCount(userId: String) {
    Firestore.firestore().collection("user").document(userId).updateData(["sentCount": FieldValue.increment(Int64(1))])
  }
  
  func increaseReceiveCount(userId: String) {
    Firestore.firestore().collection("user").document(userId).updateData(["receivedCount": FieldValue.increment(Int64(1))])
  }
  
  func increaseFriendCount(userId: String) {
    Firestore.firestore().collection("user").document(UserDefaultsUtil().getUserToken()!).collection("friends").document(userId).updateData(["sentCount": FieldValue.increment(Int64(1))])
    Firestore.firestore().collection("user").document(userId).collection("friends").document(UserDefaultsUtil().getUserToken()!).updateData(["receivedCount": FieldValue.increment(Int64(1))])
  }
  
  static func getLetters(completion: @escaping ((Result<[Letter]>) -> Void)) {
    let receiverId = UserDefaultsUtil().getUserToken()!
    
    Firestore.firestore().collection("letter")
      .whereField("to.id", isEqualTo: receiverId)
      .order(by: "timestamp", descending: true)
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
      .whereField("\(type).id", isEqualTo: UserDefaultsUtil().getUserToken()!)
      .whereField("\(oppose).nickname", isEqualTo: keyword)
      .order(by: "timestamp", descending: true)
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
  
  static func setRead(letterId: String) {
    Firestore.firestore().collection("letter").document(letterId).updateData(["isRead": true])
  }
}
