import UIKit
import RxSwift
import RxRelay
import RxCocoa
import AuthenticationServices
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import CryptoKit

class SignInVC: BaseVC {
    
    private lazy var signInView = SignInView(frame: self.view.frame)
    private var viewModel = SignInViewModel(service: UserService(),
                                            userDefaults: UserDefaultsUtil())
    fileprivate var currentNonce: String?
    
    
    static func instance() -> UINavigationController {
        let controller = SignInVC(nibName: nil, bundle: nil)
        let navi = UINavigationController(rootViewController: controller)
        
        return navi
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = signInView
        setupNavigation()
        
        signInView.fbBtn.delegate = self
    }
    
    override func bindEvent() {
        if #available(iOS 13.0, *) {
            signInView.appleBtn!.rx.controlEvent(.touchUpInside)
                .subscribe { [weak self] (event) in
                    guard let self = self else { return }
                    self.onTapAppleBtn()
            }.disposed(by: disposeBag)
        }
    }
    
    override func bindViewModel() {
        viewModel.output.showLoading.bind(onNext: signInView.showLoading(isShow:))
            .disposed(by: disposeBag)
        viewModel.output.goToMain.bind(onNext: goToMain)
            .disposed(by: disposeBag)
        viewModel.output.goToProfile.bind(onNext: goToProfile)
            .disposed(by: disposeBag)
    }
    
    func onTapAppleBtn() {
        if #available(iOS 13.0, *) {
            startSignInWithAppleFlow()
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func goToMain() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.goToMain()
        }
    }
    
    
    @available(iOS 13.0, *)
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func setupNavigation() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @available(iOS 13.0, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if length == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    private func goToProfile(userId: String, social: String) {
        navigationController?.pushViewController(ProfileVC.instance(id: userId, social: social), animated: true)
    }
}

extension SignInVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                AlertUtil.show(controller: self, title: "Sign with apple error",
                               message: "Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                AlertUtil.show(controller: self, title: "Sign with apple error",
                               message: "Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            let socialToken = "apple\(appleIDCredential.user)"
            
            // Sign in with Firebase.
            FirebaseUtil.auth(credential: credential) {
                self.viewModel.input.userToken.onNext((socialToken, "apple"))
            }
        }
    }
}

extension SignInVC: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            AlertUtil.show(message: error.localizedDescription)
        } else {
            if let token = AccessToken.current?.tokenString,
                let id = result?.token?.userID {
                let credential = FacebookAuthProvider.credential(withAccessToken: token)
                let socialToken = "facebook\(id)"
                
                FirebaseUtil.auth(credential: credential) {
                    self.viewModel.input.userToken.onNext((socialToken, "facebook"))
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("logout")
    }
}
