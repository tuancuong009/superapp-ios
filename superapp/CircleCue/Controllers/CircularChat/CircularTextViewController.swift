//
//  CircularTextViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 1/15/21.
//

import UIKit
import Alamofire

class CircularTextViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: GrowingTextView!
    @IBOutlet weak var sendButton: UIButton!
    
    var messages: [CircularMessage] = []
    
    var isEnableSendButton: Bool = false {
        didSet {
            sendButton.isEnabled = isEnableSendButton
            sendButton.setTitleColor(isEnableSendButton ? .white : .darkGray, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        fetchCircularMessage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @IBAction func sendAction(_ sender: Any) {
        guard !messageTextView.text.trimmed.isEmpty, let userId = AppSettings.shared.userLogin?.userId else { return }
        self.messageTextView.resignFirstResponder()
        self.sendMessage(message: messageTextView.text.trimmed, userId: userId)
    }
}

extension CircularTextViewController {
    
    private func fetchCircularMessage() {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        self.showSimpleHUD()
        ManageAPI.shared.fetchCircularMessage(userId) {[weak self] (results, error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let err = error {
                    self.showErrorAlert(message: err.msg)
                    return
                }
                self.messages = results.reversed()
                self.tableView.reloadData()
                self.scrollToBottom()
            }
        }
    }
    
    private func sendMessage(message: String, userId: String) {
        let para: Parameters = ["message": message, "sid": userId]
        self.showSimpleHUD(text: "Sending...")
        ManageAPI.shared.sendCircularMessage(para) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let err = error {
                    self.showErrorAlert(message: err.msg)
                    return
                }
                let newMessage = CircularMessage(message: message)
                self.messages.append(newMessage)
                self.tableView.reloadData()
                self.reset()
                self.scrollToBottom()
            }
        }
    }
}

extension CircularTextViewController {
    
    private func scrollToBottom(animated: Bool = true) {
        guard !messages.isEmpty else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let lastIndex = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: lastIndex, at: .bottom, animated: animated)
        }
    }
    
    private func setupUI() {
        messageTextView.textContainerInset.top = 10
        messageTextView.delegate = self
        isEnableSendButton = false
    }
    
    private func reset() {
        messageTextView.text = nil
        isEnableSendButton = false
    }
    
    private func setupTableView() {
        tableView.registerNibCell(identifier: CircularMessageTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 80
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
}

extension CircularTextViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CircularMessageTableViewCell.identifier, for: indexPath) as! CircularMessageTableViewCell
        cell.setupCircularChat(message: messages[indexPath.row])
        return cell
    }
}

extension CircularTextViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        isEnableSendButton = (textView.hasText && !textView.text.trimmed.isEmpty)
    }
}
