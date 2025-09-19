//
//  SendMessageVC.swift
//  MuslimMMM
//
//  Created by QTS Coder on 30/11/2022.
//

import UIKit
import IQKeyboardManagerSwift
class SendMessageRRVC: BaseRRViewController {
    
    @IBOutlet weak var tblMessage: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txfMessage: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var spaceForm: NSLayoutConstraint!
    var profileID: String = ""
    var profileName = ""
    var arrMessages = [MessageObj]()
    var messageDefault: String = ""
    var idDetailSearch = false
    override func viewDidLoad() {
        super.viewDidLoad()
     
        tblMessage.register(UINib.init(nibName: "LeftTableViewRRCell", bundle: nil), forCellReuseIdentifier: "LeftTableViewRRCell")
        tblMessage.register(UINib.init(nibName: "RightTableViewRRCell", bundle: nil), forCellReuseIdentifier: "RightTableViewRRCell")
        self.lblName.text = profileName
        self.indicator.isHidden = true
        txfMessage.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(SendMessageVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SendMessageVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.getMessages()
        
        self.validateBtnSend(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    @IBAction func tapTable(_ sender: Any) {
        self.view.endEditing(true)
    }
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("notification: Keyboard will show \(keyboardSize.height)")
            
            guard let userInfo = notification.userInfo else { return }
            
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
            self.spaceForm.constant = keyboardSize.height
            self.scrollBottom()
            UIView.animate(withDuration: duration) {
                
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func doProfile(_ sender: Any) {
       let vc = MyProfileUserVC()
        vc.profileID = self.profileID
        vc.idBook = self.messageDefault
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        var bottomPadding = CGFloat(0)
        if #available(iOS 11.0, *) {
            bottomPadding = view.safeAreaInsets.bottom
            
        }
        self.spaceForm.constant = bottomPadding
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doSend(_ sender: Any) {
        let message = txfMessage.text!.trimText()
        if message.isEmpty{
            return
        }
        self.btnSend.isHidden = true
        self.indicator.isHidden = false
        self.indicator.startAnimating()
        guard let id = UserDefaults.standard .value(forKey: USER_ID_RR) as? String else {
            return
        }
        
        let param = ["sender_id": id, "reciever_id": profileID, "message": message]
        APIRoomrentlyHelper.shared.addMSG(param) { success, erro in
            if success!{
                //                self.arrMessages.append(self.appendMessageUI(message))
                //                self.tblMessage.beginUpdates()
                //                self.tblMessage.insertRows(at: [IndexPath.init(row: self.arrMessages.count - 1, section: 0)], with: .fade)
                //                self.tblMessage.endUpdates()
                //                self.scrollBottom()
                self.btnSend.isHidden = false
                self.indicator.isHidden = true
                self.txfMessage.text = ""
                self.validateBtnSend(false)
                self.getMessages()
            }
            else{
                self.btnSend.isHidden = false
                self.indicator.isHidden = true
                self.showAlertMessage(message: erro ?? "")
            }
            
        }
    }
    
    func addMessageDefault(){
        guard let id = UserDefaults.standard .value(forKey: USER_ID_RR) as? String else {
            return
        }
        let param = ["sender_id": id, "reciever_id": profileID, "message": messageDefault]
        APIRoomrentlyHelper.shared.addMSG(param) { success, erro in
            if success!{
                self.getMessages()
            }
            else{
                self.showAlertMessage(message: erro ?? "")
            }
        }
    }
    func getMessages(){
        APIRoomrentlyHelper.shared.getMessageChatByUser(profileID) { success, dict in
            self.arrMessages.removeAll()
            if let dict = dict {
                for item in dict{
                    self.arrMessages.append(MessageObj.init(item))
                }
                
            }
            self.tblMessage.reloadData()
            self.scrollBottom()
        }
    }
    
    private func scrollBottom(){
        if self.arrMessages.count > 0{
            self.tblMessage.scrollToRow(at: IndexPath.init(row: self.arrMessages.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
}

extension SendMessageRRVC: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMessages.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageObj = self.arrMessages[indexPath.row]
        let user = UserDefaults.standard.value(forKey: USER_ID_RR) as? String ?? ""
        if user == messageObj.sender_id{
            let cell = self.tblMessage.dequeueReusableCell(withIdentifier: "RightTableViewRRCell") as! RightTableViewRRCell
            cell.lblMessage.text = messageObj.message
            cell.lblTime.text = self.formatTimeAgo(messageObj.created_at)
            if messageObj.readstatus == .read{
                cell.icRead.isHidden = true
            }
            else{
                cell.icRead.isHidden = false
            }
            return cell
        }
        else{
            let cell = self.tblMessage.dequeueReusableCell(withIdentifier: "LeftTableViewRRCell") as! LeftTableViewRRCell
            cell.lblMessage.text = messageObj.message
            cell.lblTime.text = self.formatTimeAgo(messageObj.created_at)
           
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let messageObj = self.arrMessages[indexPath.row]
        if messageObj.sender_id != profileID{
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.showAlertMessageAction("Are you sure you want to delete message?") { success in
                if success{
                    let obj = self.arrMessages[indexPath.row]
                    APIRoomrentlyHelper.shared.deleteMessage( obj.id) { success, erro in
                        // CommonHelper.hideBusy()
                        if success!{
                            self.arrMessages.remove(at: indexPath.row)
                            self.tblMessage.deleteRows(at: [indexPath], with: .left)
                            self.tblMessage.reloadData()
                        }
                        else{
                            self.showAlertMessage(message: erro ?? "")
                        }
                    }
                }
            }
            
        }
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
    
    private func appendMessageUI( _ content: String) -> MessageObj{
        guard let user =  UserDefaults.standard.value(forKey: USER_ID_RR) as? String else {
            return MessageObj.init(NSDictionary.init())
        }
        let messageObj = MessageObj.init(NSDictionary.init())
        messageObj.id = ""
        messageObj.message = content
        messageObj.created_at = self.dateTimeCreateMessage()
        messageObj.sender_id = user
        messageObj.receiver_id = profileID
        return messageObj
    }
    
    func validateBtnSend(_ isValid: Bool){
        if isValid{
            btnSend.alpha = 1.0
            btnSend.isEnabled = true
        }
        else{
            btnSend.alpha = 0.4
            btnSend.isEnabled = false
        }
    }
}


extension SendMessageRRVC: UITextFieldDelegate{
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.validateBtnSend(false)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            if updatedText.isEmpty{
                self.validateBtnSend(false)
            }
            else{
                self.validateBtnSend(true)
            }
        }
        return true
    }
}
