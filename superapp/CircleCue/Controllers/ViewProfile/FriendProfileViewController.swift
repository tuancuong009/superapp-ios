//
//  FriendProfileViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/13/20.
//

import UIKit
import Alamofire
import DTPhotoViewerController
import AVKit
import SafariServices
enum ProfileActionType {
    case viewInnerCircle
    case album
    case resume
    case reviews
    case blog
    case job
    case block
    case report
    case dating
    case favorite
    case copyURL
    case share
    case travel
    case dineout
    
    var image: UIImage? {
        switch self {
        case .album:
            return #imageLiteral(resourceName: "bt_album")
        case .dating:
            return #imageLiteral(resourceName: "bt_dc")
        case .resume:
            return #imageLiteral(resourceName: "bt_resume")
        case .reviews:
            return #imageLiteral(resourceName: "bt_reviews")
        case .job:
            return #imageLiteral(resourceName: "bt_job")
        case .blog:
            return #imageLiteral(resourceName: "bt_blog")
        default:
            return nil
        }
    }
}

class FriendProfileViewController: BaseViewController {

    @IBOutlet weak var accountTypeLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var userBioTextView: UITextView!
    @IBOutlet weak var flagLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var innerCirlceStatusButton: UIButton!
    @IBOutlet weak var datingCircleButton: UIButton!
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var blogButton: UIButton!
    @IBOutlet weak var jobOfferButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var profileInfoStack: UIStackView!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var travelButton: UIButton!
    @IBOutlet weak var dineoutButton: UIButton!
    @IBOutlet weak var circleNumberLabel: UILabel!
    @IBOutlet weak var albumCollectionView: UICollectionView!
    @IBOutlet weak var albumCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var customLinkCollectionView: UICollectionView!
    @IBOutlet weak var customLinkCollectionHeight: NSLayoutConstraint!
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
    @IBOutlet weak var nameLabel: UILabel!
    
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
    var isPresentProfile = false
    var innerCircleStatus: InnerCircleStatus = .no {
        didSet {
            guard isViewLoaded else { return }
            innerCirlceStatusButton.titleLabel?.text = innerCircleStatus.description
            innerCirlceStatusButton.setTitle(innerCircleStatus.description, for: .normal)
        }
    }
    var favoriteStatus: FavoriteStatus = .unFavorite
    
    var socialItems: [HomeSocialItem] = [] {
        didSet {
            let rows = socialItems.count/3 + (socialItems.count%3 > 0 ? 1 : 0)
            collectionViewHeight.constant = CGFloat(rows) * ProfileSocialCollectionViewCell.size.height
            collectionView.reloadData()
        }
    }
    
    var customLinks: [CustomLink] = [] {
        didSet {
            let rows = customLinks.count/2 + (customLinks.count%2 > 0 ? 1 : 0)
            customLinkCollectionHeight.constant = CGFloat(rows) * CustomLinkCollectionViewCell.cellSize.height
            customLinkCollectionView.reloadData()
        }
    }
    
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
    @IBAction func doTotalLinke(_ sender: Any) {
        let controler = InnerCircleViewController.instantiate()
        controler.basicInfo = self.basicInfo
        controler.isTotalLikeProfile = true
        self.navigationController?.pushViewController(controler, animated: true)
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        if self.isPresentProfile{
            self.dismiss(animated: true) {
                
            }
        }
        else{
            navigationController?.popViewController(animated: true)
        }
       
        self.didDismisController?()
    }
    @IBAction func didTabLike(_ sender: Any) {
//        guard  let currentUser = AppSettings.shared.userLogin else {
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
        let controller = FriendProfileViewUserNameController.instantiate()
        controller.basicInfo = self.basicInfo
        navigationController?.pushViewController(controller, animated: true)
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
        if let vc = navigationController?.viewControllers.first(where: {$0 is NewHomeViewController}) {
            navigationController?.popToViewController(vc, animated: true)
        }
        else{
            self.navigationController?.pushViewController(NewHomeViewController.instantiate(), animated: true)
        }
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

extension FriendProfileViewController {
    
    private func setup() {
        setupUI()
        setupAlbumCollectionView()
        setupCollectionView()
        setupCustomLinkCollectionView()
        updateUI()
    }
    
    private func setupUI() {
        scrollView.alpha = 0
        bottomStackView.alpha = 0
        accountTypeLabel.text = ""
        
        isFollowing = false
                
        albumCollectionHeight.constant = (UIScreen.main.bounds.width - 60)/3
        albumCollectionView.isHidden = true

        innerCirlceStatusButton.titleLabel?.numberOfLines = 0
        innerCirlceStatusButton.titleLabel?.lineBreakMode = .byWordWrapping
        innerCirlceStatusButton.titleLabel?.textAlignment = .center
        innerCirlceStatusButton.titleLabel?.text = innerCircleStatus.description
        innerCirlceStatusButton.setTitle(innerCircleStatus.description, for: .normal)
        blogButton.titleLabel?.adjustsFontSizeToFitWidth = true
        blogButton.titleLabel?.minimumScaleFactor = 0.7
        
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.layer.borderWidth = 1.5
        circleNumberView.isHidden = true
        circleNumberView.layer.cornerRadius = 15.0
        circleNumberView.layer.borderWidth = 1.5
        circleNumberView.layer.borderColor = UIColor.white.cgColor
        
        userBioTextView.font = UIFont.myriadProRegular(ofSize: 17)
        userBioTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                              NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                              NSAttributedString.Key.underlineColor: UIColor.white]
        userBioTextView.textContainerInset = UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 16)
        
        datingCircleButton.isHidden = true
        profileInfoStack.isHidden = true
        socialItems = []
        customLinks = []
    }
    
