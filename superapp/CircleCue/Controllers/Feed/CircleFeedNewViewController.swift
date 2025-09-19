//
//  CircleFeedNewViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 08/12/2023.
//

import UIKit
import Alamofire
import AVKit
import SwiftUI
import SDWebImage
import DTPhotoViewerController
/*
class CircleFeedNewViewController: BaseViewController {
    @IBOutlet weak var tblHome: UITableView!
    var tabSelect = 0
    private var photos: [Gallery] = []
    private var videos: [Gallery] = []
    private var socialItems: [HomeSocialItem] = []
    private var selectedImageIndex: Int = 0
    private var isCall: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }

    @IBAction func doMenu(_ sender: Any) {
        self.navigationController?.pushViewController(NewHomeViewController.instantiate(), animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserData(loading: isCall ? true : false)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension CircleFeedNewViewController{
    private func updateUI(){
        tblHome.registerNibCell(identifier: "HeaderProfileDashboardTableViewCell")
        tblHome.registerNibCell(identifier: "DashboardProfileTableViewCell")
        tblHome.registerNibCell(identifier: "HeaderProfileActionTableViewCell")
        tblHome.sectionHeaderTopPadding = 0
    }
    private func fetchUserData(loading: Bool) {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        fetchUserInfo(userId: userId, loading: loading)
    }
    
    private func fetchUserInfo(userId: String, loading: Bool) {
        if loading{
            tblHome.isHidden = true
            showSimpleHUD(text: nil, fromView: self.navigationController?.view)
        }
      
        ManageAPI.shared.fetchUserInfo(userId) {[weak self] (user, error) in
            guard let self = self else { return }
            self.hideLoading()
            self.isCall = false
            self.tblHome.isHidden = false
            DispatchQueue.main.async {
                if let user = user {
                    AppSettings.shared.currentUser = user
                    self.updateSocial()
                    self.tblHome.reloadData()
                }
            }
            self.fetchPhoto()
        }
    }
    
    private func fetchPhoto() {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        ManageAPI.shared.fetchGallery(userId: userId) {[weak self] (results, error) in
            guard let self = self else { return }
            let allPhotos = results.sorted(by: {$0.timeInterval > $1.timeInterval})
            self.photos.removeAll()
            self.videos.removeAll()
            for allPhoto in allPhotos {
                if allPhoto.albumType == .video{
                    self.videos.append(allPhoto)
                }
                else{
                    self.photos.append(allPhoto)
                }
            }
            self.tblHome.reloadData()
        }
    }
    
    private func updateSocial() {
        let items = DummyData.share.getSocialItem(with: AppSettings.shared.currentUser)
        socialItems = items.filter({$0.shouldHide == false})
    }
}

extension CircleFeedNewViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        }
        return tblHome.frame.size.height - 50
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        }
        return tblHome.frame.size.height - 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1.0
        }
        
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        }
        let cell = tblHome.dequeueReusableCell(withIdentifier: "HeaderProfileActionTableViewCell") as! HeaderProfileActionTableViewCell
        cell.updateTab(tabSelect)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sub = UIView()
        return sub
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tblHome.dequeueReusableCell(withIdentifier: "HeaderProfileDashboardTableViewCell") as! HeaderProfileDashboardTableViewCell
            if let user = AppSettings.shared.currentUser{
                cell.updateUI(user)
            }
            cell.delegate = self
            return cell
        }
        let cell = tblHome.dequeueReusableCell(withIdentifier: "DashboardProfileTableViewCell") as! DashboardProfileTableViewCell
        cell.delegate = self
        cell.indexTab = self.tabSelect
        if tabSelect == 0{
            cell.gallerys = photos
        }
        else  if tabSelect == 1{
            cell.gallerys = videos
        }
        else{
            cell.socialItems = socialItems
        }
        cell.cltGallery.reloadData()
        return cell
    }
}
extension CircleFeedNewViewController: DashboardProfileTableViewCellDelegate{
    func didSelectGallery(indexPath: IndexPath, imageV: UIImageView?) {
        selectedImageIndex = indexPath.item
        let viewController = CustomPhotoViewerController(referencedView: imageV, image: imageV?.image)
        viewController.data =  tabSelect == 0 ? photos : videos
        viewController.dataSource = self
        viewController.delegate = self
        viewController.isHiddenShare = true
        viewController.customDelegate = self
        present(viewController, animated: true, completion: nil)
    }
    func didSelectSocial(indexPath: IndexPath) {
        guard indexPath.item < socialItems.count else { return }
        let item = socialItems[indexPath.item]
        self.viewUserSocialProfile(with: item)
    }
    
    
}
extension CircleFeedNewViewController: HeaderProfileDashboardTableViewCellDelegate{
    func didTapFollower() {
        guard let user = AppSettings.shared.currentUser else{
            return
        }
        let controller = FollowingViewController.instantiate()
        controller.basicInfo = UniversalUser(id: user.userId, username: user.username, country: user.country, pic: user.pic)
        controller.followingStatus = .followers
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTapFollowing() {
        guard let user = AppSettings.shared.currentUser else{
            return
        }
        let controller = FollowingViewController.instantiate()
        controller.basicInfo = UniversalUser(id: user.userId, username: user.username, country: user.country, pic: user.pic)
        controller.followingStatus = .following
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTapPost() {
        let controller = AddPhotoAlbumViewController.instantiate()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTapAvatar(indexP: Int) {
        guard let user = AppSettings.shared.currentUser else{
            return
        }
        var url: String?
        if indexP == 0 {
            url = user.pic
        }
        else if indexP == 1 {
            url = user.pic2
        }
        else if indexP == 2 {
            url = user.pic3
        }
        if let url = url{
            let imageURLs: [URL] = [URL.init(string: url)!]
            let vc = ImageViewerController.init(imageURLs: imageURLs)
            vc.delegate = self
            present(vc, animated: true)
        }
       
    }
    
}
extension CircleFeedNewViewController: ImageViewerControllerDelegate {
    func load(_ imageURL: URL, into imageView: UIImageView, completion: (() -> Void)?) {
        imageView.sd_setImage(with: imageURL) { _,_,_,_  in
                completion?()
            }
       // imageView.setImage(with: imageURL.absoluteString)
//        imageView.setImage(with: imageURL.absoluteString) { _ in
//            completion?()
//        }
    }
}
extension CircleFeedNewViewController: HeaderProfileActionTableViewCellDelegate{
    func didSelectTab(_ index: Int) {
        tabSelect = index
        tblHome.reloadData()
    }
    
    
}

extension CircleFeedNewViewController: PhotoAlbumDelegate{
    func didAddNewPhoto() {
        fetchPhoto()
    }
    
    func deletePhoto(photo: Gallery) {
        
    }
    
    func changeShowOnFeed(photo: Gallery) {
        
    }
    
    
}

extension CircleFeedNewViewController: CustomPhotoViewerControllerDelegate {
    func didDismisViewerController() {
    }
    
    func updateLikes(likes: [PhotoLike], for photo: Gallery) {
        var items = (tabSelect == 0 ? photos : videos)
        if let index = items.firstIndex(where: {$0.id == photo.id}) {
            items[index].likes = likes
        }
    }
}

// MARK: - DTPhotoViewerControllerDataSource
extension CircleFeedNewViewController: DTPhotoViewerControllerDataSource {
    
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, configureCell cell: DTPhotoCollectionViewCell, forPhotoAt index: Int) {
        if let cell = cell as? CustomPhotoCollectionViewCell {
            let item = tabSelect == 0 ? photos[index] : videos[index]
            cell.cellDelegate = photoViewerController as? CustomPhotoViewerController
            cell.setup(item)
        }
    }
    
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, referencedViewForPhotoAt index: Int) -> UIView? {
       
        
        return nil
    }
    
    func numberOfItems(in photoViewerController: DTPhotoViewerController) -> Int {
        return tabSelect == 0 ? photos.count : videos.count
    }
    
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, configurePhotoAt index: Int, withImageView imageView: UIImageView) {
        let item = tabSelect == 0 ? photos[index] : videos[index]
        if item.albumType == .video {
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
extension CircleFeedNewViewController: DTPhotoViewerControllerDelegate {
    
    func photoViewerControllerDidEndPresentingAnimation(_ photoViewerController: DTPhotoViewerController) {
        photoViewerController.scrollToPhoto(at: selectedImageIndex, animated: false)
    }
    
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, didScrollToPhotoAt index: Int) {
        selectedImageIndex = index
       
    }
}

*/

