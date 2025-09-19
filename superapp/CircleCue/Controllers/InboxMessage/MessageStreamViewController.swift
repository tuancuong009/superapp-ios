//
//  MessageStreamViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/14/20.
//

import UIKit
import AVKit
import DTPhotoViewerController
import Alamofire

protocol MessageStreamViewControllerDelegate: AnyObject {
    func didLoadPlayer(_ message: Message, avPlayer: AVPlayer)
    func showFullScreen(_ message: Message)
    func showOption(_ message: Message)
    func showImage(_ message: Message, imageView: UIImageView)
    func fetchNewMessage()
    func responseDatingRequest(_ indexAction: Int)
}

class MessageStreamViewController: BaseViewController {

    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: GrowingTextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    var isFromProfile: Bool = false
    var friendUser: UniversalUser?
    var pickerController: ImagePicker?
    var userMessage: UserMessage?
    var shouldScroll: Bool = false
    var mediaPath: String?
    
    var isEnableSendButton: Bool = false {
        didSet {
            sendButton.isEnabled = isEnableSendButton
            sendButton.setTitleColor(isEnableSendButton ? .white : .darkGray, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI(userMessage: nil)
        setupTableView()
        fetchMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shouldScroll {
            self.scrollToBottom()
            self.shouldScroll = false
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func attachAction(_ sender: Any) {
        view.endEditing(true)
        pickerController?.present(title: "Attach a File", message: nil, from: sender as! UIButton)
    }
    
    @IBAction func sendAction(_ sender: Any) {
        guard let userId = AppSettings.shared.userLogin?.userId, let otherUserId = friendUser?.id, (!messageTextView.text.trimmed.isEmpty || mediaPath != nil) else { return }
        var para: Parameters = ["sid": userId, "rid": otherUserId, "msg": messageTextView.text.trimmed.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? messageTextView.text.trimmed]
        if let path = mediaPath {
            para.updateValue(path, forKey: "media")
        }
        view.endEditing(true)
        sendMessage(para: para)
    }
    
    @IBAction func blockAction(_ sender: Any) {
        self.blockUser()
    }
    
    @IBAction func reportAction(_ sender: Any) {
        self.navigationController?.pushViewController(HelpViewController.instantiate(), animated: true)
    }
    
    @IBAction func viewProfileAction(_ sender: Any) {
        let controller = FriendProfileViewController.instantiate()
        controller.basicInfo = friendUser
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension MessageStreamViewController {
    
    private func fetchMessages(loading: Bool = true) {
        guard let userId = AppSettings.shared.userLogin?.userId, let otherUserId = friendUser?.id else { return }
        showSimpleHUD()
        ManageAPI.shared.fetchMessageBetweenUser(userId, otherUserId) { [weak self] (userMessage, error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let userMessage = userMessage {
                    self.userMessage = userMessage
                    self.warningLabel.isHidden = !userMessage.messages.isEmpty
                    self.updateUI(userMessage: userMessage)
                    self.tableView.reloadData()
                    self.scrollToBottom()
                    print("userMessage", userMessage)
                    return
                }
                if let err = error {
                    self.showErrorAlert(message: err)
                    return
                }
                
                self.userMessage?.messages = []
                self.tableView.reloadData()
                self.warningLabel.isHidden = false
            }
        }
    }
    
    private func sendMessage(para: Parameters) {
        showSimpleHUD(text: "Sending...")
        ManageAPI.shared.sendMessageToUser(para: para) {[weak self] (error) in
            guard let self = self else { return }
            if let err = error {
                self.hideLoading()
                self.showErrorAlert(message: err)
                return
            }
            self.reset()
            self.fetchMessages()
        }
    }
    
    private func deleteMessage(message: Message) {
        showSimpleHUD(text: "Deleting...")
        ManageAPI.shared.deleteMessage(message.id) {[weak self] (error) in
            guard let self = self else { return }
            if let err = error {
                self.hideLoading()
                self.showErrorAlert(message: err)
                return
            }
            self.fetchMessages()
        }
    }
    
    private func blockUser() {
        guard let userId = AppSettings.shared.userLogin?.userId, let otherUserId = friendUser?.id else { return }
        showSimpleHUD()
        ManageAPI.shared.blockUser(userId, otherUserId) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            if let err = error {
                self.showErrorAlert(message: err)
                return
            }
            
            self.showAlert(title: "", message: "Your request has been submitted.", buttonTitles: ["OK"], highlightedButtonIndex: nil) { (_) in
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

extension MessageStreamViewController {
    
    private func updateUI(userMessage: UserMessage?) {
        userAvatarImageView.setImage(with: userMessage?.pic ?? friendUser?.pic ?? "", placeholderImage: .avatar_small)
        userNameLabel.text = userMessage?.username ?? friendUser?.username
    }
    
    private func scrollToBottom(animated: Bool = true) {
        guard let userMessage = userMessage, !userMessage.messages.isEmpty else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let lastIndex = IndexPath(row: userMessage.messages.count-1, section: 0)
            self.tableView.scrollToRow(at: lastIndex, at: .bottom, animated: animated)
        }
    }
    
    private func setupUI() {
        warningLabel.isHidden = true
        messageTextView.textContainerInset.top = 10
        messageTextView.delegate = self
        isEnableSendButton = false
        pickerController = ImagePicker(presentationController: self, delegate: self, mediaTypes: [.video, .image], allowsEditing: false)
        warningLabel.text = "Warning: Please do not SPAM or send offensive messages to any CircleCue user. Any report of abuse will permanently block and ban you. CircleCue is very strict on this Policy"
    }
    
    private func reset() {
        mediaPath = nil
        messageTextView.text = nil
        isEnableSendButton = false
    }
    
    private func setupTableView() {
        tableView.registerNibCell(identifier: TextMessageTableViewCell.identifier)
        tableView.registerNibCell(identifier: ImageMessageTableViewCell.identifier)
        tableView.registerNibCell(identifier: VideoMessageTableViewCell.identifier)
        tableView.registerNibCell(identifier: Text_ImageMessageTableViewCell.identifier)
        tableView.registerNibCell(identifier: Text_VideoMessageTableViewCell.identifier)
        tableView.registerNibCell(identifier: DatingRequestTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if keyboardHeight > 0 {
                keyboardHeight = keyboardHeight - (view.window?.safeAreaInsets.bottom ?? 0.0)
            }
            bottomConstraint.constant = keyboardHeight

            UIView.animate(withDuration: keyboardDuration ?? 0.25) {
                self.view.layoutIfNeeded()
                self.scrollToBottom()
            }
        }
    }
    
    private func showMessageOption(_ message: Message) {
        let alert = UIAlertController(title: "Option", message: nil, preferredStyle: .actionSheet)
        let forwardAction = UIAlertAction(title: "Forward", style: .default) { (action) in
            let controller = ForwardMessageViewController.instantiate()
            controller.message = message
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        let copyAction = UIAlertAction(title: "Copy", style: .default) { (action) in
            let messageText = message.message
            UIPasteboard.general.string = messageText
            self.view.makeToast("Message is copied.")
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.deleteMessage(message: message)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        switch message.messageType {
        case .text, .imageWithText, .videoWithText:
            alert.addAction(copyAction)
        default:
            break
        }

        alert.addAction(forwardAction)
        alert.addAction(deleteAction)
        alert.addAction(cancel)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            alert.popoverPresentationController?.permittedArrowDirections = []
        }
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension MessageStreamViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let userMessage = userMessage else { return 0 }
        return userMessage.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let userMessage = userMessage, indexPath.row < userMessage.messages.count else { return UITableViewCell() }
        let message = userMessage.messages[indexPath.row]
        switch message.messageType {
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextMessageTableViewCell.identifier, for: indexPath) as! TextMessageTableViewCell
            cell.setup(message: message)
            cell.delegate = self
            return cell
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageMessageTableViewCell.identifier, for: indexPath) as! ImageMessageTableViewCell
            cell.setup(message: message)
            cell.delegate = self
            return cell
        case .imageWithText:
            let cell = tableView.dequeueReusableCell(withIdentifier: Text_ImageMessageTableViewCell.identifier, for: indexPath) as! Text_ImageMessageTableViewCell
            cell.setup(message: message)
            cell.delegate = self
            return cell
        case .video:
            let cell = tableView.dequeueReusableCell(withIdentifier: VideoMessageTableViewCell.identifier, for: indexPath) as! VideoMessageTableViewCell
            cell.delegate = self
            cell.setup(message: message)
            return cell
        case .videoWithText:
            let cell = tableView.dequeueReusableCell(withIdentifier: Text_VideoMessageTableViewCell.identifier, for: indexPath) as! Text_VideoMessageTableViewCell
            cell.delegate = self
            cell.setup(message: message)
            return cell
        case .datingRequest:
            if message.sender == .me {
                let cell = tableView.dequeueReusableCell(withIdentifier: TextMessageTableViewCell.identifier, for: indexPath) as! TextMessageTableViewCell
                cell.setup(message: message)
                cell.delegate = self
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: DatingRequestTableViewCell.identifier, for: indexPath) as! DatingRequestTableViewCell
            cell.delegate = self
            cell.contentLabel.text = message.message
            cell.dateTimeLabel.text = message.created_at?.toDateString(.noteDashboard)
            return cell
        }
    }
}

extension MessageStreamViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        isEnableSendButton = textView.hasText || (mediaPath != nil)
    }
}

extension MessageStreamViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        print(image as Any)
        guard let data = image?.jpegData(compressionQuality: 0.5) else { return }
        uploadData(data: data, type: .image)
    }
    
    func didSelect(videoURL: URL?) {
        print(videoURL as Any)
        guard let url = videoURL, let data = try? Data(contentsOf: url) else { return }
        print(url, data)
        uploadData(data: data, type: .video)
    }
    
    private func uploadData(data: Data, type: MediaUploadType) {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        var fileName = "\(userId)\(randomString()).jpg"
        if type == .video {
            fileName = "\(userId)\(randomString()).mp4"
        }
        
        showSimpleHUD(text: "Uploading...")
        ManageAPI.shared.uploadFile(file: data, fileName, type) {[weak self] (path, error) in
            guard let self = self else { return }
            if let path = path {
                self.isEnableSendButton = true
                self.mediaPath = path
                self.showSuccessHUD(text: "Your file has been uploaded and attached.")
                return
            }
            self.showErrorHUD(text: error)
        }
    }
}

extension MessageStreamViewController: MessageStreamViewControllerDelegate {
    func didLoadPlayer(_ message: Message, avPlayer: AVPlayer) {
        guard let userMessage = userMessage else { return }
        if let index = userMessage.messages.firstIndex(where: {$0.id == message.id}) {
            userMessage.messages[index].player = avPlayer
            UIView.performWithoutAnimation {
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
    
    func showFullScreen(_ message: Message) {
        var avPlayer: AVPlayer?
        
        if let player = message.player {
            avPlayer = player
        } else if let url = URL(string: message.mediaUrl) {
            avPlayer = AVPlayer(url: url)
        }
        
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = avPlayer
        avPlayerController.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.async {
            self.present(avPlayerController, animated: true) {
                avPlayerController.player?.play()
            }
        }
    }
    
    func showOption(_ message: Message) {
        showMessageOption(message)
    }
    
    func showImage(_ message: Message, imageView: UIImageView) {
        self.showSimplePhotoViewer(for: imageView, image: imageView.image)
    }
    
    func fetchNewMessage() {
        fetchMessages(loading: false)
        shouldScroll = true
    }
    
    func responseDatingRequest(_ indexAction: Int) {
        guard let userId = AppSettings.shared.userLogin?.userId, let otherUserId = friendUser?.id else { return }
        var para: Parameters = ["sid": userId, "rid": otherUserId]
        if indexAction == 0 {
            para.updateValue(Constants.DATING_CIRCLE_DECLINE_MESSSAGE, forKey: "msg")
        } else {
            para.updateValue(Constants.DATING_CIRCLE_ACCEPT_MESSSAGE, forKey: "msg")
        }
        
        sendMessage(para: para)
    }
}
