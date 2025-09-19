//
//  SendMessageVC.swift
//  MuslimMMM
//
//  Created by QTS Coder on 30/11/2022.
//

import UIKit
import IQKeyboardManagerSwift
import ImageViewer_swift
import AVKit
import AVFoundation
class SendMessageVC: BaseMatcheronViewController {
    
    @IBOutlet weak var tblMessage: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var spaceForm: NSLayoutConstraint!
    @IBOutlet weak var tvMessage: UITextView!
    @IBOutlet weak var heightMessage: NSLayoutConstraint!
    @IBOutlet weak var lblPlaceHolder: UILabel!
    var profileID: String = ""
    var profileName = "Wayne Nguyen"
    var arrMessages = [MessageObj]()
    var isProfileBack = false
    var imagePicker: UIImagePickerController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblMessage.register(UINib.init(nibName: "LeftTableViewCell", bundle: nil), forCellReuseIdentifier: "LeftTableViewCell")
        tblMessage.register(UINib.init(nibName: "RightTableViewCell", bundle: nil), forCellReuseIdentifier: "RightTableViewCell")
        tblMessage.register(UINib.init(nibName: "LeftImageTableViewCell", bundle: nil), forCellReuseIdentifier: "LeftImageTableViewCell")
        tblMessage.register(UINib.init(nibName: "RightImageTableViewCell", bundle: nil), forCellReuseIdentifier: "RightImageTableViewCell")
        self.lblName.text = profileName
        self.indicator.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(SendMessageVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SendMessageVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.getMessages()
        self.validateBtnSend(false)
        tvMessage.font = self.lblPlaceHolder.font
        
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
            var bottomPadding = CGFloat(0)
            if #available(iOS 11.0, *) {
                bottomPadding = view.safeAreaInsets.bottom
                
            }
            self.spaceForm.constant = keyboardSize.height - bottomPadding
            self.scrollBottom()
            UIView.animate(withDuration: duration) {
                
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func doProfile(_ sender: Any) {
        let vc = ProfileUserViewController.init()
        vc.profileID = self.profileID
        vc.profileName = self.profileName
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        self.spaceForm.constant = 0
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doImages(_ sender: Any) {
        view.endEditing(true)
        self.showPhotoAndLibrary()
    }
    @IBAction func doSend(_ sender: Any) {
        let message = tvMessage.text!.trimText()
        if message.isEmpty{
            return
        }
        self.btnSend.isHidden = true
        self.indicator.isHidden = false
        self.indicator.startAnimating()
        let userID = UserDefaults.standard.value(forKey: USER_ID) as? String ?? ""
        
        let param = ["sid": userID, "rid": profileID, "message": message]
        APIHelper.shared.addMSG(param) { success, erro in
            if success!{
                self.arrMessages.append(self.appendMessageUI(message))
                self.tblMessage.beginUpdates()
                self.tblMessage.insertRows(at: [IndexPath.init(row: self.arrMessages.count - 1, section: 0)], with: .fade)
                self.tblMessage.endUpdates()
                self.scrollBottom()
                self.btnSend.isHidden = false
                self.indicator.isHidden = true
                self.tvMessage.text = ""
                self.lblPlaceHolder.isHidden = false
                self.heightMessage.constant = 44
                self.validateBtnSend(false)
                // self.getMessages()
            }
            else{
                self.btnSend.isHidden = false
                self.indicator.isHidden = true
                self.showAlertMessage(message: erro ?? "")
            }
            
        }
    }
    
    func getMessages(){
        APIHelper.shared.getMessageChatByUser(profileID) { success, dict in
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
    
    private func addMessageIMG(_ image: UIImage){
        self.showBusy()
        let userID = UserDefaults.standard.value(forKey: USER_ID) as? String ?? ""
        
        let param = ["sid": userID, "rid": profileID, "message": ""]
        APIHelper.shared.addMessageImage(image1: image, param: param) { success, errer in
            if success!{
                self.hideBusy()
                self.getMessages()
            }
            else{
                self.hideBusy()
                if let err = errer{
                    self.showAlertMessage(message: err)
                }
            }
        }
    }
    
    func isImageURL(_ url: URL) -> Bool {
        let imageExtensions = ["jpg", "jpeg", "png", "gif", "bmp", "tiff", "webp", "heic"]
        let fileExtension = url.pathExtension.lowercased()
        return imageExtensions.contains(fileExtension)
    }
}

extension SendMessageVC: UITableViewDataSource, UITableViewDelegate{
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
        let userID = UserDefaults.standard.value(forKey: USER_ID) as? String ?? ""
        if userID == messageObj.sender_id{
            if messageObj.media.isEmpty{
                let cell = self.tblMessage.dequeueReusableCell(withIdentifier: "RightTableViewCell") as! RightTableViewCell
                cell.lblMessage.text = messageObj.message
                cell.lblTime.text = self.formatTimeAgo(messageObj.created_at)
                cell.icRead.setDeliveryImage(messageObj.readstatus)
                return cell
            }
            else{
                let cell = self.tblMessage.dequeueReusableCell(withIdentifier: "RightImageTableViewCell") as! RightImageTableViewCell
                cell.lblTime.text = self.formatTimeAgo(messageObj.created_at)
                cell.icRead.setDeliveryImage(messageObj.readstatus)
                if let url = URL(string: messageObj.media){
                    if self.isImageURL(url){
                        cell.imgCell.backgroundColor = .clear
                        cell.imgPlayVideo.isHidden = true
                        cell.imgCell.sd_setImage(with: url) { image, error, type, url in
                            
                        }
                    }
                    else{
                        cell.imgCell.image = nil
                        cell.imgPlayVideo.isHidden = false
                        cell.imgCell.backgroundColor = .lightGray
                        
                    }
                }
                else{
                    cell.imgCell.image = nil
                    cell.imgPlayVideo.isHidden = true
                    cell.imgCell.backgroundColor = .lightGray
                }
                
                cell.tapImage = { [] in
                    if let url = URL(string: messageObj.media){
                        if self.isImageURL(url){
                            let imageURLs: [URL] = [ url]
                            let vc = ImageViewerController.init(imageURLs: imageURLs)
                            vc.delegate = self
                            self.present(vc, animated: true)
                        }
                        else{
                            let player = AVPlayer(url: url)
                            let playerViewController = AVPlayerViewController()
                            playerViewController.player = player
                            
                            // Present the player view controller
                            self.present(playerViewController, animated: true) {
                                // Start playing the video when the player view controller is presented
                                player.play()
                            }
                        }
                    }
                    
                }
                return cell
            }
            
        }
        else{
            if messageObj.media.isEmpty{
                let cell = self.tblMessage.dequeueReusableCell(withIdentifier: "LeftTableViewCell") as! LeftTableViewCell
                cell.lblMessage.text = messageObj.message
                cell.lblTime.text = self.formatTimeAgo(messageObj.created_at)
                return cell
            }
            else{
                let cell = self.tblMessage.dequeueReusableCell(withIdentifier: "LeftImageTableViewCell") as! LeftImageTableViewCell
                cell.lblTime.text = self.formatTimeAgo(messageObj.created_at)
                if let url = URL(string: messageObj.media){
                    if self.isImageURL(url){
                        cell.imgCell.backgroundColor = .clear
                        cell.imgPlayVideo.isHidden = true
                        cell.imgCell.sd_setImage(with: url) { image, error, type, url in
                            
                        }
                    }
                    else{
                        cell.imgCell.image = nil
                        cell.imgPlayVideo.isHidden = false
                        cell.imgCell.backgroundColor = .lightGray
                        
                    }
                }
                else{
                    cell.imgCell.image = nil
                    cell.imgPlayVideo.isHidden = true
                    cell.imgCell.backgroundColor = .lightGray
                }
                
                cell.tapImage = { [] in
                    if let url = URL(string: messageObj.media){
                        if self.isImageURL(url){
                            let imageURLs: [URL] = [ url]
                            let vc = ImageViewerController.init(imageURLs: imageURLs)
                            vc.delegate = self
                            self.present(vc, animated: true)
                        }
                        else{
                            let player = AVPlayer(url: url)
                            let playerViewController = AVPlayerViewController()
                            playerViewController.player = player
                            
                            // Present the player view controller
                            self.present(playerViewController, animated: true) {
                                // Start playing the video when the player view controller is presented
                                player.play()
                            }
                        }
                    }
                }
                return cell
            }
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
                    APIHelper.shared.deleteMessage( obj.id) { success, erro in
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
            //
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
        let userID = UserDefaults.standard.value(forKey: USER_ID) as? String ?? ""
        let messageObj = MessageObj.init(NSDictionary.init())
        messageObj.id = ""
        messageObj.message = content
        messageObj.readstatus = .read
        messageObj.created_at = self.dateTimeCreateMessage()
        messageObj.sender_id = userID
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
    
    private func showPhotoAndLibrary()
    {
        let style: UIAlertController.Style = .actionSheet
        
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: style)
        let camera = UIAlertAction.init(title: "Take a photo/Video", style: .default) { (action) in
            //self.showCamera()
            self.showCamera()
        }
        alert.addAction(camera)
        
        let library = UIAlertAction.init(title: "Choose from library", style: .default) { (action) in
            self.showLibrary()
        }
        alert.addAction(library)
        
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(cancel)
        self.present(alert, animated: true) {
            
        }
    }
    
    private func showCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = ["public.image", "public.movie"]
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
    private func showLibrary()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = ["public.image", "public.movie"]
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func convertVideoURLToData(videoURL: URL) {
        DispatchQueue.global(qos: .background).async {
            do {
                let videoData = try Data(contentsOf: videoURL)
                print("Video data size: \(videoData.count) bytes")
                
                // If you need to use the data on the main thread, switch back to it
                DispatchQueue.main.async {
                    self.showBusy()
                    let userID = UserDefaults.standard.value(forKey: USER_ID) as? String ?? ""
                    let param = ["sid": userID, "rid": self.profileID, "message": ""]
                    APIHelper.shared.addMessageVideo(data: videoData, self.getFileExtension(from: videoURL), param: param) { success, errer in
                        if success!{
                            self.hideBusy()
                            self.getMessages()
                        }
                        else{
                            self.hideBusy()
                            if let err = errer{
                                self.showAlertMessage(message: err)
                            }
                        }
                    }
                }
            } catch {
                print("Error converting video URL to Data: \(error)")
            }
        }
    }
    func getFileExtension(from url: URL) -> String {
        return url.pathExtension
    }
    /*
     
     */
}


extension SendMessageVC: UITextFieldDelegate{
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

extension SendMessageVC: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        self.adjustTextViewHeight()
    }
    
    func adjustTextViewHeight() {
        let fixedWidth = tvMessage.frame.size.width
        let newSize = tvMessage.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        if newSize.height > 70{
            self.heightMessage.constant = 70
        }
        else{
            self.heightMessage.constant = newSize.height
        }
        self.view.layoutIfNeeded()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        self.validateBtnSend((numberOfChars == 0) ? false : true)
        self.lblPlaceHolder.isHidden =  (numberOfChars == 0) ? false : true
        
        return true
    }
}
extension SendMessageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            self.addMessageIMG(image)
        } else if let videoURL = info[.mediaURL] as? URL {
            print("Video URL: \(videoURL)")
            convertVideoURLToData(videoURL: videoURL)
        }
        
        
        self.dismiss(animated: true)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
            
        }
    }
}
extension SendMessageVC: ImageViewerControllerDelegate {
    func load(_ imageURL: URL, into imageView: UIImageView, completion: (() -> Void)?) {
        imageView.sd_setImage(with: imageURL) { image, error, type, url in
            completion?()
        }
    }
}