class CircleFeedNewViewController: BaseViewController {

    @IBOutlet weak var cltFeed: UICollectionView!
    @IBOutlet weak var tblFeed: UITableView!
    @IBOutlet var viewHeader: UIView!
    
    var currentType: FeedType = .vclips
    private var newFeeds: [NewFeed] = []
    private var storiesFeeds: [NewFeed] = []
    private var currentPage: Int = 1
    private var hasMore: Bool = true
    
    private var currentPageStory: Int = 1
    private var hasMoreStory: Bool = true
    
    private var popupBackground: UIView?
    private var storyFeedCollectionViewCell: StoryFeedCollectionViewCell?
    private var loginView: LoginPopupView?
    @IBOutlet weak var unreadMessage: UIView!
    @IBOutlet weak var lblUnreadMessage: UILabel!
    @IBOutlet weak var imgAvatarSmall: UIImageView!
    @IBOutlet weak var imgAvatarBigs: UIImageView!
    @IBOutlet weak var viewBlur: UIVisualEffectView!
    @IBOutlet weak var spaceBottom: NSLayoutConstraint!
    @IBOutlet weak var spaceTopNavo: NSLayoutConstraint!
    var indexPathReadMore: IndexPath?
    var expandedStates: [Bool] = []
    var lastContentOffset: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tblFeed.isHidden = true
        updateUI()
        self.showSimpleHUD()
        unreadMessage.isHidden = true
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        fetchUnreadMessageCount(userId: userId)
        fetchNewFeedStories()
        fetchNewFeed()
        getAvatar()
    }

    private func fetchUnreadMessageCount(userId: String) {
        
        ManageAPI.shared.fetchListRead(userId) { (number) in
            if number == 0{
                self.unreadMessage.isHidden = true
            }
            else{
                self.unreadMessage.isHidden = false
                
                self.lblUnreadMessage.text = "\(number)"
            }
        }
    }

    
    @IBAction func doLive(_ sender: Any) {
        let vc = LiveStreamListVC.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func doCamera(_ sender: Any) {
        self.navigationController?.pushViewController(MessageViewController.instantiate(), animated: true)
       
    }
    
    @IBAction func doMessage(_ sender: Any) {
        self.navigationController?.pushViewController(MainCircularMessageViewController.instantiate(), animated: true)
    }
    
    @IBAction func doHome(_ sender: Any) {
        APP_DELEGATE.initSuperApp()
    }
    
    @IBAction func doSearch(_ sender: Any) {
        guard let searchType = SEARCHViewController.SearchType.init(rawValue: 0) else { return }
        let controller = SEARCHViewController.instantiate()
        controller.searchType = searchType
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func doLogo(_ sender: Any) {
        let controller = MyCircleViewController.instantiate()
        controller.type = .mycirlce
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func doVideos(_ sender: Any) {
        guard let feedType = FeedType(rawValue: 2) else { return }
        let controller = NewFeedsViewController.instantiate()
        controller.currentType = feedType
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func doProfile(_ sender: Any) {
        self.navigationController?.pushViewController(NewHomeViewController.instantiate(), animated: true)
        //self.navigationController?.pushViewController(MyProfileViewController.instantiate(), animated: true)
    }
    @IBAction func doShop(_ sender: Any) {
        let vc = ShopViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doNewAdd(_ sender: Any) {
        let controller = AddPhotoAlbumViewController.instantiate()
        navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func doNotification(_ sender: Any) {
        self.navigationController?.pushViewController(NotificationsViewController.instantiate(), animated: true)
    }
    @IBAction func doMyprofile(_ sender: Any) {
        self.navigationController?.pushViewController(MyProfileViewController.instantiate(), animated: true)
    }
}

extension CircleFeedNewViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if abs(scrollView.contentOffset.y - lastContentOffset) > 50 {
//            if scrollView.contentOffset.y > lastContentOffset {
//                hideHeaderView()
//            } else {
//                showHeaderView()
//            }
//            lastContentOffset = scrollView.contentOffset.y
//        }
    }
    
    func hideHeaderView() {
        UIView.animate(withDuration: 0.3) {
           // self.spaceTopNavo.constant = -150
            self.spaceBottom.constant = -100
            self.view.layoutIfNeeded() // Cập nhật layout
        }
    }

    func showHeaderView() {
        UIView.animate(withDuration: 0.3) {
            //self.spaceTopNavo.constant = 0
            self.spaceBottom.constant = 5
            self.view.layoutIfNeeded()
        }
    }
}

extension CircleFeedNewViewController{
    private func updateUI(){
        tblFeed.registerNibCell(identifier: "CircleFeedTableViewCell")
     
        imgAvatarBigs.layer.cornerRadius = imgAvatarBigs.frame.size.width/2
        imgAvatarBigs.layer.masksToBounds = true
        imgAvatarSmall.layer.cornerRadius = imgAvatarSmall.frame.size.width/2
        imgAvatarSmall.layer.masksToBounds = true
        
        viewBlur.layer.cornerRadius = viewBlur.frame.size.height/2
        viewBlur.layer.masksToBounds = true
    }
    
    private func getAvatar(){
        //imgAvatarBigs.setImage(with: AppSettings.shared.currentUser?.pic ?? "", placeholderImage: .avatar)
        imgAvatarSmall.setImage(with: AppSettings.shared.currentUser?.pic ?? "", placeholderImage: .avatar)
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
    
    
    private func fetchNewFeedStories() {
        currentPageStory = 1
        hasMoreStory = true
        let userId = AppSettings.shared.userLogin?.userId
        ManageAPI.shared.fetchNewFeedStories(userId, page: currentPageStory, type: currentType, searchQuery: "") {[weak self] (results, hasMore, error) in
            guard let self = self else { return }
            self.storiesFeeds = results
            self.hasMoreStory = hasMore
            DispatchQueue.main.async {
                self.cltFeed.reloadData()
            }
        }
    }
    
    private func fetchMoreNewFeedStories() {
        let userId = AppSettings.shared.userLogin?.userId
        let username =  ""
        ManageAPI.shared.fetchNewFeedStories(userId, page: currentPageStory, type: currentType, searchQuery: username) {[weak self] (results, hasMore, error) in
            guard let self = self else { return }
            self.storiesFeeds.append(contentsOf: results)
            self.hasMoreStory = hasMore
            DispatchQueue.main.async {
                self.cltFeed.reloadData()
            }
        }
    }
    
    private func fetchNewFeed() {
        
        currentPage = 1
        hasMore = true
        let userId = AppSettings.shared.userLogin?.userId
        ManageAPI.shared.fetchNewFeed(userId, page: currentPage, type: currentType, searchQuery: "") {[weak self] (results, hasMore, error) in
            guard let self = self else { return }
            self.hideLoading()
            tblFeed.isHidden = false
            self.newFeeds = results
            self.hasMore = hasMore
            self.expandedStates = Array(repeating: false, count: self.newFeeds.count)
            DispatchQueue.main.async {
                self.tblFeed.reloadData()
            }
        }
    }
    
    private func fetchMoreNewFeed() {
        let userId = AppSettings.shared.userLogin?.userId
        let username =  ""
        ManageAPI.shared.fetchNewFeed(userId, page: currentPage, type: currentType, searchQuery: username) {[weak self] (results, hasMore, error) in
            guard let self = self else { return }
            self.newFeeds.append(contentsOf: results)
            self.expandedStates.append(contentsOf: Array(repeating: false, count: results.count))
            self.hasMore = hasMore
            DispatchQueue.main.async {
                self.tblFeed.reloadData()
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
                            self.tblFeed.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                        }
                    }
                } else {
                    self.showErrorAlert(message: error?.msg)
                }
            }
        }
    }
}

extension CircleFeedNewViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.storiesFeeds.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cltFeed.dequeueReusableCell(withReuseIdentifier: "StoryFeedCollectionViewCell", for: indexPath) as! StoryFeedCollectionViewCell
        cell.imgCell.isHidden = true
        if indexPath.row == 0{
            cell.icAvatar.setImage(with: AppSettings.shared.currentUser?.pic ?? "", placeholderImage: .avatar)
            cell.icAdd.isHidden = false
            cell.lblName.text = "Your story"
            cell.icAvatar.layer.cornerRadius = cell.icAvatar.frame.size.width/2
            cell.icAvatar.layer.masksToBounds = true
            cell.icAvatar.layer.borderColor = UIColor.init(hex: "25A8E0").cgColor
            cell.icAvatar.layer.borderWidth = 3.0
        }
        else{
            //cell.icAvatar.image = UIImage.init(named: "new_avatar")
            cell.icAvatar.image = nil
            cell.icAdd.isHidden = true
            cell.lblName.text = ""
            cell.icAvatar.layer.cornerRadius = cell.icAvatar.frame.size.width/2
            cell.icAvatar.layer.masksToBounds = true
            cell.icAvatar.layer.borderColor = UIColor.init(hex: "25A8E0").cgColor
            cell.icAvatar.layer.borderWidth = 3.0
            cell.setup(newFeed: storiesFeeds[indexPath.row - 1])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: cltFeed.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let controller = AddPhotoAlbumViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        }
        else{
            if let collect = self.cltFeed.cellForItem(at: indexPath) as? StoryFeedCollectionViewCell
            {
                storyFeedCollectionViewCell = collect
                let newFeed = storiesFeeds[indexPath.row - 1]
                switch newFeed.newFeedType {
                case .image:
                    self.viewPhoto(newFeed, imageView: collect.imgCell)
                case .video:
                    self.playVideo(newFeed)
                }
            }
           
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard hasMoreStory, indexPath.row == storiesFeeds.count-4 else { return }
        currentPageStory += 1
        fetchMoreNewFeedStories()
    }
}
extension CircleFeedNewViewController:CustomPhotoViewerControllerDelegate{
    func didDismisViewerController() {
        if let storyFeedCollectionViewCell = storyFeedCollectionViewCell{
            storyFeedCollectionViewCell.imgCell.isHidden = true
        }
    }
    
    func updateLikes(likes: [PhotoLike], for photo: Gallery) {
        
    }
    
    
}
extension CircleFeedNewViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newFeeds.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblFeed.dequeueReusableCell(withIdentifier: "CircleFeedTableViewCell") as! CircleFeedTableViewCell
        cell.setup(newFeed: newFeeds[indexPath.row], indexPath: indexPath)
        cell.isExpanded = expandedStates[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 260
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard hasMore, indexPath.row == newFeeds.count-4 else { return }
        currentPage += 1
        fetchMoreNewFeed()
    }
}
extension CircleFeedNewViewController: CircleFeedTableViewCellDelegate {
    func readMoreFeed(_ indexpath: IndexPath, cell: CircleFeedTableViewCell) {
        expandedStates[indexpath.row] = !expandedStates[indexpath.row]
        tblFeed.beginUpdates()
        tblFeed.reloadRows(at:[indexpath], with: .fade)
        tblFeed.endUpdates()
    }
    
   
    
    
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
    
