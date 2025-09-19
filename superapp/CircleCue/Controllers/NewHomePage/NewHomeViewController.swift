//
//  NewHomeViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 29/10/2021.
//

import UIKit
import SwiftUI
class NewHomeViewController: BaseViewController {

    @IBOutlet weak var userAvatarImageView: RoundImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var personalSearchStackView: UIStackView!
    @IBOutlet weak var businessSearchStackView: UIStackView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
//    var newUserRegister = false
    
    private var menus: [MenuItem] = []
    private var isFirstLoad = true
    private var messageUnreadCount = 0
    private var notificationUnreadCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        AppSettings.shared.updateToken()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUnreadData()
        userAvatarImageView.setupUserAvatar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !isFirstLoad else {
            isFirstLoad = false
            return
        }
        fetchUserInfo()
    }
    
    @IBAction func didTapFeedTypeButton(_ sender: UIButton) {
        guard let feedType = FeedType(rawValue: sender.tag) else { return }
        let controller = NewFeedsViewController.instantiate()
        controller.currentType = feedType
        self.navigationController?.pushViewController(controller, animated: true)
      
    }
    
    @IBAction func didTapPersonalSearchTypeButton(_ sender: UIButton) {
        guard let searchType = SEARCHViewController.SearchType.init(rawValue: sender.tag) else { return }
        let controller = SEARCHViewController.instantiate()
        controller.searchType = searchType
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func didTapBusinessSearchTypeButton(_ sender: UIButton) {
        guard let searchType = SEARCHViewController.SearchType.init(rawValue: sender.tag) else { return }
        let controller = SEARCHViewController.instantiate()
        controller.searchType = searchType
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func diTapback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NewHomeViewController {
    private func setupUI() {
        userAvatarImageView.backgroundColor = .clear
        guard let user = AppSettings.shared.currentUser else { return }
        
        usernameLabel.text = user.username
        personalSearchStackView.isHidden = user.accountType != .personal
        businessSearchStackView.isHidden = !personalSearchStackView.isHidden
        
        setupMenu(user: user)
    }
    
    private func setupMenu(user: UserInfomation) {
        switch user.accountType {
        case .personal:
            menus  = [.dashboard, .GoLive, .premier_circle_showcase, .ForSale, .profile, .travelCircle, .mycirlce, .datingCircle, .album, .dineoutCircle, .message, .myResume, .circular_chat, .notes, .favorites, .status, .nearby, .logout, .help, .QA, .notification, .roomrently]
            
        case .business:
            menus = [.dashboard, .GoLive,
                     .premier_circle_showcase, .crowdFunding, .profile, .ForSale, .ourCircle, .blog, .album, .jobOffer, .message, .notes, .circular_chat, .business_review, .favorites, .status, .nearby, .logout, .help, .QA, .notification, .roomrently]
                
        }
    }
    
    private func setupCollectionView() {
        collectionView.registerNibCell(identifier: HomeMenuCollectionViewCell.identifier)
        collectionView.registerNibCell(identifier: "HomeMenuRoomrentlyCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset.bottom = 20
    }
    
    private func showLogout() {
        let alert = UIAlertController(title: "Logout", message: "Do you want to logout?", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            UIApplication.shared.applicationIconBadgeNumber = 0
            AppSettings.shared.reset()
            let navigationController = BaseNavigationController()
            navigationController.viewControllers = [PremierCircleShowcaseController.instantiate(), LoginVC.instantiate(from: StoryboardName.authentication.rawValue)]
            self.switchRootViewController(navigationController)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(logoutAction)
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
    
    private func openDiscoverUser() {
        guard let user = AppSettings.shared.discoverUser else { return }
        let controller = FriendProfileViewController.instantiate()
        controller.basicInfo = user
        navigationController?.pushViewController(controller, animated: true)
        AppSettings.shared.discoverUser = nil
    }
    
    private func fetchUserInfo() {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        ManageAPI.shared.fetchUserInfo(userId) {[weak self] (user, error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard let user = user else {
                    return
                }
                if user.is_verified {
                    AppSettings.shared.currentUser = user
                } else {
                    self.showAlert(title: "Oops!", message: "Your account is temporary disabled, please contact us for more information.", buttonTitles: ["OK"], highlightedButtonIndex: nil) { _ in
                        AppSettings.shared.reset()
                        let navigationController = BaseNavigationController()
                        navigationController.viewControllers = [PremierCircleShowcaseController.instantiate(), LoginVC.instantiate(from: StoryboardName.authentication.rawValue)]
                        self.switchRootViewController(navigationController)
                    }
                }
            }
        }
    }
    
    private func fetchNotificationList(group: DispatchGroup, userId: String) {
        group.enter()
        ManageAPI.shared.fetchNotification(for: userId) { (results, error) in
            let unseenNotifications = results.filter({ !$0.seen })
            self.notificationUnreadCount = unseenNotifications.count
            group.leave()
        }
    }
    
    private func fetchUnreadMessageCount(group: DispatchGroup, userId: String) {
        group.enter()
        ManageAPI.shared.fetchListRead(userId) { (number) in
            self.messageUnreadCount = number
            group.leave()
        }
    }
    
    private func fetchUnreadData() {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        let group = DispatchGroup()
        
        fetchUnreadMessageCount(group: group, userId: userId)
        fetchNotificationList(group: group, userId: userId)
        
        group.notify(queue: .main) {
            self.collectionView.reloadData()
           // UIApplication.shared.applicationIconBadgeNumber = self.notificationUnreadCount
        }
    }
    
//    private func showUserSouce() {
//        guard newUserRegister else { return }
//        let controller = UserSourceViewController.instantiate(from: StoryboardName.authentication.rawValue)
//        controller.modalTransitionStyle = .crossDissolve
//        controller.modalPresentationStyle = .overFullScreen
//        controller.didSubmit = { [weak self] in
//            self?.view.makeToast("Thank you for your assistance!")
//        }
//        newUserRegister = false
//        self.present(controller, animated: true, completion: nil)
//    }
}

extension NewHomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = menus[indexPath.item]
//        if item == .roomrently{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMenuRoomrentlyCollectionViewCell", for: indexPath) as! HomeMenuCollectionViewCell
//            
//            return cell
//        }
//        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeMenuCollectionViewCell.identifier, for: indexPath) as! HomeMenuCollectionViewCell
            cell.setup(menu: menus[indexPath.item], unreadMessage: messageUnreadCount, unreadNotification: notificationUnreadCount)
            
            if item == .GoLive{
                cell.menuNameLabel.textColor = .red
                cell.menuNameLabel.font = UIFont(name: FontName.semiBold.font, size: cell.menuNameLabel.font.pointSize)
            }
            else{
                cell.menuNameLabel.textColor = .white
                cell.menuNameLabel.font = UIFont(name: FontName.regular.font, size: cell.menuNameLabel.font.pointSize)
            }
            
            return cell
        //}
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2 , height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < menus.count else { return }
        let item = menus[indexPath.item]
        switch item {
        case .status:
            self.navigationController?.pushViewController(AccountStatusViewController.instantiate(), animated: true)
            
        case .dashboard:
            self.navigationController?.pushViewController(HomeViewController.instantiate(), animated: true)
        case .benifit:
            let urlString = "https://www.circlecue.com/benefits.php"
            self.showOutsideAppWebContent(urlString: urlString)
            
        case .feed:
            self.navigationController?.pushViewController(NewFeedsViewController.instantiate(), animated: true)
            
        case .profile:
            self.navigationController?.pushViewController(MyProfileViewController.instantiate(), animated: true)
            
        case .search:
            self.navigationController?.pushViewController(SEARCHViewController.instantiate(), animated: true)
            
        case .ourCircle:
            let controller = MyCircleViewController.instantiate()
            controller.type = .ourCircle
            self.navigationController?.pushViewController(controller, animated: true)
            
        case .mycirlce:
            let controller = MyCircleViewController.instantiate()
            controller.type = .mycirlce
            self.navigationController?.pushViewController(controller, animated: true)
            
        case .favorites:
            self.navigationController?.pushViewController(FavoritesViewController.instantiate(), animated: true)
            
        case .message:
            self.navigationController?.pushViewController(MessageViewController.instantiate(), animated: true)
            
        case .notes:
            self.navigationController?.pushViewController(NotesViewController.instantiate(), animated: true)
            
        case .myResume:
            self.navigationController?.pushViewController(ResumeViewController.instantiate(), animated: true)
            
        case .album:
            self.navigationController?.pushViewController(AlbumViewController.instantiate(), animated: true)
            
        case .jobOffer:
            let controller = JobOffersViewController.instantiate()
            controller.viewType = .jobOffer
            self.navigationController?.pushViewController(controller, animated: true)
            
        case .datingCircle:
            self.navigationController?.pushViewController(DatingCircleViewController.instantiate(), animated: true)
            
        case .dineoutCircle:
            self.navigationController?.pushViewController(DineoutCircleViewController.instantiate(), animated: true)
            
        case .travelCircle:
            self.navigationController?.pushViewController(TravelCircleViewController.instantiate(), animated: true)
            
        case .business_review:
            self.navigationController?.pushViewController(BusinessFeedbackViewController.instantiate(), animated: true)
            
        case .personal_review:
            self.navigationController?.pushViewController(PersonalFeedbackViewController.instantiate(), animated: true)
            
        case .nearby:
            self.navigationController?.pushViewController(NearByViewController.instantiate(), animated: true)
            
        case .changepassword:
            self.navigationController?.pushViewController(ChangePasswordViewController.instantiate(), animated: true)
            
        case .help:
            self.navigationController?.pushViewController(HelpViewController.instantiate(), animated: true)
            
        case .logout:
            self.showLogout()
            
        case .blog:
            let controller = JobOffersViewController.instantiate()
            controller.viewType = .blog
            self.navigationController?.pushViewController(controller, animated: true)
            
        case .settings:
            break
            
        case .circular_chat:
            self.navigationController?.pushViewController(MainCircularMessageViewController.instantiate(), animated: true)
            
        case .upgrade_premier_circle:
            let urlString = "https://circlecue.com/premiumcircle2.php"
            self.showOutsideAppWebContent(urlString: urlString)
            
        case .business_service:
            break
            
        case .personal_service:
            break
            
        case .pro_circles:
            var urlString = "https://www.circlecue.com/procircle2.php"
            if let userId = AppSettings.shared.userLogin?.userId {
                urlString += "?uid=\(userId)"
            }
            self.showOutsideAppWebContent(urlString: urlString)
            
        case .referral_credit_payout:
            guard let userId = AppSettings.shared.userLogin?.userId else { return }
            let urlString = "https://www.circlecue.com/affiliatee2.php?uid=\(userId)"
            self.showOutsideAppWebContent(urlString: urlString)
            
        case .premier_circle_showcase:
            self.navigationController?.pushViewController(PremierCircleShowcaseController.instantiate(), animated: true)
            
        case .contact_support:
            break
            
        case .special_promos:
            let urlString = "http://circlecue.com/promos.php"
            self.showOutsideAppWebContent(urlString: urlString)
            
        case .expo:
            let urlString = "http://circlecue.com/expo.php"
            self.showOutsideAppWebContent(urlString: urlString)
            
        case .notification:
            self.navigationController?.pushViewController(NotificationsViewController.instantiate(), animated: true)
            
        case .QA:
            self.showWebViewContent(urlString: "https://www.circlecue.com/faqs.html")
        case .ForSale:
            let vc = ShopViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .GoLive:
            
            let vc = LiveStreamListVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .crowdFunding:
            
            let vc = CrowdFundingViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .roomrently:
            let vc = AppMomarViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
           //self.showOutsideAppWebContent(urlString: Constants.URL_RR)
            break
        }
    }
}
