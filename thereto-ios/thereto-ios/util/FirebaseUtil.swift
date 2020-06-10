import FirebaseAuth


struct FirebaseUtil {
    
    static func auth(credential: AuthCredential, onSuccess completion: @escaping () -> Void) {
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                AlertUtil.show(message: error.localizedDescription)
            } else {
                completion()
            }
        }
    }
    
    static func signOut() {
        try! Auth.auth().signOut() 
    }
}