    func viewUserProfileComment(_ newFeed: NewFeed) {
        guard let _ = AppSettings.shared.currentUser else {
            showLoginOption()
            return
        }
        view.endEditing(true)
        let comment = newFeed.arrComments[0]
        if comment.uid == AppSettings.shared.userLogin?.userId {
            let controller = MyProfileViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = FriendProfileViewController.instantiate()
            controller.basicInfo = UniversalUser(id: comment.uid, username: comment.username, country: "", pic: comment.pic)
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
    
    internal func optionActionUser(_ newFeed: NewFeed, cell: CircleFeedTableViewCell) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
       
        let block = UIAlertAction(title: "Block User", style: .destructive) { (action) in
            self.handleAction(.block,newFeed)
        }
        
        let report = UIAlertAction(title: "Report", style: .destructive) { (action) in
            self.handleAction(.report, newFeed)
        }
        
        let favorite = UIAlertAction(title: "Add to Favorite", style:.default) { (action) in
            self.handleAction(.favorite, newFeed)
        }
        
        let copy = UIAlertAction(title: "Copy Profile URL", style: .default) { (action) in
            self.handleAction(.copyURL, newFeed)
        }
        
        let shareProfile = UIAlertAction(title: "Share this Profile", style: .default) { (action) in
            self.handleAction(.share, newFeed)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(block)
        alert.addAction(report)
        alert.addAction(favorite)
        alert.addAction(copy)
        alert.addAction(shareProfile)
        alert.addAction(cancel)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = cell
            alert.popoverPresentationController?.sourceRect = cell.bounds
            alert.popoverPresentationController?.permittedArrowDirections = []
        }
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func blockUser(_ newFeed: NewFeed) {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        let otherUserId = newFeed.uid
        showSimpleHUD(text: nil, fromView: self.navigationController?.view)
        ManageAPI.shared.blockUser(userId, otherUserId) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            if let err = error {
                self.showErrorAlert(message: err)
                return
            }
        }
    }
    
    private func addFavorite(_ newFeed: NewFeed) {
        guard let userId = AppSettings.shared.userLogin?.userId else{
            return
        }
        let otherUserId = newFeed.uid
        ManageAPI.shared.addFavoriteUser(userId, otherUserId) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            if let err = error {
                self.showErrorAlert(message: err)
                return
            }
        }
    }
    
