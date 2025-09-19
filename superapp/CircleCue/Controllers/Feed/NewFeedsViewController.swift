//
//  NewFeedsViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 3/26/21.
//

import UIKit
import Alamofire
import AVKit

enum FeedType: Int {
    case personal = 0
    case business = 1
    case vclips = 2
    case all = 3
}

class NewFeedsViewController: BaseViewController {

    @IBOutlet weak var searchTextField: CustomTextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyUserLabel: UILabel!
    
    var currentType: FeedType = .all
//    var newPersonalRegister = false
    
    private var currentPage: Int = 1
    private var hasMore: Bool = true
    private var newFeeds: [NewFeed] = []
    private var popupBackground: UIView?
    private var loginView: LoginPopupView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        segmentControl.selectedSegmentIndex = currentType.rawValue
        setupTableView()
        guard let _ = AppSettings.shared.currentUser else {
            showLoginOption()
            tableView.isHidden = true
            return
        }
        fetchNewFeed()
    }

    @IBAction func changeSegementAction(_ sender: UISegmentedControl) {
        guard let type = FeedType(rawValue: sender.selectedSegmentIndex), type != currentType else { return }
        currentType = type
        newFeeds.removeAll()
        tableView.reloadData()
        fetchNewFeed()
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        fetchNewFeed()
    }
    
    @IBAction func didTapSearchButton(_ sender: Any) {
        searchTextField.resignFirstResponder()
        fetchNewFeed()
    }
}

extension NewFeedsViewController {
    
    private func setupUI() {
        if AppSettings.shared.currentUser != nil {
            self.topBarMenuView.leftButtonType = 0
        } else {
            self.topBarMenuView.leftButtonType = 3
        }
        
        emptyUserLabel.text = "No Feeds found."
        emptyUserLabel.isHidden = true
        searchTextField.delegate = self
        searchButton.layer.cornerRadius = 5
        searchButton.layer.borderColor = UIColor.white.cgColor
        searchButton.layer.borderWidth = 0.5
        
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,
                                               NSAttributedString.Key.font: UIFont.myriadProBold(ofSize: 15)], for: .selected)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,
                                               NSAttributedString.Key.font: UIFont.myriadProRegular(ofSize: 15)], for: .normal)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,
                                               NSAttributedString.Key.font: UIFont.myriadProRegular(ofSize: 15)], for: .highlighted)
        segmentControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }
    
    private func setupTableView() {
        tableView.registerNibCell(identifier: NewFeedTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func showLoginOption() {
        popupBackground = UIView(frame: self.view.frame)
        popupBackground?.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        popupBackground?.alpha = 0
        
        let expectWidth = max(UIScreen.main.bounds.width - 30, 320)
//        let expectHeight = UIScreen.main.bounds.height * 0.8
        loginView = LoginPopupView(frame: CGRect(x: 0, y: 0, width: expectWidth, height: expectWidth))
        loginView?.center = self.view.center
        loginView?.alpha = 0
        loginView?.delegate = self
        loginView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        self.view.addSubview(popupBackground!)
        self.view.addSubview(loginView!)
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: [.curveEaseOut]) {
            self.popupBackground?.alpha = 1.0
            self.loginView?.alpha = 1.0
            self.loginView?.transform = .identity
        } completion: { _ in
        }
    }
    
    private func closeLoginView(_ action: LoginPopupAction) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: [.curveEaseOut]) {
            self.popupBackground?.alpha = 0
            self.loginView?.alpha = 0
            self.loginView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            self.popupBackground?.removeFromSuperview()
            self.loginView?.removeFromSuperview()
            self.redirect(action)
        }
    }
    
    private func fetchNewFeed() {
        currentPage = 1
        hasMore = true
        self.showSimpleHUD()
        let userId = AppSettings.shared.userLogin?.userId
        let username = searchTextField.trimmedText ?? ""
        ManageAPI.shared.fetchNewFeed(userId, page: currentPage, type: currentType, searchQuery: username) {[weak self] (results, hasMore, error) in
            guard let self = self else { return }
            self.hideLoading()
            self.newFeeds = results
            self.hasMore = hasMore
            DispatchQueue.main.async {
                self.emptyUserLabel.isHidden = !results.isEmpty
                self.tableView.reloadData()
            }
        }
    }
    
    private func fetchMoreNewFeed() {
        let userId = AppSettings.shared.userLogin?.userId
        let username = searchTextField.trimmedText ?? ""
        ManageAPI.shared.fetchNewFeed(userId, page: currentPage, type: currentType, searchQuery: username) {[weak self] (results, hasMore, error) in
            guard let self = self else { return }
            self.newFeeds.append(contentsOf: results)
            self.hasMore = hasMore
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func likeAction(photoId: String, userId: String, shouldLike: Bool) {
        let para: Parameters = ["pid": photoId, "uid": userId]
        self.showSimpleHUD()
        ManageAPI.shared.likePhoto(shouldLike: !shouldLike, para) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if error == nil {
                    if let index = self.newFeeds.firstIndex(where: {$0.id == photoId}) {
                        self.newFeeds[index].user_like.toggle()
                        if !shouldLike {
                            self.newFeeds[index].like_count += 1
                        } else {
                            let newLike = self.newFeeds[index].like_count - 1
                            self.newFeeds[index].like_count = max(newLike, 0)
                        }
                        UIView.performWithoutAnimation {
                            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                        }
                    }
                } else {
                    self.showErrorAlert(message: error?.msg)
                }
            }
        }
    }
    
