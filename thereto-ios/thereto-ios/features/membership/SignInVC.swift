import UIKit
import RxSwift
import RxRelay
import RxCocoa
import AuthenticationServices

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
