//
//  MessageSuperViewController.swift
//  SuperApp
//
//  Created by QTS Coder on 13/5/25.
//

import UIKit

import LGSideMenuController
class MessageSuperViewController: BaseViewController {

    @IBOutlet weak var lblNoMessage: UILabel!
    @IBOutlet weak var tblNotifications: UITableView!
    private var messages: [MessageDashboard] = [] {
        didSet {
            lblNoMessage.isHidden = !messages.isEmpty
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNoMessage.text = "No messages yet"
        lblNoMessage.isHidden = true
        tblNotifications.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCell")
        showSimpleHUD()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMessageList()
    }

    private func fetchMessageList() {
        guard let userId = UserDefaults.standard.value(forKey: USER_ID_SUPER_APP)  as? String else { return }
        
        ManageAPI.shared.fetchUserMessageSupperApps(userId) {[weak self] (results) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                self.messages = results.filter({ $0.id.isEmpty == false })
                self.tblNotifications.reloadData()
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
    @IBAction func doMenu(_ sender: Any) {
        self.sideMenuController?.showLeftView()
    }
    
}

extension MessageSuperViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblNotifications.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as! MessageTableViewCell
        cell.setup(message: messages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblNotifications.deselectRow(at: indexPath, animated: true)
        let messageObj =  messages[indexPath.row]
        let vc = SendMessageSuperVC.init()
        vc.profileID = messageObj.value
        vc.profileName = messageObj.username
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