    private func setupAlbumCollectionView() {
        albumCollectionView.registerNibCell(identifier: ProfileAlbumCollectionViewCell.identifier)
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
    }
    
    private func setupCollectionView() {
        collectionView.registerNibCell(identifier: ProfileSocialCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupCustomLinkCollectionView() {
        customLinkCollectionView.registerNibCell(identifier: CustomLinkCollectionViewCell.identifier)
        customLinkCollectionView.delegate = self
        customLinkCollectionView.dataSource = self
    }
    
    private func updateUI() {
        guard let user = basicInfo else { return }
        avatarImageView.setImage(with: user.pic ?? self.user?.pic ?? "")
        userNameLabel.text = user.username
        
        locationLabel.text = user.country
        flagLabel.text = user.country?.flagIcon
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
        userBioTextView.text = user.bio
        userBioTextView.isHidden = user.bio.trimmed.isEmpty
        profileInfoStack.isHidden = false
        reviewButton.isHidden = user.hideReview
        circleNumberView.isHidden = user.hideCircleInnerNumber
        circleNumberLabel.text = "\(user.totalcircle)"
        resumeButton.isHidden = user.hideResume
        blogButton.isHidden = user.hideBlog
        jobOfferButton.isHidden = user.hideJob
        numberFollowingButton.setButtonTitle(title: user.followingDisplay)
        numberFollowerButton.setButtonTitle(title: user.followerDisplay)
        isFollowing = user.isfollowingcount == 1
        stackVip.isHidden = !user.premium
        nameLabel.text = (user.fname ?? "") + " " +  (user.lname ?? "")
        if nameLabel.text!.trimmed.isEmpty{
            nameLabel.isHidden = true
        }
        else{
            nameLabel.isHidden = false
        }
        let creditTitle = "CLICK HERE to Join CircleCue for Credit to \(user.username ?? "")"
        creditButton.titleLabel?.text = creditTitle
        creditButton.setTitle(creditTitle, for: .normal)
        if user.accountType == .business{
            btnLike.setImage(UIImage.init(named: "ic_liked1"), for: .normal)
        }
        else{
            
            btnLike.setImage(UIImage.init(named: "ic_like"), for: .normal)
        }
        if user.status == .inner || user.album_status == false {
            if user.album_count == 0 {
                albumButton.isHidden = true
            } else {
                albumButton.isHidden = false
                self.fetchPhoto(userId: userId)
            }
        } else {
            albumButton.isHidden = true
        }
        
        if user.accountType == .business || user.travel_status == nil || user.travel_status == false {
            travelButton.isHidden = true
        } else {
            travelButton.isHidden = false
        }
        
        if user.accountType == .business || user.dinner_status == nil || user.dinner_status == false {
            dineoutButton.isHidden = true
        } else {
            dineoutButton.isHidden = false
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
        socialItems = items.filter({ $0.shouldHide == false})
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

extension FriendProfileViewController {
    
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
    
    private func handleUserCircle(_ user: UserInfomation) {
        guard let currentUser = AppSettings.shared.currentUser else { return }
        if currentUser.accountType == .business || user.accountType == .business {
            self.datingCircleButton.isHidden = true
            self.travelButton.isHidden = true
            self.dineoutButton.isHidden = true
            return
        }
        if user.dating_status == false && user.travel_status == false && user.dinner_status == false {
            self.datingCircleButton.isHidden = true
            self.travelButton.isHidden = true
            self.dineoutButton.isHidden = true
            return
        }
        self.fetchCircleStatus(user: user)
    }
    
    private func fetchUserData() {
        fetchUserInfo()
        fetchCustomLink()
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
                self.handleUserCircle(user)
                self.updateUserSocial(userId: userId, otherUserId: otherId)
            }
        }
    }
    
    private func fetchCustomLink() {
        guard let userId = basicInfo?.id else { return }
        ManageAPI.shared.fetchUserCustomLink(userId) {[weak self] (results) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.customLinks = results.filter({ !$0.isPrivate })
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
    
    private func fetchCircleStatus(user: UserInfomation) {
        guard let userId = AppSettings.shared.userLogin?.userId, let friendId = basicInfo?.id else { return }
        let para: Parameters = ["id": userId, "id2": friendId]
        ManageAPI.shared.getUserCircleStatusBetweenUsers(para) {[weak self] (data, error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard let data = data else {
                    self.datingCircleButton.isHidden = (user.accountType == .business || user.dating_status == false)
                    if user.accountType == .business || user.travel_status == nil || user.travel_status == false {
                        self.travelButton.isHidden = true
                    } else {
                        self.travelButton.isHidden = false
                    }
                    if user.accountType == .business || user.dinner_status == nil || user.dinner_status == false {
                        self.dineoutButton.isHidden = true
                    } else {
                        self.dineoutButton.isHidden = false
                    }
                    LOG("Error = \(String(describing: error))")
                    return
                }
                
                if data.dating_status == nil {
                    self.datingCircleButton.isHidden = (user.accountType == .business || user.dating_status == false)
                } else {
                    self.datingCircleButton.isHidden = true
                }
                
                if data.travel_status == nil {
                    if user.accountType == .business || user.travel_status == nil || user.travel_status == false {
                        self.travelButton.isHidden = true
                    } else {
                        self.travelButton.isHidden = false
                    }
                } else {
                    self.travelButton.isHidden = true
                }
                if data.dine_status == nil {
                    if user.accountType == .business || user.dinner_status == nil || user.dinner_status == false {
                        self.dineoutButton.isHidden = true
                    } else {
                        self.dineoutButton.isHidden = false
                    }
                } else {
                    self.dineoutButton.isHidden = true
                }
            }
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
            self.addDatingStatus()
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
    
    private func addDatingStatus() {
        guard let userId = AppSettings.shared.userLogin?.userId, let friendId = basicInfo?.id else { return }
        let para: Parameters = ["id": userId, "id2": friendId, "status": "1"]
        ManageAPI.shared.addDatingStatusBetweenUsers(para) {[weak self] (error) in
            guard let self = self else { return }
            if let err = error {
                return self.showErrorAlert(message: err)
            }
            self.addDatingStatusForPartner(myId: userId, parnerId: friendId)
            DispatchQueue.main.async {
                self.datingCircleButton.isHidden = true
            }
        }
    }
    
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
            DispatchQueue.main.async {
                self.travelButton.isHidden = true
            }
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
            DispatchQueue.main.async {
                self.dineoutButton.isHidden = true
            }
        }
    }
    
    private func addDineOutStatusForPartner(myId: String, parnerId: String) {
        let para: Parameters = ["id2": myId, "id": parnerId, "status": "1"]
        ManageAPI.shared.addDinnerStatusBetweenUsers(para) { (error) in
            print("Update travel circle status for partner with error = \(String(describing: error))")
        }
    }
    
    
    private func fetchPhoto(userId: String) {
        ManageAPI.shared.fetchGallery(userId: userId) {[weak self] (results, error) in
            guard let self = self else { return }
            self.photos = results.sorted(by: {$0.timeInterval > $1.timeInterval})
            DispatchQueue.main.async {
                self.albumCollectionView.isHidden = self.photos.isEmpty
                self.albumCollectionView.reloadData()
                if self.photos.count > 3 {
                    self.setupTimer()
                }
            }
        }
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.runPhoto), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func runPhoto() {
        currentIndex += 1
        if currentIndex > self.photos.count - 2 {
            currentIndex = 0
        }
        let nextIndex = IndexPath(item: currentIndex, section: 0)
        self.albumCollectionView.scrollToItem(at: nextIndex, at: .centeredHorizontally, animated: currentIndex == 0 ? false : true)
    }
}

extension FriendProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.collectionView:
            return socialItems.count
        case customLinkCollectionView:
            return customLinks.count
        case albumCollectionView:
            return photos.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == customLinkCollectionView {
            print(indexPath)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomLinkCollectionViewCell.identifier, for: indexPath) as! CustomLinkCollectionViewCell
            cell.nameLabel.text = customLinks[indexPath.item].name
            return cell
        }
        
        if collectionView == albumCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileAlbumCollectionViewCell.identifier, for: indexPath) as! ProfileAlbumCollectionViewCell
            cell.setup(photos[indexPath.row])
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileSocialCollectionViewCell.identifier, for: indexPath) as! ProfileSocialCollectionViewCell
        cell.setup(socialItems[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == customLinkCollectionView {
            return CustomLinkCollectionViewCell.cellSize
        }
        
        if collectionView == albumCollectionView {
            return ProfileAlbumCollectionViewCell.cellSize
        }
        
        return ProfileSocialCollectionViewCell.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard AppSettings.shared.currentUser != nil else {
            self.showLoginOption()
            return
        }
        
        if collectionView == albumCollectionView {
            guard indexPath.item < photos.count, let cell = collectionView.cellForItem(at: indexPath) as? ProfileAlbumCollectionViewCell else { return }
            selectedImageIndex = indexPath.item
            let viewController = CustomPhotoViewerController(referencedView: cell.photoImageView, image: cell.photoImageView.image)
            viewController.data = self.photos
            viewController.dataSource = self
            viewController.delegate = self
            viewController.isHiddenShare = true
            viewController.customDelegate = self
            present(viewController, animated: true, completion: nil)
            self.stopTimer()
            return
        }
        
        if collectionView == customLinkCollectionView {
            guard indexPath.row < customLinks.count else { return }
            showOutsideAppWebContent(urlString: customLinks[indexPath.row].link)
            return
        }
        
        guard indexPath.item < socialItems.count else { return }
        let item = socialItems[indexPath.item]
        self.viewUserSocialProfile(with: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == albumCollectionView {
            return 20
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == albumCollectionView {
            return 20
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == customLinkCollectionView {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        
        if collectionView == albumCollectionView {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        
        return UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
    }
}

// MARK: - DTPhotoViewerControllerDataSource
extension FriendProfileViewController: DTPhotoViewerControllerDataSource {
    
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, configureCell cell: DTPhotoCollectionViewCell, forPhotoAt index: Int) {
        if let cell = cell as? CustomPhotoCollectionViewCell {
            let item = photos[index]
            cell.cellDelegate = photoViewerController as? CustomPhotoViewerController
            cell.setup(item)
        }
    }
    
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, referencedViewForPhotoAt index: Int) -> UIView? {
        let indexPath = IndexPath(item: index, section: 0)
        if let cell = albumCollectionView.cellForItem(at: indexPath) as? ProfileAlbumCollectionViewCell {
            return cell.photoImageView
        }
        
        return nil
    }
    
    func numberOfItems(in photoViewerController: DTPhotoViewerController) -> Int {
        return photos.count
    }
    
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, configurePhotoAt index: Int, withImageView imageView: UIImageView) {
        let item = photos[index]
        if item.albumType == .video {
            imageView.image = PlaceHolderImage.video.image
            if let url = URL(string: item.pic) {
                VideoThumbnail.shared.getThumbnailImageFromVideoUrl(url: url) { (image) in
                    DispatchQueue.main.async {
                        if let image = image {
                            imageView.image = image
                        } else {
                            imageView.image = PlaceHolderImage.video.image
                        }
                    }
                }
            }
        } else {
            imageView.setImage(with: item.pic, placeholderImage: .photo)
        }
    }
}

// MARK: - DTPhotoViewerControllerDelegate
extension FriendProfileViewController: DTPhotoViewerControllerDelegate {
    
    func photoViewerControllerDidEndPresentingAnimation(_ photoViewerController: DTPhotoViewerController) {
        photoViewerController.scrollToPhoto(at: selectedImageIndex, animated: false)
    }
    
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, didScrollToPhotoAt index: Int) {
        selectedImageIndex = index
        let indexPath = IndexPath(item: selectedImageIndex, section: 0)
        if !albumCollectionView.indexPathsForVisibleItems.contains(indexPath) {
            albumCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
}

extension FriendProfileViewController: CustomPhotoViewerControllerDelegate {
    
    func didDismisViewerController() {
        setupTimer()
    }
    
    func updateLikes(likes: [PhotoLike], for photo: Gallery) {
        if let index = self.photos.firstIndex(where: {$0.id == photo.id}) {
            self.photos[index].likes = likes
        }
    }
}

extension FriendProfileViewController: LoginPopupViewDelegate {
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
