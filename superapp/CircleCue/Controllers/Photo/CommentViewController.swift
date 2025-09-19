//
//  CommentViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 1/6/21.
//

import UIKit
import Alamofire

protocol CommentViewControllerDelegate: AnyObject {
    func didLoadAllComment(_ newFeed: NewFeed, commentNumber: Int)
    func showCommentOption(_ comment: PhotoComment)
    func didDismisCommentViewController()
    func viewProfile(_ comment: PhotoComment)
}

private extension CommentViewController {
    enum CommentButtonType: String {
        case post = "Post"
        case update = "Update"
    }
}

class CommentViewController: BaseViewController {
    
    @IBOutlet weak var typeMessageContainerView: UIView!
    @IBOutlet weak var commentTextView: GrowingTextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var commentViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButton: UIButton!
    
    var photo: Gallery?
    var newFeed: NewFeed?
    weak var delegate: CommentViewControllerDelegate?
    
    private var comments: [PhotoComment] = [] {
        didSet {
            noDataLabel.isHidden = !comments.isEmpty
        }
    }
    
    private var isEnablePostButton: Bool = false {
        didSet {
            postButton.isEnabled = isEnablePostButton
            postButton.setTitleColor(isEnablePostButton ? .white : .darkGray, for: .normal)
        }
    }
    
    private var commentButtonType: CommentButtonType = .post {
        didSet {
            let title = commentButtonType.rawValue
            postButton.titleLabel?.text = title
            postButton.setTitle(title, for: .normal)
            cancelButton.isHidden = commentButtonType == .post
        }
    }
    
    private var editComment: PhotoComment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        fetchComment()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func backAction() {
        dismiss(animated: true) {
            self.delegate?.didDismisCommentViewController()
        }
    }
    
    @IBAction func postAction(_ sender: Any) {
        let commentText = commentTextView.text.trimmed
        guard !commentText.isEmpty else { return }
        if let comment = self.editComment  {
            self.editComment(comment: comment, newComment: commentText)
        } else {
            self.addComment(comment: commentText)
        }
    }
    
    @IBAction func cancelEditCommentAction(_ sender: Any) {
        reset()
    }
}

extension CommentViewController {
    
    private func setupUI() {
        noDataLabel.text = "No Comments added."
        noDataLabel.isHidden = true
        commentTextView.textContainerInset.top = 10
        commentTextView.delegate = self
        isEnablePostButton = false
        commentButtonType = .post
    }
    
    private func setupTableView() {
        tableView.registerNibCell(identifier: PhotoCommentTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if keyboardHeight > 0 {
                keyboardHeight = keyboardHeight - (view.window?.safeAreaInsets.bottom ?? 0.0)
            }
            commentViewBottomConstraint.constant = keyboardHeight
            typeMessageContainerView.backgroundColor = keyboardHeight > 0 ? UIColor.init(hex: "4D0F28") : .clear

            UIView.animate(withDuration: keyboardDuration ?? 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func reset() {
        editComment = nil
        commentTextView.text = nil
        commentTextView.resignFirstResponder()
        isEnablePostButton = false
        commentButtonType = .post
        typeMessageContainerView.backgroundColor = .clear
    }
    
    private func updateNewFeed(_ commentNumber: Int) {
        guard let newFeed = newFeed, newFeed.comment_count != commentNumber else { return }
        delegate?.didLoadAllComment(newFeed, commentNumber: commentNumber)
    }
    
    private func fetchComment() {
        var id: String? = nil
        if let photo = photo {
            id = photo.id
        } else if let newFeed = newFeed {
            id = newFeed.id
        }
        guard let photoId = id else { return }
        self.showSimpleHUD(text: "Fetching comments...", fromView: self.navigationController?.view)
        ManageAPI.shared.fetchPhotoComments(photoId) {[weak self] (results, error) in
            guard let self = self else { return }
            self.hideLoading()
            if let err = error {
                self.showErrorAlert(message: err.msg)
                return
            }
            self.comments = results
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.updateNewFeed(results.count)
            }
        }
    }
    
    private func addComment(comment: String) {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        var id: String? = nil
        if let photo = photo {
            id = photo.id
        } else if let newFeed = newFeed {
            id = newFeed.id
        }
        guard let photoId = id else { return }
        let para: Parameters = ["uid": userId, "pid": photoId, "comment": comment]
        self.showSimpleHUD(text: nil, fromView: self.view)
        ManageAPI.shared.addPhotoComment(para) {[weak self] (error) in
            guard let self = self else { return }
            if let err = error {
                self.hideLoading()
                self.showErrorAlert(message: err.msg)
                return
            }
            self.reset()
            self.fetchComment()
        }
    }
    
    private func deleteComment(comment: PhotoComment) {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        if userId != comment.uid {
            self.showErrorAlert(message: "You're only able to delete your own comment.")
            return
        }
        
        let para: Parameters = ["uid": userId, "id": comment.id]
        self.showSimpleHUD(text: nil, fromView: self.view)
        ManageAPI.shared.deletePhotoComment(para) {[weak self] (error) in
            guard let self = self else { return }
            if let err = error {
                self.hideLoading()
                self.showErrorAlert(message: err.msg)
                return
            }
            
            self.fetchComment()
        }
    }
    
    private func showEditComment(comment: PhotoComment) {
        self.commentButtonType = .update
        self.editComment = comment
        self.commentTextView.text = comment.comment
        self.commentTextView.becomeFirstResponder()
        self.isEnablePostButton = true
    }
    
    private func editComment(comment: PhotoComment, newComment: String) {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        if userId != comment.uid {
            self.showErrorAlert(message: "You're only able to edit your own comment.")
            return
        }
        
        let para: Parameters = ["uid": userId, "id": comment.id, "comment": newComment]
        self.showSimpleHUD(text: nil, fromView: self.view)
        ManageAPI.shared.editPhotoComment(para) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            if let err = error {
                self.showErrorAlert(message: err.msg)
                return
            }
            
            self.reset()
            self.view.makeToast("Your comment has been updated.")
            self.editComment = nil
            self.updateNewCommentList(comment: comment, newComment: newComment)
        }
    }
    
    private func updateNewCommentList(comment: PhotoComment, newComment: String) {
        if let index = self.comments.firstIndex(where: {$0.id == comment.id}) {
            self.comments[index].comment = newComment
            UIView.performWithoutAnimation {
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        }
    }
}

extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCommentTableViewCell.identifier, for: indexPath) as! PhotoCommentTableViewCell
        cell.setup(comments[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension CommentViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        isEnablePostButton = (textView.hasText && !textView.text.trimmed.isEmpty)
    }
}

extension CommentViewController: CommentViewControllerDelegate {
    
    func viewProfile(_ comment: PhotoComment) {
        if comment.uid == AppSettings.shared.userLogin?.userId {
            let controller = MyProfileViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = FriendProfileViewController.instantiate()
            controller.basicInfo = UniversalUser(photoComment: comment)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func didDismisCommentViewController() {
    }
    
    func didLoadAllComment(_ newFeed: NewFeed, commentNumber: Int) {
    }
    
    func showCommentOption(_ comment: PhotoComment) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
            self.showEditComment(comment: comment)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.deleteComment(comment: comment)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
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
