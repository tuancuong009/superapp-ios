//
//  FriendProfileViewUserNameController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/13/20.
//

import UIKit
import Alamofire
import DTPhotoViewerController
import AVKit
import SafariServices


class FriendProfileViewUserNameController: BaseViewController {

    @IBOutlet weak var accountTypeLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var flagLabel: UILabel!
    @IBOutlet weak var imageWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var innerCirlceStatusButton: UIButton!
    @IBOutlet weak var circleNumberLabel: UILabel!
    @IBOutlet var profileTypeButtons: [ProfileButton]!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var creditButton: UIButton!
    @IBOutlet weak var circleNumberView: CustomView!
    
    @IBOutlet weak var followingButton: ProfileButton!
    @IBOutlet weak var numberFollowingButton: UIButton!
    @IBOutlet weak var numberFollowerButton: UIButton!
    @IBOutlet weak var stackVip: UIStackView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblLink: UILabel!
    @IBOutlet weak var lblHtml: UILabel!
    @IBOutlet weak var lblDescHtml: UILabel!
    
    var basicInfo: UniversalUser?
    var user: UserInfomation?
    var didDismisController: (() -> Void)?
    
    private var privacyUser: UserInfomation?
    private var photos: [Gallery] = []
    private var timer: Timer?
    private var currentIndex: Int = 0
    private var selectedImageIndex: Int = 0
    
    private var popupBackground: UIView?
    private var loginView: LoginPopupView?
    
    weak var delegate: ViewFriendProfileDelegate?
    
    var innerCircleStatus: InnerCircleStatus = .no {
        didSet {
            guard isViewLoaded else { return }
            innerCirlceStatusButton.titleLabel?.text = innerCircleStatus.description
            innerCirlceStatusButton.setTitle(innerCircleStatus.description, for: .normal)
        }
    }
    var favoriteStatus: FavoriteStatus = .unFavorite
    
   
    
    var isZoom: Bool = false {
        didSet {
            imageWidthConstant.constant = isZoom ? self.view.frame.width : 120.0
            avatarImageView.layer.cornerRadius = imageWidthConstant.constant/2
            self.view.layoutIfNeeded()
        }
    }
    
