import UIKit
import RxSwift
import RxRelay
import RxCocoa
import AuthenticationServices
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth

class SignInVC: BaseVC {
    
    private lazy var signInView: SignInView = {
        let view = SignInView(frame: self.view.frame)
        
        return view
    }()
    
    
    static func instance() -> SignInVC {
        return SignInVC(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        view = signInView
        
        signInView.fbBtn.delegate = self
        signInView.appleBtn.rx.controlEvent(.touchUpInside)
            .subscribe { (event) in
                self.onTapAppleBtn()
        }.disposed(by: disposeBag)
    }
    
    func onTapAppleBtn() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        
        request.requestedScopes = [.email, .fullName]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension SignInVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let crenditial = authorization.credential as? ASAuthorizationAppleIDCredential {
            print("email: \(crenditial.email)")
            print("full name: \(crenditial.fullName)")
        }
    }
}

extension SignInVC: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            AlertUtil.show(message: error.localizedDescription)
        } else {
            if let token = AccessToken.current?.tokenString {
                let credential = FacebookAuthProvider.credential(withAccessToken: token)
                
                FirebaseUtil.auth(credential: credential) {
                    // onSuccess auth
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("logout")
    }
}