//    private func showUserSouce() {
//        guard newPersonalRegister else { return }
//        let controller = UserSourceViewController.instantiate(from: StoryboardName.authentication.rawValue)
//        controller.modalTransitionStyle = .crossDissolve
//        controller.modalPresentationStyle = .overFullScreen
//        controller.didSubmit = { [weak self] in
//            self?.view.makeToast("Thank you for your assistance!")
//        }
//        newPersonalRegister = false
//        self.present(controller, animated: true, completion: nil)
//    }
}

extension NewFeedsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newFeeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewFeedTableViewCell.identifier, for: indexPath) as! NewFeedTableViewCell
        cell.setup(newFeed: newFeeds[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard hasMore, indexPath.row == newFeeds.count-4 else { return }
        currentPage += 1
        fetchMoreNewFeed()
    }
}

extension NewFeedsViewController: NewFeedTableViewCellDelegate {
    
    func viewPhoto(_ newFeed: NewFeed, imageView: UIImageView) {
        let controller = CustomPhotoViewerController(referencedView: imageView, image: imageView.image)
        controller.feed = newFeed
        self.present(controller, animated: true, completion: nil)
    }
    
    func playVideo(_ newFeed: NewFeed) {
        view.endEditing(true)
        let controller = ClipsFullscreenViewController.instantiate()
        controller.currentFeed = newFeed
        controller.currentPage = self.currentPage
        controller.currentType = self.currentType
        controller.hasMore = self.hasMore
        controller.allClipFeeds = self.newFeeds.filter({$0.newFeedType == .video})
        controller.delegate = self
        let navigation = BaseNavigationController(rootViewController: controller)
        navigation.modalPresentationStyle = .overFullScreen
        self.present(navigation, animated: true, completion: nil)
    }
    
    func viewUserProfileAction(_ newFeed: NewFeed) {
        guard let _ = AppSettings.shared.currentUser else {
            showLoginOption()
            return
        }
        view.endEditing(true)
        if newFeed.uid == AppSettings.shared.userLogin?.userId {
            let controller = MyProfileViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = FriendProfileViewController.instantiate()
            controller.basicInfo = UniversalUser(id: newFeed.uid, username: newFeed.username, country: newFeed.country, pic: newFeed.pic)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func likeAction(_ newFeed: NewFeed) {
        guard let userId = AppSettings.shared.currentUser?.userId else {
            showLoginOption()
            return
        }
        
        self.likeAction(photoId: newFeed.id, userId: userId, shouldLike: newFeed.user_like)
    }
    
    func viewComment(_ newFeed: NewFeed) {
        guard let _ = AppSettings.shared.currentUser else {
            showLoginOption()
            return
        }
        showComments(newFeed: newFeed)
    }
    
    func viewLikeAction(_ newFeed: NewFeed) {
        guard let _ = AppSettings.shared.currentUser else {
            showLoginOption()
            return
        }
        showLikes(photoId: newFeed.id)
    }
    
    private func showLikes(photoId: String) {
        view.endEditing(true)
        let controller = LikesViewController.instantiate()
        controller.photoId = photoId
        let navigation = BaseNavigationController(rootViewController: controller)
        navigation.modalPresentationStyle = .overFullScreen
        self.present(navigation, animated: true, completion: nil)
    }
    
    private func showComments(newFeed: NewFeed) {
        view.endEditing(true)
        let controller = CommentViewController.instantiate()
        controller.newFeed = newFeed
        controller.delegate = self
        let navigation = BaseNavigationController(rootViewController: controller)
        navigation.modalPresentationStyle = .overFullScreen
        self.present(navigation, animated: true, completion: nil)
    }
    
    private func showVideo(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let avPlayer = AVPlayer(url: url)
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = avPlayer
        avPlayerController.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.async {
            self.present(avPlayerController, animated: true) {
                avPlayerController.player?.play()
            }
        }
    }
    
    private func optionActionUser(_ newFeed: NewFeed){
        
    }

}

extension NewFeedsViewController: LoginPopupViewDelegate {
    
    func performAction(_ action: LoginPopupAction) {
//        closeLoginView(action)
        redirect(action)
    }
    
    private func redirect(_ action: LoginPopupAction) {
        view.endEditing(true)
        switch action {
        case .join:
            let controller = RegisterViewController.instantiate(from: StoryboardName.authentication.rawValue)
            self.navigationController?.pushViewController(controller, animated: true)
        case .login:
            let controller = LoginVC.instantiate(from: StoryboardName.authentication.rawValue)
            self.navigationController?.pushViewController(controller, animated: true)
        default:
            break
        }
    }
}

extension NewFeedsViewController: CommentViewControllerDelegate {
    
    func viewProfile(_ comment: PhotoComment) {
    }
    
    func didDismisCommentViewController() {
    }
    
    func didLoadAllComment(_ newFeed: NewFeed, commentNumber: Int) {
        if let index = newFeeds.firstIndex(where: {$0.id == newFeed.id}) {
            self.newFeeds[index].comment_count = commentNumber
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }
    
    func showCommentOption(_ comment: PhotoComment) {
    }
}

extension NewFeedsViewController: FullscreenViewDelegate {
    
    func updateNewFeed(_ newFeed: NewFeed?) {
        guard let newFeed = newFeed else { return }
        if let index = self.newFeeds.firstIndex(where: {$0.id == newFeed.id}) {
            self.newFeeds[index] = newFeed
            UIView.performWithoutAnimation {
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
    
    func didLoadMore(_ results: [NewFeed], hasMore: Bool, currentPage: Int) {
        self.hasMore = hasMore
        self.currentPage = currentPage
        self.newFeeds.append(contentsOf: results)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension NewFeedsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        fetchNewFeed()
        return true
    }
}
