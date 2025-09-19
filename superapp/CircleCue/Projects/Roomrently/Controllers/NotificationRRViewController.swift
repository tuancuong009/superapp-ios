//
//  NotificationViewController.swift
//  Roomrently
//
//  Created by QTS Coder on 04/01/2024.
//

import UIKit
import LGSideMenuController
class NotificationRRViewController: BaseRRViewController {
    
    @IBOutlet weak var tblNotifications: UITableView!
    @IBOutlet weak var lblNoNotifications: UILabel!
    
    var arrMessages = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblNotifications.isHidden = true
        lblNoNotifications.isHidden = true
        tblNotifications.register(UINib.init(nibName: "NotificationRRTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationRRTableViewCell")
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func doMenuApp(_ sender: Any) {
        self.sideMenuController?.showLeftView(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getMessages()
    }
    @IBAction func doBack(_ sender: Any) {
        self.sideMenuController?.showLeftView(animated: true)
    }
    
    private func getMessages(_ isLoading: Bool = true){
        guard let id = UserDefaults.standard.value(forKey: USER_ID_RR) as? String else{
            return
        }
        if isLoading{
            
            self.showBusy()
        }
        APIRoomrentlyHelper.shared.getNotifications(id) { success, dict in
            self.hideBusy()
            self.arrMessages.removeAll()
            if let dict = dict {
                self.arrMessages = dict
            }
            if self.arrMessages.count == 0{
                self.tblNotifications.isHidden = true
                self.lblNoNotifications.isHidden = false
            }
            else{
                self.tblNotifications.isHidden = false
                self.lblNoNotifications.isHidden = true
            }
            self.tblNotifications.reloadData()
        }
    }
}
extension NotificationRRViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMessages.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblNotifications.dequeueReusableCell(withIdentifier: "NotificationRRTableViewCell") as! NotificationRRTableViewCell
       cell.configCell(self.arrMessages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.arrMessages[indexPath.row]
        if let id = dict.object(forKey: "id") as? String,let seen = dict.object(forKey: "seen") as? String, let intseen = Int(seen), intseen == 0{
            if let cell = tblNotifications.cellForRow(at: indexPath) as? NotificationRRTableViewCell{
                cell.icRead.isHidden = true
                cell.lblContent.font = UIFont(name: "Poppins-Regular", size: 14)
                cell.spaceRight.constant = 20
            }
            APIRoomrentlyHelper.shared.seenNotification(id) { success, erro in
                self.getMessages(false)
                APP_DELEGATE.menuVC?.getMessages()
            }
            
        }
        if let sid = dict.object(forKey: "sid") as? String{
            let vc = MyProfileUserVC()
             vc.profileID = sid
            vc.idBook = ""
             self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.showAlertMessageAction("Are you sure you want to delete?") { success in
                if success{
                    let dict = self.arrMessages[indexPath.row]
                    if let id = dict.object(forKey: "id") as? String{
                        self.showBusy()
                        APIRoomrentlyHelper.shared.deleteNotification(id) { success, erro in
                            self.hideBusy()
                            self.arrMessages.remove(at: indexPath.row)
                            self.tblNotifications.reloadData()
                            APP_DELEGATE.menuVC?.getMessages()
                        }
                    }
                }
            }
        }
    }
}



