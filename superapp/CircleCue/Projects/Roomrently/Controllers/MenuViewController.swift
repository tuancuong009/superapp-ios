//
//  MenuViewController.swift
//  Shereef Homes
//
//  Created by QTS Coder on 08/08/2023.
//

import UIKit
import SafariServices
import MessageUI
class MenuViewController: BaseRRViewController {
    
    @IBOutlet weak var tblMenus: UITableView!
    var arrMenus = [MENU_RR]()
    var countNotificaiton = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrMenus = [.Home, .Search, .MyProfile, .MyProperty, .MyInquiry, .Wanted, .Notifications, .Messages, .PartnerApps, .ContactUs, .Logout]
        if let user = UserDefaults.standard.value(forKey: USER_ID_RR) as? String{
            print(user)
            getMessages()
        }
        APP_DELEGATE.menuVC = self
        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func doCC(_ sender: Any) {
        self.openLink(LINK_URL.URL_CC)
    }
    
    @IBAction func doIs(_ sender: Any) {
        self.openLink(LINK_URL.URL_IS)
    }
    @IBAction func doPhone(_ sender: Any) {
        //1-833-SHEREEF (1-833-743-7333)
        if let url = URL(string: "tel://1833-773-6859"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func openLinkBlog(){
        let vc = SFSafariViewController(url: URL.init(string: LINK_URL.URL_BLOG)!)
        self.present(vc, animated: true)
    }
    
    func getMessages(){
        guard let id = UserDefaults.standard.value(forKey: USER_ID_RR) as? String else{
            return
        }
        self.countNotificaiton = 0
        APIRoomrentlyHelper.shared.getNotifications(id) { success, dict in
            self.hideBusy()
            if let dict = dict {
                for dictionary in dict {
                    if let seen = dictionary.object(forKey: "seen") as? String, let intseen = Int(seen), intseen == 0{
                        self.countNotificaiton = self.countNotificaiton + 1
                    }
                }
            }
            self.tblMenus.reloadData()
        }
    }
}


extension MenuViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenus.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblMenus.dequeueReusableCell(withIdentifier: "MenuTableViewRRCell") as! MenuTableViewRRCell
        cell.lblName.text = arrMenus[indexPath.row].rawValue
        if arrMenus[indexPath.row] == .Notifications && countNotificaiton > 0{
            cell.lblNotification.text = "\(countNotificaiton)"
            cell.lblNotification.isHidden = false
        }
        else{
            cell.lblNotification.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblMenus.deselectRow(at: indexPath, animated: true)
        self.showRedirectUserLogin(arrMenus[indexPath.row])
    }
    func showRedirectUserLogin(_ menu: MENU_RR){
        switch menu {
        case .Home:
            let mainViewController = sideMenuController!
            mainViewController.hideLeftView(animated: true) {
                if let homeVC = APP_DELEGATE.homeViewController, let nav = homeVC.navigationController{
                    let detailVC = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "HomeShowCaseViewController") as! HomeShowCaseViewController
                    nav.setViewControllers([detailVC], animated: false)
                    UIView.transition(with: nav.view,
                                      duration: self.sideMenuController!.leftViewAnimationDuration,
                                      options: [.transitionCrossDissolve],
                                      animations: nil)
                }
                
            }
            break
        case .Search:
            let mainViewController = sideMenuController!
            mainViewController.hideLeftView(animated: true) {
                if let homeVC = APP_DELEGATE.homeViewController, let nav = homeVC.navigationController{
                    let detailVC = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "SearchRRViewController") as! SearchRRViewController
                    nav.setViewControllers([detailVC], animated: false)
                    UIView.transition(with: nav.view,
                                      duration: self.sideMenuController!.leftViewAnimationDuration,
                                      options: [.transitionCrossDissolve],
                                      animations: nil)
                }
                
            }
            break
        case .Wanted:
            let mainViewController = sideMenuController!
            mainViewController.hideLeftView(animated: true) {
                if let homeVC = APP_DELEGATE.homeViewController, let nav = homeVC.navigationController{
                    let detailVC = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "WantedVC") as! WantedVC
                    nav.setViewControllers([detailVC], animated: false)
                    UIView.transition(with: nav.view,
                                      duration: self.sideMenuController!.leftViewAnimationDuration,
                                      options: [.transitionCrossDissolve],
                                      animations: nil)
                }
                
            }
            break
        case .MyProfile:
            let mainViewController = sideMenuController!
            mainViewController.hideLeftView(animated: true) {
                if let homeVC = APP_DELEGATE.homeViewController, let nav = homeVC.navigationController{
                    let detailVC = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "MyProfileRRViewController") as! MyProfileRRViewController
                    nav.setViewControllers([detailVC], animated: false)
                    UIView.transition(with: nav.view,
                                      duration: self.sideMenuController!.leftViewAnimationDuration,
                                      options: [.transitionCrossDissolve],
                                      animations: nil)
                }
                
            }
            break
        case .MyProperty:
            let mainViewController = sideMenuController!
            mainViewController.hideLeftView(animated: true) {
                if let homeVC = APP_DELEGATE.homeViewController, let nav = homeVC.navigationController{
                    let detailVC = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "MyPropertyViewController") as! MyPropertyViewController
                    nav.setViewControllers([detailVC], animated: false)
                    UIView.transition(with: nav.view,
                                      duration: self.sideMenuController!.leftViewAnimationDuration,
                                      options: [.transitionCrossDissolve],
                                      animations: nil)
                }
            }
            break
        case .MyInquiry:
            let mainViewController = sideMenuController!
            mainViewController.hideLeftView(animated: true) {
                if let homeVC = APP_DELEGATE.homeViewController, let nav = homeVC.navigationController{
                    let detailVC = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "InquiryViewController") as! InquiryViewController
                    nav.setViewControllers([detailVC], animated: false)
                    UIView.transition(with: nav.view,
                                      duration: self.sideMenuController!.leftViewAnimationDuration,
                                      options: [.transitionCrossDissolve],
                                      animations: nil)
                }
                
            }
            break
        case .Messages:
            let mainViewController = sideMenuController!
            mainViewController.hideLeftView(animated: true) {
                if let homeVC = APP_DELEGATE.homeViewController, let nav = homeVC.navigationController{
                    let detailVC = MessageRRViewController.init(nibName: "MessageRRViewController", bundle: nil)
                    nav.setViewControllers([detailVC], animated: false)
                    UIView.transition(with: nav.view,
                                      duration: self.sideMenuController!.leftViewAnimationDuration,
                                      options: [.transitionCrossDissolve],
                                      animations: nil)
                }
                
            }
            break
        case .Logout:
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
                UserDefaults.standard.removeObject(forKey: USER_ID_RR)
                APP_DELEGATE.initShowCase()
            }
            alert.addAction(delete)
            self.present(alert, animated: true, completion: nil)
            break
       
        case .ContactUs:
            let mainViewController = sideMenuController!
            mainViewController.hideLeftView(animated: true) {
                if let homeVC = APP_DELEGATE.homeViewController, let nav = homeVC.navigationController{
                    let detailVC = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
                    nav.setViewControllers([detailVC], animated: false)
                    UIView.transition(with: nav.view,
                                      duration: self.sideMenuController!.leftViewAnimationDuration,
                                      options: [.transitionCrossDissolve],
                                      animations: nil)
                }
                
            }
            break
        case .Blog:
            let mainViewController = sideMenuController!
            mainViewController.hideLeftView(animated: true) {
                self.openLink(LINK_URL.URL_BLOG)
            }
            break
        case .Notifications:
            let mainViewController = sideMenuController!
            mainViewController.hideLeftView(animated: true) {
                if let homeVC = APP_DELEGATE.homeViewController, let nav = homeVC.navigationController{
                    let detailVC = NotificationRRViewController.init(nibName: "NotificationRRViewController", bundle: nil)
                    nav.setViewControllers([detailVC], animated: false)
                    UIView.transition(with: nav.view,
                                      duration: self.sideMenuController!.leftViewAnimationDuration,
                                      options: [.transitionCrossDissolve],
                                      animations: nil)
                }
            }
            break
        case .PartnerApps:
            let mainViewController = sideMenuController!
            mainViewController.hideLeftView(animated: true) {
                if let homeVC = APP_DELEGATE.homeViewController, let nav = homeVC.navigationController{
                    let detailVC = AppMomarViewController.init()
                    detailVC.isMenu = true
                    nav.setViewControllers([detailVC], animated: false)
                    UIView.transition(with: nav.view,
                                      duration: self.sideMenuController!.leftViewAnimationDuration,
                                      options: [.transitionCrossDissolve],
                                      animations: nil)
                }
            }
            break
        default:
            break
        }
    }
    
  
    
    private func openLink(_ link: String){
        let vc = SFSafariViewController.init(url: URL.init(string: link)!)
        self.present(vc, animated: true)
    }
}