    private func handleAction(_ action: ProfileActionType, _ newFeed: NewFeed) {
        guard AppSettings.shared.currentUser != nil else {
            self.showLoginOption()
            return
        }
        
        switch action {
       
        case .block:
            self.showAlert(title: "Block", message: "Are you sure you want to block this user?", buttonTitles: ["No", "Yes"], highlightedButtonIndex: 1) { (index) in
                if index == 1 {
                    self.blockUser(newFeed)
                }
            }
      
        case .favorite:
            self.addFavorite(newFeed)
        case .report:
            let controller = HelpViewController.instantiate()
            controller.shouldBack = true
            self.navigationController?.pushViewController(controller, animated: true)
        case .copyURL:
            let link = Constants.HOME_PAGE_WEBSITE + newFeed.username
            UIPasteboard.general.string = link
            self.showAlert(title: nil, message: "Profile link is copied")
        case .share:
            let link = Constants.HOME_PAGE_WEBSITE + newFeed.username
            let activityItems: [Any] = [link as Any]
            let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            if UIDevice.current.userInterfaceIdiom == .pad {
                activityVC.popoverPresentationController?.sourceView = self.view
                activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
            }
            DispatchQueue.main.async {
                self.present(activityVC, animated: true, completion: nil)
            }
        case .viewInnerCircle:
            break
        case .album:
            break
        case .resume:
            break
        case .reviews:
            break
        case .blog:
            break
        case .job:
            break
        case .dating:
            break
        case .travel:
            break
        case .dineout:
            break
        }
    }
    
