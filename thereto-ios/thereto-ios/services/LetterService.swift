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
}
