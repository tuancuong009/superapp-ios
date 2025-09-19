//
//  MessageViewController.swift
//  MuslimMMM
//
//  Created by QTS Coder on 28/11/2022.
//

import UIKit
import LGSideMenuController
class MessageRRViewController: BaseRRViewController {

    @IBOutlet weak var tblMessage: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    var arrMessages = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMessage.isHidden = true
        lblNoData.isHidden = true
        tblMessage.register(UINib.init(nibName: "MessageRRTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCell")
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getMessages()
    }
    @IBAction func doBack(_ sender: Any) {
        self.sideMenuController?.showLeftView(animated: true)
    }
    
    private func getMessages(){
        guard let id = UserDefaults.standard.value(forKey: USER_ID_RR) as? String else{
            return
        }
        self.showBusy()
        APIRoomrentlyHelper.shared.getMessages(id) { success, dict in
            self.hideBusy()
            self.arrMessages.removeAll()
            if let dict = dict {
                self.arrMessages = dict
            }
            if self.arrMessages.count == 0{
                self.tblMessage.isHidden = true
                self.lblNoData.isHidden = false
            }
            else{
                self.tblMessage.isHidden = false
                self.lblNoData.isHidden = true
            }
            self.tblMessage.reloadData()
        }
    }
}
extension MessageRRViewController: UITableViewDataSource, UITableViewDelegate{
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
        let cell = self.tblMessage.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as! MessageRRTableViewCell
        cell.configCell(self.arrMessages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.arrMessages[indexPath.row]
        self.tblMessage.deselectRow(at: indexPath, animated: true)
        let vc = SendMessageVC.init()
        vc.profileID = dict.object(forKey: "value") as? String ?? ""
        vc.profileName = dict.object(forKey: "username") as? String ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete{
//            self.showAlertMessageAction("Are you sure you want to delete message?") { success in
//                if success{
//                    self.showBusy()
//                    let dict = self.arrMessages[indexPath.row]
//                    APIRoomrentlyHelper.shared.deleteMessage( dict.object(forKey: "iid") as? String ?? "") { success, erro in
//                        self.hideBusy()
//                        if success!{
//                            self.arrMessages.remove(at: indexPath.row)
//                            self.tblMessage.deleteRows(at: [indexPath], with: .left)
//                            self.tblMessage.reloadData()
//                        }
//                        else{
//                            self.showAlertMessage(message: erro ?? "")
//                        }
//                    }
//                }
//            }
//           
//        }
//    }
}
