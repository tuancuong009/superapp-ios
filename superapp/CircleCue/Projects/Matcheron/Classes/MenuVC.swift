//
//  MenuVC.swift
//  Matcheron
//
//  Created by QTS Coder on 6/9/24.
//

import UIKit
import LGSideMenuController
import SafariServices
class MenuVC: BaseMatcheronViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doCC(_ sender: Any) {
        self.showOutsideAppWebContent(urlString: "https://www.circlecue.com/matcheron")
    }
    @IBAction func doIS(_ sender: Any) {
        self.showOutsideAppWebContent(urlString: "https://www.instagram.com/mymatcheron?igsh=b2d1NXM2NG02MjJ6")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doParterApp(_ sender: Any) {
        let mainViewController = sideMenuController!
        if let nav = mainViewController.rootViewController as? UINavigationController{
            let vc = AppMomarViewController.init()
            nav.setViewControllers([vc], animated: false)
            mainViewController.hideLeftView(animated: true) {
            }
        }
    }
    @IBAction func doLiked(_ sender: Any) {
        let mainViewController = sideMenuController!
        if let nav = mainViewController.rootViewController as? UINavigationController{
            let vc = LikedViewController.init()
            vc.isLiked = true
            nav.setViewControllers([vc], animated: false)
            mainViewController.hideLeftView(animated: true) {
            }
        }
    }
    @IBAction func doQA(_ sender: Any) {
        let mainViewController = sideMenuController!
        mainViewController.hideLeftView(animated: true) {
            if let url = URL.init(string: URL_APP.URL_QA){
                let vc = SFSafariViewController(url: url)
                self.present(vc, animated: true)
            }
        }
    }
    @IBAction func doHome(_ sender: Any) {
        let mainViewController = sideMenuController!
        if let nav = mainViewController.rootViewController as? UINavigationController{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            nav.setViewControllers([vc], animated: false)
            mainViewController.hideLeftView(animated: true) {
            }
        }
    }
    @IBAction func doNotifications(_ sender: Any) {
        let mainViewController = sideMenuController!
        if let nav = mainViewController.rootViewController as? UINavigationController{
            let vc = NotificationViewController.init()
            nav.setViewControllers([vc], animated: false)
            mainViewController.hideLeftView(animated: true) {
            }
        }
    }
    @IBAction func doMessages(_ sender: Any) {
        let mainViewController = sideMenuController!
        if let nav = mainViewController.rootViewController as? UINavigationController{
            let vc = MessageViewController.init()
            nav.setViewControllers([vc], animated: false)
            mainViewController.hideLeftView(animated: true) {
            }
        }
    }
 
    @IBAction func doDeleteAccount(_ sender: Any) {
        self.showAlertMessageAction("Deleting your account will remove all of your information from our database. This cannot be undone.") { success in
            if success{
                self.apiDeleteUser(UserDefaults.standard.value(forKey: USER_PASSWORD) as? String ?? "")
                //self.showAlertFormPassword()
            }
        }
    }
    @IBAction func doMixerss(_ sender: Any) {
        let mainViewController = sideMenuController!
        if let nav = mainViewController.rootViewController as? UINavigationController{
            let vc = MixerViewController.init()
            nav.setViewControllers([vc], animated: false)
            mainViewController.hideLeftView(animated: true) {
            }
        }
    }
    
    
    @IBAction func doSearch(_ sender: Any) {
        let mainViewController = sideMenuController!
        if let nav = mainViewController.rootViewController as? UINavigationController{
            let vc = SearchViewController.init()
            nav.setViewControllers([vc], animated: false)
            mainViewController.hideLeftView(animated: true) {
            }
        }
       
    }
    
    @IBAction func doWarning(_ sender: Any) {
        let mainViewController = sideMenuController!
        if let nav = mainViewController.rootViewController as? UINavigationController{
            let vc = HelpViewController.init()
            nav.setViewControllers([vc], animated: false)
            mainViewController.hideLeftView(animated: true) {
            }
        }
    }
    @IBAction func doLogout(_ sender: Any) {
        self.showAlertMessageAction("Do you want to logout?") { success in
            if success{
                APP_DELEGATE.isSendPushNotification = false
                UserDefaults.standard.removeObject(forKey: USER_ID)
                UserDefaults.standard.synchronize()
                APP_DELEGATE.initLogin()
            }
        }
    }
    @IBAction func doProfile(_ sender: Any) {
        let mainViewController = sideMenuController!
        if let nav = mainViewController.rootViewController as? UINavigationController{
            let vc = MyProfileMatcheronViewController.init()
            nav.setViewControllers([vc], animated: false)
            mainViewController.hideLeftView(animated: true) {
            }
        }
    }
    @IBAction func doFav(_ sender: Any) {
        let mainViewController = sideMenuController!
        if let nav = mainViewController.rootViewController as? UINavigationController{
            let vc = ShowCaseViewController.init()
            nav.setViewControllers([vc], animated: false)
            mainViewController.hideLeftView(animated: true) {
            }
        }
    }
    @IBAction func doMayBe(_ sender: Any) {
        let mainViewController = sideMenuController!
        if let nav = mainViewController.rootViewController as? UINavigationController{
            let vc = MaybeViewController.init()
            nav.setViewControllers([vc], animated: false)
            mainViewController.hideLeftView(animated: true) {
            }
        }
    }
    @IBAction func doLike(_ sender: Any) {
        let mainViewController = sideMenuController!
        if let nav = mainViewController.rootViewController as? UINavigationController{
            let vc = LikedViewController.init()
            nav.setViewControllers([vc], animated: false)
            mainViewController.hideLeftView(animated: true) {
            }
        }
    }
    
    @IBAction func doContactUs(_ sender: Any) {
        let mainViewController = sideMenuController!
        if let nav = mainViewController.rootViewController as? UINavigationController{
            let vc = ContactUsViewController.init()
            nav.setViewControllers([vc], animated: false)
            mainViewController.hideLeftView(animated: true) {
            }
        }
    }
    private func showAlertFormPassword(){
      
        let alertController = UIAlertController(title: "Please enter the password to delete your account", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Password"
        }
        let saveAction = UIAlertAction(title: "Submit", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            if firstTextField.text!.isEmpty{
                return
            }
            self.apiDeleteUser(firstTextField.text!)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action : UIAlertAction!) -> Void in })
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func apiDeleteUser(_ password: String){
        let userID = UserDefaults.standard.value(forKey: USER_ID) as? String ?? ""
        let param = ["id": userID, "password": password]
        self.showBusy()
        APIHelper.shared.deleteUser(param) { success, erro in
            self.hideBusy()
            if success!{
                self.showAlertMessageComback("Your account has been deleted successfully.") { success in
                    APP_DELEGATE.isSendPushNotification = false
                    UserDefaults.standard.removeObject(forKey: USER_ID)
                    UserDefaults.standard.synchronize()
                    APP_DELEGATE.initLogin()
                }
                
            }
            else{
                self.showAlertMessage(message: erro ?? "")
            }
        }
    }
    @IBAction func doMarking(_ sender: Any) {
        let mainViewController = sideMenuController!
        if let nav = mainViewController.rootViewController as? UINavigationController{
            let vc = MatchMarkingViewController.init()
            nav.setViewControllers([vc], animated: false)
            mainViewController.hideLeftView(animated: true) {
            }
        }
    }
}