    private var isFollowing: Bool = false {
        didSet {
            followingButton.setButtonTitle(title: isFollowing ? "FOLLOWING" : "FOLLOW")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        increaseProfileViewer()
        if AppSettings.shared.currentUser != nil {
            fetchUserPrivacy()
        } else {
            fetchUserData()
        }
    }
    @IBAction func doCopy(_ sender: Any) {
        UIPasteboard.general.string = lblHtml.text!
        self.view.makeToast("Copied!")
    }
    @IBAction func doTotalLinke(_ sender: Any) {
        let controler = InnerCircleViewController.instantiate()
        controler.basicInfo = self.basicInfo
        controler.isTotalLikeProfile = true
        self.navigationController?.pushViewController(controler, animated: true)
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        self.didDismisController?()
    }
    @IBAction func didTabLike(_ sender: Any) {
      //  guard  let currentUser = AppSettings.shared.userLogin else {
//            return
//        }
//        guard  let user = user else {
//            return
//        }
//        guard  let basicInfo = basicInfo else {
//            return
//        }
//        
//        if !user.likec{
//            user.total_likes = user.total_likes + 1
//            user.likec = true
//            if user.accountType == .business{
//                btnLike.setImage(user.likec ? UIImage.init(named: "ic_liked1") : UIImage.init(named: "ic_like1"), for: .normal)
//            }
//            else{
//                btnLike.setImage(user.likec ? UIImage.init(named: "ic_like") : UIImage.init(named: "ic_unlike"), for: .normal)
//                
//            }
//            ManageAPI.shared.likeProfile(currentUser.userId ?? "", partnerId: basicInfo.id ?? "") { error in
//                
//            }
//        }
//        else{
//            user.total_likes = user.total_likes - 1
//            user.likec = false
//            if user.accountType == .business{
//                btnLike.setImage(user.likec ? UIImage.init(named: "ic_liked1") : UIImage.init(named: "ic_like1"), for: .normal)
//            }
//            else{
//                btnLike.setImage(user.likec ? UIImage.init(named: "ic_like") : UIImage.init(named: "ic_unlike"), for: .normal)
//                
//            }
//            ManageAPI.shared.unlikeProfile(currentUser.userId ?? "", partnerId: basicInfo.id ?? "") { error in
//                
//            }
//        }
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let unblock = UIAlertAction(title: "Unblock User", style: .destructive) { (action) in
            guard let userId = AppSettings.shared.currentUser?.userId, let otherId = self.basicInfo?.id else  { return }
            self.showAlert(title: "Unblock", message: "Are you sure you want to unblock this user?", buttonTitles: ["No", "Yes"], highlightedButtonIndex: 1) { index in
                if index == 1 {
                    self.unblockUser(userId: userId, otherUserId: otherId)
                }
            }
        }
        
        let block = UIAlertAction(title: "Block User", style: .destructive) { (action) in
            self.handleAction(.block)
        }
        
        let report = UIAlertAction(title: "Report", style: .destructive) { (action) in
            self.handleAction(.report)
        }
        
        let favorite = UIAlertAction(title: favoriteStatus.description, style: favoriteStatus == FavoriteStatus.favorite ? .destructive : .default) { (action) in
            self.handleAction(.favorite)
        }
        
        let copy = UIAlertAction(title: "Copy Profile URL", style: .default) { (action) in
            self.handleAction(.copyURL)
        }
        
        let shareProfile = UIAlertAction(title: "Share this Profile", style: .default) { (action) in
            self.handleAction(.share)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if user?.block == true {
            alert.addAction(unblock)
        } else {
            alert.addAction(block)
        }
        alert.addAction(report)
        alert.addAction(favorite)
        alert.addAction(copy)
        alert.addAction(shareProfile)
        alert.addAction(cancel)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = []
        }
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func usernameAction(_ sender: Any) {
        guard let link = self.basicInfo?.profileUrl, !link.isEmpty else { return }
        print(link)
        if let url = URL.init(string: link){
            let vc = SFSafariViewController(url: url)
            self.present(vc, animated: true)
        }
    }
    @IBAction func zoomImageAction(_ sender: Any) {
        isZoom.toggle()
    }
    
    @IBAction func blockUserAction(_ sender: Any) {
        self.handleAction(.block)
    }
    
    @IBAction func favoriteAction(_ sender: UIButton) {
        self.handleAction(.favorite)
    }
    
    @IBAction func datingCircleAction(_ sender: Any) {
        self.handleAction(.dating)
    }
    
    @IBAction func sendMessageAction(_ sender: Any) {
        guard AppSettings.shared.currentUser != nil else {
            self.showLoginOption()
            return
        }
        
        let controller = MessageStreamViewController.instantiate()
        controller.friendUser = basicInfo
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func requestAction(_ sender: Any) {
        guard AppSettings.shared.currentUser != nil else {
            self.showLoginOption()
            return
        }
        
        guard let user = user else { return }
        switch user.status {
        case .no:
            self.showAlert(title: "Are you sure you want to add this person in your Circle?", message: "", buttonTitles: ["Cancel", "Yes"], highlightedButtonIndex: 1) { (index) in
                if index == 1 {
                    self.sendRequest()
                }
            }
        case .sentPending:
            guard let id = user.idd else { return }
            self.showAlert(title: "Are you sure you want to cancel this request?", message: "", buttonTitles: ["No", "Yes"], highlightedButtonIndex: 1) { (index) in
                if index == 1 {
                    self.declineRequest(requestId: id)
                }
            }
        case .receivedPending:
            guard let id = user.idd else { return }
            self.acceptRequest(requestId: id)
        case .inner:
            break
        }
    }
    
    @IBAction func albumAction(_ sender: Any) {
        self.handleAction(.album)
    }
    
    @IBAction func resumeAction(_ sender: Any) {
        self.handleAction(.resume)
    }
    
    @IBAction func blogAction(_ sender: Any) {
        self.handleAction(.blog)
    }
    
    @IBAction func jobOfferAction(_ sender: Any) {
        self.handleAction(.job)
    }
    
    @IBAction func viewReviewAction(_ sender: Any) {
        self.handleAction(.reviews)
    }
    
    @IBAction func showCircleListAction(_ sender: Any) {
        self.handleAction(.viewInnerCircle)
    }
    
    @IBAction func didTapTravelButton(_ sender: Any) {
        self.handleAction(.travel)
    }
    
    @IBAction func didTapDineoutButton(_ sender: Any) {
        self.handleAction(.dineout)
    }
    
    @IBAction func copyUserNameAction(_ sender: Any) {
        guard AppSettings.shared.currentUser != nil else {
            self.showLoginOption()
            return
        }
        guard let username = basicInfo?.username else { return }
        UIPasteboard.general.string = username
        self.view.makeToast("Username is copied.")
    }
    
    @IBAction func referralCreditAction(_ sender: Any) {
        guard let username = basicInfo?.username else { return }
        let urlString = "https://www.circlecue.com/user/join?id=\(username)"
        self.showOutsideAppWebContent(urlString: urlString)
    }
    
    @IBAction func didTapBackMenuButton(_ sender: Any) {
        guard AppSettings.shared.currentUser != nil else {
            let controller = LoginVC.instantiate(from: StoryboardName.authentication.rawValue)
            self.navigationController?.pushViewController(controller, animated: true)
            return
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func didTapViewFollowing(_ sender: Any) {
        guard AppSettings.shared.currentUser != nil else {
            self.showLoginOption()
            return
        }
        let controller = FollowingViewController.instantiate()
        controller.basicInfo = basicInfo
        controller.followingStatus = .following
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func didTapViewFollower(_ sender: Any) {
        guard AppSettings.shared.currentUser != nil else {
            self.showLoginOption()
            return
        }
        let controller = FollowingViewController.instantiate()
        controller.basicInfo = basicInfo
        controller.followingStatus = .followers
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func didTapFollowingButton(_ sender: Any) {
        guard AppSettings.shared.currentUser != nil else {
            self.showLoginOption()
            return
        }
        
        guard let friend = user, let friendId = friend.userId, let userId = AppSettings.shared.userLogin?.userId else { return }
        self.followingButton.isUserInteractionEnabled = true
        
        if isFollowing {
            ManageAPI.shared.unFollowUser(fromUser: userId, toUser: friendId) { [weak self] error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.followingButton.isUserInteractionEnabled = true
                    guard error == nil else {
                        self.showErrorAlert(message: error)
                        return
                    }
                    self.isFollowing = false
                    friend.isfollowingcount = 0
                    friend.followercount = max(0, friend.followercount-1)
                    self.numberFollowerButton.setButtonTitle(title: friend.followerDisplay)
                }
            }
        } else {
            ManageAPI.shared.addFollowingUser(fromUser: userId, toUser: friendId) { [weak self] error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.followingButton.isUserInteractionEnabled = true
                    guard error == nil else {
                        self.showErrorAlert(message: error)
                        return
                    }
                    self.isFollowing = true
                    friend.followercount += 1
                    friend.isfollowingcount = 1
                    self.numberFollowerButton.setButtonTitle(title: friend.followerDisplay)
                }
            }
        }
    }
}

// MARK: - SETUP UI

extension FriendProfileViewUserNameController {
    
    private func setup() {
        setupUI()
        updateUI()
    }
    
    private func setupUI() {
        scrollView.alpha = 0
        bottomStackView.alpha = 0
        accountTypeLabel.text = ""
        
        isFollowing = false
        innerCirlceStatusButton.titleLabel?.textAlignment = .center
        innerCirlceStatusButton.titleLabel?.text = innerCircleStatus.description
        innerCirlceStatusButton.setTitle(innerCircleStatus.description, for: .normal)
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.layer.borderWidth = 1.5
        circleNumberView.layer.borderColor = UIColor.white.cgColor
        
    }
    
    
    
    private func updateUI() {
        guard let user = basicInfo else { return }
        avatarImageView.setImage(with: user.pic ?? self.user?.pic ?? "")
        userNameLabel.text = user.username
        locationLabel.text = user.country
        flagLabel.text = user.country?.flagIcon
        lblLink.text = user.profileUrl
        lblDescHtml.text = "Copy this source code and paste it on your website. It will display the CircleCue logo linked directly to your profile. You can also display your profile link on other social media apps as @CircleCue/" + (user.username ?? "")
    }
    
    private func updatePrivateSection(user: UserInfomation?, userId: String) {
        guard let user = user else { return }
        for button in profileTypeButtons {
            button.personalAccount = user.accountType == .personal ? true : false
        }
        
        followingButton.personalAccount = user.accountType == .personal ? true : false
        
        UIView.animate(withDuration: 0.2) {
            self.scrollView.alpha = 1
            self.bottomStackView.alpha = 1
        }
        
        accountTypeLabel.text = self.user?.accountType.text
        locationLabel.text = self.user?.locationInfomation
        flagLabel.text = user.country?.flagIcon
        userNameLabel.text = user.username
        circleNumberView.isHidden = user.hideCircleInnerNumber
        circleNumberLabel.text = "\(user.totalcircle)"
        numberFollowingButton.setButtonTitle(title: user.followingDisplay)
        numberFollowerButton.setButtonTitle(title: user.followerDisplay)
        lblHtml.text = user.html
        isFollowing = user.isfollowingcount == 1
        stackVip.isHidden = !user.premium
        let creditTitle = "CLICK HERE to Join CircleCue for Credit to \(user.username ?? "")"
        creditButton.titleLabel?.text = creditTitle
        creditButton.setTitle(creditTitle, for: .normal)
        if user.accountType == .business{
            btnLike.setImage(UIImage.init(named: "ic_liked1"), for: .normal)
        }
        else{
            
            btnLike.setImage(UIImage.init(named: "ic_like"), for: .normal)
        }
    }
    
    private func updateUserSocial(userId: String?, otherUserId: String) {
        guard let user = user else { return }
        avatarImageView.setImage(with: self.user?.pic ?? "")
        favoriteStatus = user.favc ? .favorite : .unFavorite
        
        innerCircleStatus = user.status
        
        if user.block {
            self.showAlert(title: "You have blocked this user", message: "Do you want to unblock?", buttonTitles: ["Not Now", "Unblock User"], highlightedButtonIndex: 1) { (index) in
                if index == 0 {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.unblockUser(userId: userId ?? "", otherUserId: otherUserId)
                }
            }
            
            return
        }
        let items = DummyData.share.getSocialItem(with: user)
    }
    
    private func showLoginOption() {
        popupBackground = UIView(frame: self.view.frame)
        popupBackground?.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        popupBackground?.alpha = 0
        
        let expectWidth = max(UIScreen.main.bounds.width - 30, 320)
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
    
    private func handleAction(_ action: ProfileActionType) {
        guard AppSettings.shared.currentUser != nil else {
            self.showLoginOption()
            return
        }
        
        switch action {
        case .viewInnerCircle:
            let controler = InnerCircleViewController.instantiate()
            controler.basicInfo = self.basicInfo
            self.navigationController?.pushViewController(controler, animated: true)
        case .album:
            let controller = AlbumViewController.instantiate()
            controller.basicInfo = basicInfo
            navigationController?.pushViewController(controller, animated: true)
        case .resume:
            let controller = ResumeViewController.instantiate()
            controller.user = self.user
            navigationController?.pushViewController(controller, animated: true)
        case .reviews:
            guard let user = self.user else { return }
            if user.accountType == .business {
                let controller = ViewBusinessReviewViewController.instantiate()
                controller.businessUserId = basicInfo?.id
                navigationController?.pushViewController(controller, animated: true)
            } else {
                let controller = ViewPersonalReviewViewController.instantiate()
                controller.personalUserId = basicInfo?.id
                navigationController?.pushViewController(controller, animated: true)
            }
        case .blog:
            let controller = JobOffersViewController.instantiate()
            controller.viewerId = basicInfo?.id
            controller.viewType = .blog
            navigationController?.pushViewController(controller, animated: true)
        case .job:
            let controller = JobOffersViewController.instantiate()
            controller.viewerId = basicInfo?.id
            controller.viewType = .jobOffer
            navigationController?.pushViewController(controller, animated: true)
        case .block:
            self.showAlert(title: "Block", message: "Are you sure you want to block this user?", buttonTitles: ["No", "Yes"], highlightedButtonIndex: 1) { (index) in
                if index == 1 {
                    self.blockUser()
                }
            }
        case .dating:
            self.showAlert(title: "Dating Circle", message: "Would you like to send a message to this user to explore Dating Circle with this user?", buttonTitles: ["No", "Yes"], highlightedButtonIndex: 1) { (index) in
                if index == 1 {
                    self.sendDatingRequest()
                }
            }
        case .travel:
            self.showAlert(title: "Travel Circle", message: "Would you like to send a message to this user to explore Travel Circle with this user?", buttonTitles: ["No", "Yes"], highlightedButtonIndex: 1) { (index) in
                if index == 1 {
                    self.sendTravelRequest()
                }
            }
        case .dineout:
            self.showAlert(title: "Dine out Circle", message: "Would you like to send a message to this user to explore Dine out Circle with this user?", buttonTitles: ["No", "Yes"], highlightedButtonIndex: 1) { (index) in
                if index == 1 {
                    self.sendDineoutRequest()
                }
            }
        case .favorite:
            switch favoriteStatus {
            case .favorite:
                self.removeFavorite()
            case .unFavorite:
                self.addFavorite()
            }
        case .report:
            let controller = HelpViewController.instantiate()
            controller.shouldBack = true
            self.navigationController?.pushViewController(controller, animated: true)
        case .copyURL:
            guard let link = self.basicInfo?.profileUrl, !link.isEmpty else { return }
            UIPasteboard.general.string = link
            self.view.makeToast("Profile link is copied.")
        case .share:
            let activityItems: [Any] = [self.basicInfo?.profileUrl as Any]
            let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            if UIDevice.current.userInterfaceIdiom == .pad {
                activityVC.popoverPresentationController?.sourceView = self.view
                activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
            }
            DispatchQueue.main.async {
                self.present(activityVC, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - NETWORKING

extension FriendProfileViewUserNameController {
    
    private func increaseProfileViewer() {
        guard let userId = basicInfo?.id else { return }
        ManageAPI.shared.increaseProfileViewer(userId: userId) { error in
            LOG("\(String(describing: error))")
        }
    }
    
    private func fetchUserPrivacy() {
        guard let userId = AppSettings.shared.userLogin?.userId, let otherId = basicInfo?.id else { return }
        showSimpleHUD(text: nil, fromView: self.navigationController?.view)
        ManageAPI.shared.fetchPrivacy(otherId, partnerId: userId) {[weak self] (userInfo) in
            guard let self = self else { return }
            self.privacyUser = userInfo
            self.fetchUserData()
        }
    }
    
  
    
    private func fetchUserData() {
        fetchUserInfo()
    }
    
    private func fetchUserInfo() {
        guard let otherId = basicInfo?.id else { return }
        let userId = AppSettings.shared.userLogin?.userId
        showSimpleHUD(text: nil, fromView: self.navigationController?.view)
        ManageAPI.shared.viewUserProfile(userId, otherUserId: otherId) {[weak self] (user, error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                guard let user = user else {
                    self.showErrorAlert(title: "Oops!", message: error)
                    return
                }
                
                guard !user.block_me else {
                    self.showAlert(title: "Profile Blocking is Active", message: nil, buttonTitles: ["OK"], highlightedButtonIndex: 0) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    return
                }
                
                self.user = user.mergeUser(with: self.privacyUser)
                self.updatePrivateSection(user: self.user, userId: otherId)
                self.updateUserSocial(userId: userId, otherUserId: otherId)
            }
        }
    }
    
 
    
    private func unblockUser(userId: String, otherUserId: String) {
        showSimpleHUD(text: nil, fromView: self.navigationController?.view)
        ManageAPI.shared.unblockUser(userId, otherUserId) {[weak self] (error) in
            guard let self = self else { return }
            if let err = error {
                self.hideLoading()
                self.showAlert(title: "Oops!", message: "\(err)\nSomething went wrong. Please try again later.", buttonTitles: ["OK"], highlightedButtonIndex: nil) { (_) in
                    self.navigationController?.popViewController(animated: true)
                }
                return
            }
            
            self.fetchUserInfo()
        }
    }
    
    private func blockUser() {
        guard let userId = AppSettings.shared.userLogin?.userId, let otherUserId = basicInfo?.id else { return }
        showSimpleHUD(text: nil, fromView: self.navigationController?.view)
        ManageAPI.shared.blockUser(userId, otherUserId) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            if let err = error {
                self.showErrorAlert(message: err)
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func addFavorite() {
        guard let userId = AppSettings.shared.userLogin?.userId, let otherUserId = basicInfo?.id else { return }
        showSimpleHUD(text: nil, fromView: self.navigationController?.view)
        ManageAPI.shared.addFavoriteUser(userId, otherUserId) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            if let err = error {
                self.showErrorAlert(message: err)
                return
            }
            self.favoriteStatus = .favorite
            self.delegate?.updateList()
        }
    }
    
    private func removeFavorite() {
        guard let userId = AppSettings.shared.userLogin?.userId, let otherUserId = basicInfo?.id else { return }
        showSimpleHUD(text: nil, fromView: self.navigationController?.view)
        ManageAPI.shared.removeFavoriteUser(userId, otherUserId) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            if let err = error {
                self.showErrorAlert(message: err)
                return
            }
            self.favoriteStatus = .unFavorite
            self.delegate?.updateList()
        }
    }
    
    private func sendRequest() {
        guard let userId = AppSettings.shared.userLogin?.userId, let otherId = basicInfo?.id else { return }
        showSimpleHUD(text: nil, fromView: self.navigationController?.view)
        ManageAPI.shared.sendCircleRequest(userId, otherId) { [weak self] (error) in
            guard let self = self else { return }
            if let err = error {
                self.hideLoading()
                self.showErrorAlert(message: err)
                return
            }
            self.fetchUserInfo()
            self.innerCircleStatus = .sentPending
            self.user?.status = .sentPending
            self.delegate?.updateList()
        }
    }
    
    private func declineRequest(requestId: String) {
        showSimpleHUD(text: nil, fromView: self.navigationController?.view)
        ManageAPI.shared.declineCircleRequest(requestId) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            if let err = error {
                self.showErrorAlert(message: err)
                return
            }
            
            self.user?.status = .no
            self.innerCircleStatus = .no
            self.delegate?.updateList()
        }
    }
    
    private func acceptRequest(requestId: String) {
        showSimpleHUD(text: nil, fromView: self.navigationController?.view)
        ManageAPI.shared.acceptCircleRequest(requestId) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            if let err = error {
                self.showErrorAlert(message: err)
                return
            }
            
            self.user?.status = .inner
            self.innerCircleStatus = .inner
            self.delegate?.updateList()
        }
    }
    
   
    private func sendDatingRequest() {
        guard let userId = AppSettings.shared.userLogin?.userId, let friendId = basicInfo?.id else { return }
        let para: Parameters = ["sid": userId, "rid": friendId, "msg": Constants.DATING_CIRCLE_REQUEST_MESSSAGE]
        showSimpleHUD(text: "Sending...")
        ManageAPI.shared.sendMessageToUser(para: para) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            if let err = error {
                self.showErrorAlert(message: err)
                return
            }
            self.showAlert(title: "CircleCue", message: "Your request is sent.")
       
        }
    }
    
//    private func updateDatingStatus(data: UserCircleObject) {
//        let para: Parameters = ["id": data.id, "status": (data.dating_status ?? false) ? "0" : "1"]
//        ManageAPI.shared.updateDatingStatusBetweenUsers(para) {[weak self] (error) in
//            guard let self = self else { return }
//            if let err = error {
//                return self.showErrorAlert(message: err)
//            }
//
//            DispatchQueue.main.async {
//                self.datingCircleButton.isHidden = true
//            }
//        }
//    }
    
  
    
    private func addDatingStatusForPartner(myId: String, parnerId: String) {
        let para: Parameters = ["id2": myId, "id": parnerId, "status": "1"]
        ManageAPI.shared.addDatingStatusBetweenUsers(para) { (error) in
            print("Update dating circle status for partner with error = \(String(describing: error))")
        }
    }
    
    private func sendTravelRequest() {
        guard let userId = AppSettings.shared.userLogin?.userId, let friendId = basicInfo?.id else { return }
        let para: Parameters = ["sid": userId, "rid": friendId, "msg": Constants.TRAVEL_CIRCLE_REQUEST_MESSSAGE]
        showSimpleHUD(text: "Sending...")
        ManageAPI.shared.sendMessageToUser(para: para) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            if let err = error {
                self.showErrorAlert(message: err)
                return
            }
            self.showAlert(title: "CircleCue", message: "Your request is sent.")
            self.addTravelStatus()
        }
    }
    
    private func addTravelStatus() {
        guard let userId = AppSettings.shared.userLogin?.userId, let friendId = basicInfo?.id else { return }
        let para: Parameters = ["id": userId, "id2": friendId, "status": "1"]
        ManageAPI.shared.addTravelStatusBetweenUsers(para) {[weak self] (error) in
            guard let self = self else { return }
            if let err = error {
                return self.showErrorAlert(message: err)
            }
            self.addTravelStatusForPartner(myId: userId, parnerId: friendId)
          
        }
    }
    
    private func addTravelStatusForPartner(myId: String, parnerId: String) {
        let para: Parameters = ["id2": myId, "id": parnerId, "status": "1"]
        ManageAPI.shared.addTravelStatusBetweenUsers(para) { (error) in
            print("Update travel circle status for partner with error = \(String(describing: error))")
        }
    }
    
    private func sendDineoutRequest() {
        guard let userId = AppSettings.shared.userLogin?.userId, let friendId = basicInfo?.id else { return }
        let para: Parameters = ["sid": userId, "rid": friendId, "msg": Constants.DINEOUT_CIRCLE_REQUEST_MESSSAGE]
        showSimpleHUD(text: "Sending...")
        ManageAPI.shared.sendMessageToUser(para: para) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            if let err = error {
                self.showErrorAlert(message: err)
                return
            }
            self.addDineOutStatus()
            self.showAlert(title: "CircleCue", message: "Your request is sent.")
        }
    }
    
    private func addDineOutStatus() {
        guard let userId = AppSettings.shared.userLogin?.userId, let friendId = basicInfo?.id else { return }
        let para: Parameters = ["id": userId, "id2": friendId, "status": "1"]
        ManageAPI.shared.addDinnerStatusBetweenUsers(para) {[weak self] (error) in
            guard let self = self else { return }
            if let err = error {
                return self.showErrorAlert(message: err)
            }
            self.addDineOutStatusForPartner(myId: userId, parnerId: friendId)
          
        }
    }
    
    private func addDineOutStatusForPartner(myId: String, parnerId: String) {
        let para: Parameters = ["id2": myId, "id": parnerId, "status": "1"]
        ManageAPI.shared.addDinnerStatusBetweenUsers(para) { (error) in
            print("Update travel circle status for partner with error = \(String(describing: error))")
        }
    }
    
   
   
}



extension FriendProfileViewUserNameController: LoginPopupViewDelegate {
    func performAction(_ action: LoginPopupAction) {
        closeLoginView(action)
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
    
    private func redirect(_ action: LoginPopupAction) {
        switch action {
        case .join:
            AppSettings.shared.discoverUser = self.basicInfo
            let controller = RegisterViewController.instantiate(from: StoryboardName.authentication.rawValue)
            var viewControllers = [UIViewController]()
            if let viewController = navigationController?.viewControllers {
                viewControllers = viewController
            }
            viewControllers.append(LoginVC.instantiate(from: StoryboardName.authentication.rawValue))
            viewControllers.append(controller)
            self.navigationController?.setViewControllers(viewControllers, animated: true)
        case .login:
            AppSettings.shared.discoverUser = self.basicInfo
            let controller = LoginVC.instantiate(from: StoryboardName.authentication.rawValue)
            self.navigationController?.pushViewController(controller, animated: true)
        default:
            break
        }
    }
}
