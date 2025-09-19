//
//  AuthenticationViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 23/02/2023.
//

import UIKit
import FBSDKLoginKit
import Alamofire
import AuthenticationServices
import GoogleSignIn

struct SocialLoginObj {
    var id: String = ""
    var email: String = ""
    var name: String = ""
    var pic: String?
    
    init(dic: NSDictionary?) {
        self.id = dic?.value(forKey: "id") as? String ?? ""
        self.email = dic?.value(forKey: "email") as? String ?? ""
        self.name = dic?.value(forKey: "name") as? String ?? ""
        self.pic = ((dic?.value(forKey: "picture") as? NSDictionary)?.value(forKey: "data") as? NSDictionary)?.value(forKey: "url") as? String
    }
}

class AuthenticationViewController: BaseViewController {
    
    //MARK: - FACEBOOK
    func signInWithFacebook() {
        let loginManager = LoginManager()
        let permissions = ["public_profile", "email", "user_link"]
        loginManager.logIn(permissions: permissions, from: self) { (result: LoginManagerLoginResult?, error: Error?) in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(title: "Oops!", message: error.localizedDescription)
                    return
                }
            }
            guard let token = result?.token else {
                return
            }
            print(token.tokenString)
            self.getFacebookData(token: token.tokenString)
        }
    }
    
    private func getFacebookData(token: String?) {
        self.showSimpleHUD()
        let parameters = ["fields": "id, email, name, link, picture.type(large)"]
        GraphRequest(graphPath: "me", parameters: parameters, tokenString: token, version: nil, httpMethod: .get).start { (connection, result, error) in
            if let error = error {
                self.hideLoading()
                self.showAlert(title: "Oops!", message: error.localizedDescription)
                return
            }
            guard let info = result as? NSDictionary, let _ = info.value(forKey: "email") as? String else {
                self.hideLoading()
                return
            }
            print(info)
            let loginObj = SocialLoginObj(dic: info)
            self.loginWithFacebook(loginObj)
        }
    }
    
    private func loginWithFacebook(_ loginObj: SocialLoginObj) {
        guard !loginObj.email.isEmpty, loginObj.email.isValidEmail() else {
            self.hideLoading()
            return
        }
        
        let avatarUrlString = "https://graph.facebook.com/\(loginObj.id)/picture?width=500&height=500"
        let pic = loginObj.pic ?? avatarUrlString
        let para: Parameters = ["email": loginObj.email,
                                "name": loginObj.name.replacingOccurrences(of: " ", with: ""),
                                "pic": pic,
                                "app_src": "iOS",
                                "social_login": "Facebook"]
        ManageAPI.shared.loginWithSocial(para) {[weak self] (userId, error) in
            guard let self = self else { return }
            if let userId = userId {
                self.fetchUserInfo(userId: userId)
                return
            }
            self.hideLoading()
            if error?.lowercased().contains("pic") == true || error?.lowercased().contains("name") == true {
                self.reachToCompleteSocialLogin(socialLoginType: .facebook(loginObj.email, pic))
                return
            }
            self.showErrorAlert(message: error)
        }
    }
    
    private func fetchUserInfo(userId: String) {
        ManageAPI.shared.fetchUserInfo(userId) {[weak self] (user, error) in
            guard let self = self else { return }
            self.hideLoading()
            if let user = user {
                if user.is_verified {
                    ManageAPI.shared.updateUserLoginStatus(userId)
                    AppSettings.shared.currentUser = user
                    AppSettings.shared.saveSocialLogin(userId: userId)
                    self.initHomePage()
                } else {
                    self.showErrorAlert(message: "Your account is temporary disabled, please contact us for more information.")
                }
                return
            }
            self.showAlert(title: "Opps!", message: error)
        }
    }
    
    //MARK: - APPLE
    
    func performSignInWithApple() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func signInWithApple(credential: ASAuthorizationAppleIDCredential) {
        guard let identityToken = credential.identityToken, let accessToken = String(data: identityToken, encoding: .utf8) else {
            return
        }
        
        print("accessToken =", accessToken)
        let firstName = credential.fullName?.givenName
        let lastName = credential.fullName?.familyName
        var fullName: String?
        if firstName != nil && lastName != nil {
            fullName = "\(firstName!)\(lastName!)"
        } else if firstName != nil {
            fullName = firstName
        } else if lastName != nil {
            fullName = lastName
        }
        
        if let email = credential.email, let name = fullName?.trimmed {
            print(email, name)
            KeychainWrapper.standard.set(name, forKey: email)
        } else {
            if let jwt = try? decode(jwt: accessToken), let email = jwt.claim(name: "email").string {
                print(email)
                fullName = KeychainWrapper.standard.string(forKey: email)
                print(fullName as Any)
            }
        }
        
        self.showSimpleHUD()
        var para: Parameters = ["token": accessToken,
                                "app_src": "iOS",
                                "social_login": "Apple"]
        if let name = fullName {
            para.updateValue(name, forKey: "name")
        }
        ManageAPI.shared.loginWithSocial(para) {[weak self] (userId, error) in
            guard let self = self else { return }
            if let userId = userId {
                self.fetchUserInfo(userId: userId)
                return
            }
            self.hideLoading()
            if error?.lowercased().contains("pic") == true || error?.lowercased().contains("name") == true {
                
                self.reachToCompleteSocialLogin(socialLoginType: .apple(accessToken, fullName, credential.fullName?.givenName, credential.fullName?.familyName))
                return
            }
            self.showErrorAlert(message: error)
        }
    }
    
    // MARK: - GOOGLE
    func signInWithGoogle() {
        GIDSignIn.sharedInstance.signOut()
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard let user = result?.user else {
                self.showErrorAlert(message: error?.localizedDescription)
                return
            }
            guard let profile = user.profile else {
                return
            }
            
            self.showSimpleHUD()
            var para: Parameters = ["email": profile.email,
                                    "name": profile.name.replacingOccurrences(of: " ", with: ""),
                                    "app_src": "iOS",
                                    "social_login": "Google"]
            if let pic = profile.imageURL(withDimension: 500) {
                para.updateValue(pic, forKey: "pic")
            }
            ManageAPI.shared.loginWithSocial(para) {[weak self] (userId, error) in
                guard let self = self else { return }
                if let userId = userId {
                    self.fetchUserInfo(userId: userId)
                    return
                }
                self.hideLoading()
                if error?.lowercased().contains("pic") == true || error?.lowercased().contains("name") == true {
                    self.reachToCompleteSocialLogin(socialLoginType: .google(profile.email, profile.name.replacingOccurrences(of: " ", with: "")))
                    return
                }
                self.showErrorAlert(message: error)
            }
        }
    }
    
    private func reachToCompleteSocialLogin(socialLoginType: SocialLoginType) {
        let controller = CompleteSignInSocialViewController.instantiate(from: StoryboardName.authentication.rawValue)
        controller.socialLoginType = socialLoginType
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: Apple login

extension AuthenticationViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            self.signInWithApple(credential: appleIDCredential)
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        showErrorAlert(title: "Oops!", message: "Something went wrong. Please try again.")
    }
}

extension AuthenticationViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
