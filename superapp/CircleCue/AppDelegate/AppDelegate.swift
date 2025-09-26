//
//  AppDelegate.swift
//  CircleCue
//
//  Created by QTS Coder on 10/3/20.
//


import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import FBSDKCoreKit
import Alamofire
import MapKit
import Swifter
import FirebaseMessaging
import Firebase
import SDWebImagePDFCoder
import GoogleSignIn
import ZegoUIKit
import ZegoUIKitPrebuiltLiveStreaming
import LGSideMenuController

import AuthenticationServices
import FBSDKLoginKit
import SwiftUI
import RappleProgressHUD

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var locationManager = CLLocationManager()
    var token: String?
    var user: NSDictionary?
    var isSendPushNotification = false
    var messageAll = [MessageObj]()
    var homeViewController: BaseRRViewController?
    var menuVC: MenuViewController?
    var isRegisterNew: Bool = false
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.applicationIconBadgeNumber = 0
        FirebaseApp.configure()
        setupToast()
        setupKeyboardManager()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        GMSServices.provideAPIKey(AppConfiguration.GOOGLE_API_KEY)
        registerForPushNotifications(application)
        
        let PDFCoder = SDImagePDFCoder.shared
        SDImageCodersManager.shared.addCoder(PDFCoder)
        setRoot()
