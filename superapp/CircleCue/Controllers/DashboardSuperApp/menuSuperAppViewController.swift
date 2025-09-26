//
//  menuSuperAppViewController.swift
//  SuperApp
//
//  Created by QTS Coder on 20/3/25.
//

import UIKit
import LGSideMenuController
import FirebaseAuth
class menuSuperAppViewController: BaseViewController {

    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnSubmitApp: UIButton!
    @IBOutlet weak var btnInvest: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnApps: UIButton!
    @IBOutlet weak var btnHidden: UIButton!
    @IBOutlet weak var btnMyApps: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
       
    }


    private func setupUI(){
        if let userID = UserDefaults.standard.value(forKey: USER_ID_SUPER_APP) as? String{
            print(userID)
            btnLogout.isHidden = false
            
        }
        else{
            btnLogout.isHidden = true
        }
        
        if AppSettings.shared.isUseFirebase{
            btnProfile.isHidden = false
            btnApps.isHidden = true
            btnHidden.isHidden = true
            btnSubmitApp.isHidden = true
            btnInvest.isHidden = true
            btnMyApps.setTitle("My IDEAs", for: .normal)
            btnLogin.isHidden = true
        }
        else{
            btnProfile.isHidden = true
            btnApps.isHidden = false
            btnHidden.isHidden = false
            btnSubmitApp.isHidden = false
            btnInvest.isHidden = false
            if let userID = UserDefaults.standard.value(forKey: USER_ID_SUPER_APP) as? String{
                print(userID)
                btnLogin.isHidden = true
                
            }
            else{
                btnLogin.isHidden = false
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doMessageApp(_ sender: Any) {
        
        if let userID = UserDefaults.standard.value(forKey: USER_ID_SUPER_APP) as? String{
            print(userID)
          
            let mainViewController = sideMenuController!
            if let nav = mainViewController.rootViewController as? UINavigationController{
                let vc = MessageSuperViewController.init()
                nav.setViewControllers([vc], animated: false)
                mainViewController.hideLeftView(animated: true) {
                }
            }
            
        }
        else{
            let vc = LoginSuperAppViewController.init()
            let nav = UINavigationController(rootViewController: vc)
            nav.isNavigationBarHidden = true
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
        
    }
    @IBAction func doNotifications(_ sender: Any) {
        if let userID = UserDefaults.standard.value(forKey: USER_ID_SUPER_APP) as? String{
            print(userID)
            let mainViewController = sideMenuController!
            if let nav = mainViewController.rootViewController as? UINavigationController{
                let vc = NotificationSuperViewController.init()
                nav.setViewControllers([vc], animated: false)
                mainViewController.hideLeftView(animated: true) {
                }
            }
            
        }
        else{
            let vc = LoginSuperAppViewController.init()
            let nav = UINavigationController(rootViewController: vc)
            nav.isNavigationBarHidden = true
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
        
       
    }
    @IBAction func doMyApps(_ sender: Any) {
        if let userID = UserDefaults.standard.value(forKey: USER_ID_SUPER_APP) as? String{
            print(userID)
          
            
            let mainViewController = sideMenuController!
            if let nav = mainViewController.rootViewController as? UINavigationController{
                let vc = MyAppsViewController.init()
                nav.setViewControllers([vc], animated: false)
                mainViewController.hideLeftView(animated: true) {
                }
            }
        }
        else{
            let vc = LoginSuperAppViewController.init()
            let nav = UINavigationController(rootViewController: vc)
            nav.isNavigationBarHidden = true
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    @IBAction func doHome(_ sender: Any) {
        let mainViewController = sideMenuController!
        if let nav = mainViewController.rootViewController as? UINavigationController{
            let vc = AppSettings.shared.isUseFirebase ? SuperFirebaseAppViewController.init() : SuperAppViewController.init()
            nav.setViewControllers([vc], animated: false)
            mainViewController.hideLeftView(animated: true) {
            }
        }
    }
    
    @IBAction func doApp(_ sender: Any) {
        let mainViewController = sideMenuController!
        if let nav = mainViewController.rootViewController as? UINavigationController{
            let vc = AppsMenuViewController.init()
            nav.setViewControllers([vc], animated: false)
            mainViewController.hideLeftView(animated: true) {
            }
        }
    }
    @IBAction func doVision(_ sender: Any) {
       
        self.showOutsideAppWebContent(urlString: "https://www.superapp.app/vision.php")
    }
    @IBAction func doSubmitApp(_ sender: Any) {
        self.showOutsideAppWebContent(urlString: "https://www.superapp.app/submitapp.php")
    }
    @IBAction func doMessage(_ sender: Any) {
        let mainViewController = sideMenuController!
        if let nav = mainViewController.rootViewController as? UINavigationController{
            let vc = AppSuperViewController.init()
            vc.navi = .messages
            nav.setViewControllers([vc], animated: false)
            mainViewController.hideLeftView(animated: true) {
            }
        }
    }
    @IBAction func doHidden(_ sender: Any) {
        let mainViewController = sideMenuController!
        if let nav = mainViewController.rootViewController as? UINavigationController{
            let vc = HiddenSuperViewController.init()
            nav.setViewControllers([vc], animated: false)
            mainViewController.hideLeftView(animated: true) {
            }
        }
    }
    @IBAction func doLogin(_ sender: Any) {
        let vc = LoginSuperAppViewController.init()
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    @IBAction func doCategory(_ sender: Any) {
        self.showWebViewContent(urlString: "https://superapp.app/html/categories.php")
    }
    
    @IBAction func doQA(_ sender: Any) {
        self.showOutsideAppWebContent(urlString: "https://www.superapp.app/faqs.php")
    }
    @IBAction func doContactUs(_ sender: Any) {
        self.showOutsideAppWebContent(urlString: "https://www.superapp.app/contact.php")
    }
    @IBAction func doInest(_ sender: Any) {
        self.showOutsideAppWebContent(urlString: "https://superapp.app/invest.php")
    }
    @IBAction func doPrivacy(_ sender: Any) {
        self.showOutsideAppWebContent(urlString: "https://superapp.app/privacy.php")
    }
    @IBAction func doSignUp(_ sender: Any) {
        let mainViewController = sideMenuController!
        if let nav = mainViewController.rootViewController as? UINavigationController{
            let vc = ProfileFirebaseViewController.init()
            nav.setViewControllers([vc], animated: false)
            mainViewController.hideLeftView(animated: true) {
            }
        }
    }
    @IBAction func doLogout(_ sender: Any) {
        var style = UIAlertController.Style.actionSheet
        if DEVICE_IPAD{
            style = UIAlertController.Style.alert
        }
        let alert = UIAlertController(title: APP_NAME,
                                      message: "Are you sure you want to logout?",
                                      preferredStyle: style)
        let cancelAction = UIAlertAction(title: "No",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        let delete = UIAlertAction.init(title: "Yes", style: .default) { action in
            UserDefaults.standard.removeObject(forKey: USER_ID_SUPER_APP)
            if AppSettings.shared.isUseFirebase{
                do {
                    try Auth.auth().signOut()
                    APP_DELEGATE.initLoginSuper()
                    print("✅ Logout")
                } catch let error {
                    print("❌ Fail: \(error.localizedDescription)")
                }
            }
            else{
                
                self.setupUI()
            }
            
        }
        alert.addAction(delete)
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func doDeleteAccount(_ sender: Any) {
    }
    

}
