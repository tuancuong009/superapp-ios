//
//  MessageViewController.swift
//  Matcheron
//
//  Created by QTS Coder on 2/10/24.
//

import UIKit
import LGSideMenuController
import SDWebImage
class MessageMatcheronViewController: BaseMatcheronViewController {
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var tblMessages: UITableView!
    var arrMessages = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMessages.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCell")
        lblNoData.isHidden = true
       
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.callApi()
    }
    private func callApi(){
        self.showBusy()
        let userID = UserDefaults.standard.value(forKey: USER_ID) as? String ?? ""
        APIHelper.shared.getMessages(id: userID) { success, dict in
            self.arrMessages.removeAll()
            self.hideBusy()
            if let dict = dict{
                self.arrMessages = dict
                self.tblMessages.reloadData()
            }
            self.lblNoData.isHidden = self.arrMessages.count == 0 ? false : true
        }
    }
    @IBAction func doBack(_ sender: Any) {
        self.sideMenuController?.showLeftView(animated: true)
    }
    
    
}

extension MessageMatcheronViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMessages.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as! MessageTableViewCell
        let object = self.arrMessages[indexPath.row]
        cell.lblName.text = object.object(forKey: "username") as? String
        cell.lblMessage.text = object.object(forKey: "msg") as? String
        if let img1 = object.object(forKey: "pic") as? String{
            cell.imgAvatar.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgAvatar.sd_setImage(with: URL.init(string: img1)) { image1, errr, type, url in
                
            }
        }
        let userID = UserDefaults.standard.value(forKey: USER_ID) as? String ?? ""
        let sender_id = object.object(forKey: "sender_id") as? String ?? ""
        var sender: MessageSender {
            return sender_id == userID ? .me : .friend
        }
        var statusR: ReadMessageStatus = .sent
        if let readstatus = object.value(forKey: "readstatus") as? String, let status = ReadMessageStatus(rawValue: readstatus) {
            switch sender {
            case .me:
                statusR = status
            case .friend:
                statusR = .read
            }
        }
        
        cell.icRead.setDeliveryImage(statusR)
        if let time = object.object(forKey: "time") as? String{
            cell.lblTime.text = self.formatTimeAgo(time)
        }
        else{
            cell.lblTime.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let object = self.arrMessages[indexPath.row]
        let vc = SendMessageVC()
        vc.profileID = object.object(forKey: "id2") as? String ?? ""
        vc.profileName =  object.object(forKey: "username") as? String ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func formatTimeAgo(_ strDate: String)-> String{
        let format = DateFormatter.init()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        format.timeZone = TimeZone(abbreviation: "EST")
        //format.locale = self.getPreferredLocale()
        if let dateS = format.date(from: strDate){
            print(dateS)
            return DateHelper.timeAgoTwoDate(dateS)
        }
        return ""
    }
    
    func getPreferredLocale() -> Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }
    
    private func dateTimeCreateMessage()-> String{
        let format = DateFormatter.init()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        format.locale = self.getPreferredLocale()
        return format.string(from: Date())
    }
    
}