//        if AppSettings.shared.showPurchaseView {
//            setupLocation()
//        }
        Messaging.messaging().delegate = self
        return true
    }
    
    func initSuperApp(){
        let homeVC = AppSettings.shared.isUseFirebase ? SuperFirebaseAppViewController.init() :  SuperAppViewController.init()
        let nav = UINavigationController.init(rootViewController: homeVC)
        nav.isNavigationBarHidden = true
        let leftViewController = menuSuperAppViewController()
                    
                    // 3. Create instance of LGSideMenuController with above controllers as root and left.
        let sideMenuController = LGSideMenuController(rootViewController: nav,
                                                      leftViewController: leftViewController,
                                                      rightViewController: nil)
        
        // 4. Set presentation style by your taste if you don't like the default one.
        sideMenuController.leftViewPresentationStyle = .slideAbove
        //sideMenuController.rootViewBackgroundColor = UIColor.black.withAlphaComponent(0.35)
        //sideMenuController.rootViewCoverColor = UIColor.black.withAlphaComponent(0.35)
        sideMenuController.leftViewWidth = UIScreen.main.bounds.size.width - 80
        sideMenuController.leftViewAnimationDuration = 0.25
        sideMenuController.isLeftViewSwipeGestureEnabled = false
        sideMenuController.leftViewBackgroundColor = .black
        sideMenuController.view.backgroundColor = .black
        //self.window = UIWindow(frame: UIScreen.main.bounds)
        //self.window?.backgroundColor = .white
        
        self.window!.rootViewController = sideMenuController
        self.window!.makeKeyAndVisible()
        UIView.transition(with: self.window!, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    func initFlashSuper(){
        let loginVC = SplashSuperViewController.init()
        let nav = UINavigationController.init(rootViewController: loginVC)
        nav.isNavigationBarHidden = true
        self.window!.rootViewController = nav
        self.window!.makeKeyAndVisible()
        UIView.transition(with: self.window!, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    func initLoginSuper(){
        let loginVC = LoginSuperAppViewController.init()
        let nav = UINavigationController.init(rootViewController: loginVC)
        nav.isNavigationBarHidden = true
        self.window!.rootViewController = nav
        self.window!.makeKeyAndVisible()
        UIView.transition(with: self.window!, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    
    func initLogin(){
        let loginVC = OnboardingViewController.init()
        let nav = UINavigationController.init(rootViewController: loginVC)
        nav.isNavigationBarHidden = true
        self.window!.rootViewController = nav
        self.window!.makeKeyAndVisible()
        UIView.transition(with: self.window!, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    public func rootApp(){
        if ((UserDefaults.standard.value(forKey: USER_ID) as? String) != nil){
            APP_DELEGATE.initTabbar()
        }
        else{
            self.initLogin()
        }
    }
    
    func initTabbar(){
        let homeVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let nav = UINavigationController.init(rootViewController: homeVC)
        nav.isNavigationBarHidden = true
        let leftViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
                    
                    // 3. Create instance of LGSideMenuController with above controllers as root and left.
        let sideMenuController = LGSideMenuController(rootViewController: nav,
                                                      leftViewController: leftViewController,
                                                      rightViewController: nil)
        
        // 4. Set presentation style by your taste if you don't like the default one.
        sideMenuController.leftViewPresentationStyle = .slideAboveBlurred
        //sideMenuController.rootViewBackgroundColor = UIColor.black.withAlphaComponent(0.35)
        //sideMenuController.rootViewCoverColor = UIColor.black.withAlphaComponent(0.35)
        sideMenuController.leftViewWidth = UIScreen.main.bounds.size.width - 80
        sideMenuController.leftViewAnimationDuration = 0.25
        sideMenuController.isLeftViewSwipeGestureEnabled = false
        sideMenuController.view.backgroundColor = .white
        //self.window = UIWindow(frame: UIScreen.main.bounds)
        //self.window?.backgroundColor = .white
        self.window!.rootViewController = sideMenuController
        self.window!.makeKeyAndVisible()
        
        UIView.transition(with: self.window!, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    func setRoot(){
        initFlashSuper()
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        let callbackUrl = URL(string: TwitterConstants.CALLBACK_URL)!
        Swifter.handleOpenURL(url, callbackURL: callbackUrl)
        return true
    }
    
    private func setupKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(MessageStreamViewController.self)
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(CommentViewController.self)
        
        IQKeyboardManager.shared.disabledToolbarClasses.append(MessageStreamViewController.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(BusinessFeedbackViewController.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(CommentViewController.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(CircularTextViewController.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(ZegoUIKitPrebuiltLiveStreamingVC.self)
        IQKeyboardManager.shared.disabledTouchResignedClasses.append(NewFeedbackViewController.self)
        IQKeyboardManager.shared.disabledTouchResignedClasses.append(SearchReviewsViewController.self)
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(ZegoUIKitPrebuiltLiveStreamingVC.self)
    }
    
    public func setupLocation() {
        guard CLLocationManager.locationServicesEnabled() else { return }
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    private func setupToast() {
        ToastManager.shared.position = .top
        ToastManager.shared.duration = 2.0
        var style = ToastStyle()
        style.messageFont = .myriadProRegular(ofSize: 15)
        style.titleAlignment = .center
        ToastManager.shared.style = style
    }
    
    private func registerForPushNotifications(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        print(#function, userActivity.webpageURL as Any)
        return true
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
    
    func updateToken(){
        if let user = UserDefaults.standard.value(forKey: USER_ID) as? String, token != nil{
            let param = ["id": user, "imei": token!]
            ManageAPI.shared.updateTokenSuperApp(param) { success, erro in
                
            }
            
            let param2 = ["id": user]
            APIHelper.shared.signuppush(param2) { success, erro in
                
            }
        }
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
        
       
        var para: Parameters = ["token": accessToken,  "src": "iOS",
                                "src2": "Apple"]
        print(para)
        if let name = fullName {
            para.updateValue(name, forKey: "name")
        }
        if let email = credential.email {
            para.updateValue(email, forKey: "email")
        }
        self.showBusy()
        APIKarkonexHelper.shared.registerSocial(param: para) { success, erro in
            self.hideBusy()
           
            if success!{
                NotificationCenter.default.post(name: Notification.Name("MyNotification"), object: nil)
            }
            else{
                if let err = erro{
                    self.showAlertMessage(message: err)
                }
            }
        }
    }
    func showAlertMessage(message: String)
    {
        let alert = UIAlertController(title: APP_NAME,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Ok",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first {
            let rootViewController = window.rootViewController
            rootViewController?.present(alert, animated: true, completion: nil)
        }
       
    }
    
    //MARK: - FACEBOOK
    func signInWithFacebook() {
       
        let loginManager = LoginManager()
        let permissions = ["public_profile", "email", "user_link"]
        loginManager.logIn(permissions: permissions, from: nil) { (result: LoginManagerLoginResult?, error: Error?) in
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
        APIKarkonexHelper.shared.registerSocial(param: para) { success, erro in
            self.hideBusy()
            if success!{
                NotificationCenter.default.post(name: Notification.Name("MyNotification"), object: nil)
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
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first {
            let rootViewController = window.rootViewController
            GIDSignIn.sharedInstance.signOut()
            GIDSignIn.sharedInstance.signIn(withPresenting: window.rootViewController ?? UIViewController()) { result, error in
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
                APIKarkonexHelper.shared.registerSocial(param: para) { success, erro in
                    self.hideBusy()
                    if success!{
                        NotificationCenter.default.post(name: Notification.Name("MyNotification"), object: nil)
                    }
                    else{
                        
                        if let err = erro{
                            self.showAlertMessage(message: err)
                        }
                    }
                }
            }
        }
        
        
     
    }
    
    func isCheckLogin()-> Bool{
        if UserDefaults.standard.value(forKey: USER_ID_RR) != nil{
            return true
        }
        else{
            return false
        }
    }
    
    
    func initHome()
    {
        let homeVC = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "HomeShowCaseViewController") as! HomeShowCaseViewController
        let nav = UINavigationController.init(rootViewController: homeVC)
        nav.isNavigationBarHidden = true
        let leftViewController = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        let navLeft = UINavigationController.init(rootViewController: leftViewController)
        // 3. Create instance of LGSideMenuController with above controllers as root and left.
        let sideMenuController = LGSideMenuController(rootViewController: nav,
                                                      leftViewController: navLeft,
                                                      rightViewController: nil)
        
        // 4. Set presentation style by your taste if you don't like the default one.
        sideMenuController.leftViewPresentationStyle = .slideAboveBlurred
        //sideMenuController.rootViewBackgroundColor = UIColor.black.withAlphaComponent(0.35)
        sideMenuController.rootViewCoverColor = UIColor.black.withAlphaComponent(0.35)
        // 5. Set width for the left view if you don't like the default one.
        sideMenuController.leftViewWidth = 280.0
        sideMenuController.leftViewAnimationDuration = 0.25
        sideMenuController.isLeftViewSwipeGestureEnabled = true
        sideMenuController.view.backgroundColor = .clear
        //self.window = UIWindow(frame: UIScreen.main.bounds)
        //self.window?.backgroundColor = .white
        self.window!.rootViewController = sideMenuController
        self.window!.makeKeyAndVisible()
        
        UIView.transition(with: self.window!, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    func initLoginRR()
    {
        let homeVC = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let nav = UINavigationController.init(rootViewController: homeVC)
        nav.isNavigationBarHidden = true
        self.window!.rootViewController = nav
        self.window!.makeKeyAndVisible()
        
        UIView.transition(with: self.window!, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    func initShowCase()
    {
        let homeVC = OnboardingRRViewController.init(nibName: "OnboardingRRViewController", bundle: nil)
        let nav = UINavigationController.init(rootViewController: homeVC)
        nav.isNavigationBarHidden = true
        self.window!.rootViewController = nav
        self.window!.makeKeyAndVisible()
        
        UIView.transition(with: self.window!, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
}

extension AppDelegate: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            self.signInWithApple(credential: appleIDCredential)
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
        //self.showAlertMessage(message: error.localizedDescription)
    }
}

extension AppDelegate: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first?.rootViewController?.view as! ASPresentationAnchor
    }
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("fcmToken =", fcmToken as Any)
        AppSettings.shared.token = fcmToken
        AppSettings.shared.updateToken()
        
        self.token = fcmToken
        self.isSendPushNotification = true
        self.updateToken()
        
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        if #available(iOS 14.0, *) {
            completionHandler(.banner)
        } else {
            completionHandler(.sound)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        completionHandler()
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locations.last else {return}
        print("Location: \(location)")
        AppSettings.shared.currentLocation = location
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
}
