//
//  AppDelegate.swift
//  Matcheron
//
//  Created by QTS Coder on 6/9/24.
//

import UIKit
import IQKeyboardManagerSwift
import LGSideMenuController
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import SDWebImage
import FBSDKCoreKit
import GoogleSignIn
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var token: String?
    var user: NSDictionary?
    var isSendPushNotification = false
    var messageAll = [MessageObj]()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        sleep(2)
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        //SDImageCache.shared.clearMemory()
        //SDImageCache.shared.clearDisk()
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.disabledToolbarClasses = [SendMessageViewController.self]
        self.registerNotification(application)
        self.rootApp()
        Messaging.messaging().delegate = self
       
     
        return true
    }
    
    public func rootApp(){
        if ((UserDefaults.standard.value(forKey: USER_ID) as? String) != nil){
            APP_DELEGATE.initTabbar()
        }
        else{
            self.initLogin()
        }
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
       
        return true
    }
    private func registerNotification(_ application: UIApplication){
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
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
    
    func initLogin(){
        let loginVC = OnboardingViewController.init()
        let nav = UINavigationController.init(rootViewController: loginVC)
        nav.isNavigationBarHidden = true
        self.window!.rootViewController = nav
        self.window!.makeKeyAndVisible()
        UIView.transition(with: self.window!, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
    
    func updateToken(){
        if let user = UserDefaults.standard.value(forKey: USER_ID) as? String, token != nil{
            let param = ["id": user, "imei": token!]
            APIHelper.shared.updateToken(param) { success, erro in
                
            }
            
            let param2 = ["id": user]
            APIHelper.shared.signuppush(param2) { success, erro in
                
            }
        }
    }
}

extension AppDelegate: MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        self.token = fcmToken
        self.isSendPushNotification = true
        self.updateToken()
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    // [END refresh_token]
}
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        
        // Change this to your preferred presentation option
        return [ [.sound]]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        if let user = UserDefaults.standard.value(forKey: USER_ID) as? String
        {
            print("User--->",user)
        }
    }
    
    
}
