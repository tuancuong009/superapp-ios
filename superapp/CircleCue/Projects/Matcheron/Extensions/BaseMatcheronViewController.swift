//
//  BaseViewController.swift


import UIKit
import LGSideMenuController
import RappleProgressHUD
import GoogleSignIn
import Alamofire
import AuthenticationServices
import FBSDKLoginKit

class BaseMatcheronViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllFontLabel()
    }
    

    @IBAction func doMenu(_ sender: Any) {
        self.sideMenuController?.showLeftView(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func showAlertMessage(message: String)
    {
        let alert = UIAlertController(title: APP_NAME,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Ok",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showBusy()
    {
        var attribute = RappleActivityIndicatorView.attribute(style: .apple, tintColor: .white, screenBG: .lightGray, progressBG: .black, progressBarBG: .orange, progreeBarFill: .red, thickness: 4)
        attribute[RappleIndicatorStyleKey] = RappleStyleCircle
        RappleActivityIndicatorView.startAnimatingWithLabel("", attributes: attribute)
        
    }
    
    func hideBusy()
    {
        RappleActivityIndicatorView.stopAnimation()
    }
    
    func showOutsideAppWebContent(urlString: String) {
        if let url = URL.init(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func showAlertMessageAction(_ message: String, complete:@escaping (_ success: Bool) ->Void)
    {
        let alert = UIAlertController(title: APP_NAME,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction.init(title: "No", style: .cancel) { action in
            complete(false)
        }
        
        alert.addAction(cancelAction)
        
        let yesAction = UIAlertAction.init(title: "Yes", style: .default) { action in
            complete(true)
        }
        
        alert.addAction(yesAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertMessageComback(_ message: String, complete:@escaping (_ success: Bool) ->Void)
    {
        let alert = UIAlertController(title: APP_NAME,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        let yesAction = UIAlertAction.init(title: "OK", style: .default) { action in
            complete(true)
        }
        
        alert.addAction(yesAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func getSubviewsOfView<T: UIView>(view: UIView) -> [T] {
        var subviewArray = [T]()
        if view.subviews.count == 0 {
            return subviewArray
        }
        for subview in view.subviews {
            subviewArray += self.getSubviewsOfView(view: subview) as [T]
            if let subview = subview as? T {
                subviewArray.append(subview)
            }
        }
        return subviewArray
    }
    
    func loadAllFontLabel(_ size: CGFloat = 4){
        let allLabels: [UILabel] = self.getSubviewsOfView(view: self.view)
        let allButtons: [UIButton] = self.getSubviewsOfView(view: self.view)
        let allUITextFields: [UITextField] = self.getSubviewsOfView(view: self.view)
        for allLabel in allLabels {
            allLabel.font = UIFont(name: allLabel.font.fontName, size: allLabel.font.pointSize + size)
        }
        
        for allButton in allButtons {
            allButton.titleLabel?.font = UIFont(name: allButton.titleLabel!.font.fontName, size: allButton.titleLabel!.font.pointSize + size)
        }
        
        for allUITextField in allUITextFields {
            allUITextField.font = UIFont(name: allUITextField.font!.fontName, size: allUITextField.font!.pointSize + size)
        }
    }
    //MARK: - FACEBOOK
    func signInWithFacebook() {
        let loginManager = LoginManager()
        let permissions = ["public_profile", "email", "user_link"]
        loginManager.logIn(permissions: permissions, from: self) { (result: LoginManagerLoginResult?, error: Error?) in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlertMessage(message: error.localizedDescription)
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
        self.showBusy()
        let parameters = ["fields": "id, email, name, link, picture.type(large)"]
        GraphRequest(graphPath: "me", parameters: parameters, tokenString: token, version: nil, httpMethod: .get).start { (connection, result, error) in
            if let error = error {
                self.hideBusy()
                self.showAlertMessage(message: error.localizedDescription)
                return
            }
            guard let info = result as? NSDictionary, let _ = info.value(forKey: "email") as? String else {
                self.hideBusy()
                return
            }
            print(info)
            let loginObj = SocialLoginObj(dic: info)
            self.loginWithFacebook(loginObj)
        }
    }
    
    private func loginWithFacebook(_ loginObj: SocialLoginObj) {
        guard !loginObj.email.isEmpty, loginObj.email.isValidEmail() else {
            self.hideBusy()
            return
        }
        
        let avatarUrlString = "https://graph.facebook.com/\(loginObj.id)/picture?width=500&height=500"
        let pic = loginObj.pic ?? avatarUrlString
        let para: Parameters = ["email": loginObj.email,
                                "name": loginObj.name.replacingOccurrences(of: " ", with: ""),
                                "pic": pic,
                                "src": "iOS",
                                "src2": "Facebook"]
        APIHelper.shared.registerSocial(param: para) { success, erro in
            self.hideBusy()
            if success!{
                APP_DELEGATE.initTabbar()
            }
            else{
                if let err = erro{
                    self.showAlertMessage(message: err)
                }
            }
        }
    }
    // MARK: - GOOGLE
    func signInWithGoogle() {
        GIDSignIn.sharedInstance.signOut()
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard let user = result?.user else {
                self.showAlertMessage(message: error?.localizedDescription ?? "Fail")
                return
            }
            guard let profile = user.profile else {
                return
            }
            
            self.showBusy()
            var para: Parameters = ["email": profile.email,
                                    "name": profile.name.replacingOccurrences(of: " ", with: ""),
                                    "src": "iOS",
                                    "src2": "Google"
                                    ]
            if let pic = profile.imageURL(withDimension: 500) {
                para.updateValue(pic, forKey: "pic")
            }
            APIHelper.shared.registerSocial(param: para) { success, erro in
                
                if success!{
                    self.checkProfile()
                }
                else{
                    self.hideBusy()
                    if let err = erro{
                        self.showAlertMessage(message: err)
                    }
                }
            }
        }
    }
    
    private func checkProfile(){
        let userID = UserDefaults.standard.value(forKey: USER_ID) as? String ?? ""
        APIHelper.shared.myprofile(id: userID) { success, dict in
            self.hideBusy()
            if let dict = dict{
                let state =  (dict.object(forKey: "state") as? String ?? "")
                let password =  (dict.object(forKey: "password") as? String ?? "")
                UserDefaults.standard.set(password, forKey: USER_PASSWORD)
                UserDefaults.standard.synchronize()
                if state.isEmpty{
                    UserDefaults.standard.removeObject(forKey: USER_ID)
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FinalSocialAccountViewController") as! FinalSocialAccountViewController
                    vc.dictUser = dict
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else{
                    APP_DELEGATE.initTabbar()
                }
            }
            else{
                UserDefaults.standard.removeObject(forKey: USER_ID)
                self.showAlertMessage(message: "Get Info Mrofile Fail")
            }
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
        
       
        self.showBusy()
        var para: Parameters = ["token": accessToken,  "src": "iOS",
                                "src2": "Apple"]
        print(para)
        if let name = fullName {
            para.updateValue(name, forKey: "name")
        }
        if let email = credential.email {
            para.updateValue(email, forKey: "email")
        }
        APIHelper.shared.registerSocial(param: para) { success, erro in
           
            if success!{
                self.checkProfile()
            }
            else{
                self.hideBusy()
                if let err = erro{
                    self.showAlertMessage(message: err)
                }
            }
        }
    }
    
}
extension BaseMatcheronViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            self.signInWithApple(credential: appleIDCredential)
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.showAlertMessage(message: "Something went wrong. Please try again")
    }
}

extension BaseMatcheronViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
extension String
{
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidUsername() -> Bool {
        let RegEx = "\\w{7,18}"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: self)
    }
    
    func trimText() -> String
    {
       return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}

