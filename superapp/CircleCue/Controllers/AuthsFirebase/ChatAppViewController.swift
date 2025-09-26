//
//  ChatAppViewController.swift
//  SuperApp
//
//  Created by QTS Coder on 25/9/25.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class ChatAppViewController: UIViewController {
    @IBOutlet weak var tblMessage: UITableView!
    @IBOutlet weak var tvMessage: GrowingTextView!
    @IBOutlet weak var spaceBottomForm: NSLayoutConstraint!
    @IBOutlet weak var btnSend: UIButton!
    private var messages: [NSDictionary] = []
    var menuAppObj: MenuAppObj?
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMessage.sectionHeaderTopPadding = 0
        tblMessage.registerNibCell(identifier: "ChatAppTableViewCell")
        registerNotification()
        enableBtnSend()
        fetchItems { arrs in
            self.messages = arrs
            self.tblMessage.reloadData()
            self.scrollMessages()
        }
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
    func fetchItems(completion: @escaping ([NSDictionary]) -> Void) {
        guard let menuAppObj = menuAppObj else{
            return
        }
        let ref = Database.database().reference()
        let appsRef = ref.child(FIREBASE_TABLE.APP_MESSAGES).child(menuAppObj.key)
        
        appsRef.observeSingleEvent(of: .value, with: { snapshot in
            var objects: [NSDictionary] = []
            
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let dict = snap.value as? NSDictionary {
                    objects.append(dict)
                }
            }
            completion(objects)
        }) { error in
            print("❌ Firebase error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func doClose(_ sender: Any) {
        removeNotification()
        dismiss(animated: true)
    }
    @IBAction func doSend(_ sender: Any) {
        guard let menuAppObj = menuAppObj else{
            return
        }
        let message = tvMessage.text!.trimText()
        if message.isEmpty{
            return
        }
        guard let user = Auth.auth().currentUser else{
            return
        }
        let ref = Database.database().reference()
        let newKey = ref.child(FIREBASE_TABLE.APP_MESSAGES).child(menuAppObj.key).childByAutoId()

        let itemData: [String: Any] = [
            "message": message,
            "createdAt": Date().timeIntervalSince1970,
            "user_id": user.uid
        ]
        newKey.setValue(itemData)
        messages.append(itemData as NSDictionary)
        tblMessage.beginUpdates()
        tblMessage.insertRows(at: [IndexPath(row: messages.count - 1, section: 0)], with: .automatic)
        tblMessage.endUpdates()
        scrollMessages()
        tvMessage.text = nil
    }
}


extension ChatAppViewController{
    private func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeNotification(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func keyboardWillShow(notification: Notification) {
        if DEVICE_IPAD {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let topPadding = view.safeAreaInsets.bottom
            print(topPadding)
            spaceBottomForm.constant = keyboardSize.height - topPadding + 10
            view.layoutIfNeeded()
        }
    }
    
    @objc fileprivate func keyboardWillHide(notification: Notification) {
        if DEVICE_IPAD {
            return
        }
        spaceBottomForm.constant = 0
        view.layoutIfNeeded()
    }
    
    private func enableBtnSend(){
        if tvMessage.text!.trimmed.isEmpty{
            btnSend.alpha = 0.4
            btnSend.isEnabled = false
        }
        else{
            btnSend.alpha = 1.0
            btnSend.isEnabled = true
        }
    }
    
    private func scrollMessages(){
        scrollToSectionFooter(section: 0)
    }
    
    func scrollToSectionFooter(section: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            let footerRect = self.tblMessage.rectForFooter(inSection: section)
            self.tblMessage.scrollRectToVisible(footerRect, animated: true)
        }
    }
}
extension ChatAppViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.scrollMessages()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        enableBtnSend()
    }
}

extension ChatAppViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMessage.dequeueReusableCell(withIdentifier: "ChatAppTableViewCell") as! ChatAppTableViewCell
        cell.configCell(messages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
}