    func messageUserProfile(_ newFeed: NewFeed) {
        guard AppSettings.shared.currentUser != nil else {
            self.showLoginOption()
            return
        }
        
        let controller = MessageStreamViewController.instantiate()
        controller.friendUser =  UniversalUser(id: newFeed.uid, username: newFeed.username, country: newFeed.country, pic: newFeed.pic)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension CircleFeedNewViewController: LoginPopupViewDelegate {
    
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

extension CircleFeedNewViewController: CommentViewControllerDelegate {
    
    func viewProfile(_ comment: PhotoComment) {
    }
    
    func didDismisCommentViewController() {
    }
    
    func didLoadAllComment(_ newFeed: NewFeed, commentNumber: Int) {
        if let index = newFeeds.firstIndex(where: {$0.id == newFeed.id}) {
            self.newFeeds[index].comment_count = commentNumber
            self.tblFeed.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }
    
    func showCommentOption(_ comment: PhotoComment) {
    }
}

extension CircleFeedNewViewController: FullscreenViewDelegate {
    
    func updateNewFeed(_ newFeed: NewFeed?) {
        guard let newFeed = newFeed else { return }
        if let index = self.newFeeds.firstIndex(where: {$0.id == newFeed.id}) {
            self.newFeeds[index] = newFeed
            UIView.performWithoutAnimation {
                self.tblFeed.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
    
    func didLoadMore(_ results: [NewFeed], hasMore: Bool, currentPage: Int) {
        self.hasMore = hasMore
        self.currentPage = currentPage
        self.newFeeds.append(contentsOf: results)
        DispatchQueue.main.async {
            self.tblFeed.reloadData()
        }
    }
}


