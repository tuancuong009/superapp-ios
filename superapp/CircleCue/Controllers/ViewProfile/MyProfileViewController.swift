//
//  MyProfileViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/6/20.
//
/*
import UIKit
import DTPhotoViewerController
import AVKit
import Alamofire

class MyProfileViewController: BaseViewController {

    @IBOutlet weak var accountTypeLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var flagLabel: UILabel!
    @IBOutlet weak var userBioTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var profileInfoStack: UIStackView!
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var blogButton: UIButton!
    @IBOutlet weak var jobOfferButton: UIButton!
    @IBOutlet weak var datingCircleButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var travelButton: UIButton!
    @IBOutlet weak var dineoutButton: UIButton!
    @IBOutlet weak var circleNumberLabel: UILabel!
    @IBOutlet weak var albumCollectionView: UICollectionView!
    @IBOutlet weak var albumCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var customLinkCollectionView: UICollectionView!
    @IBOutlet weak var customLinkCollectionHeight: NSLayoutConstraint!
    @IBOutlet var profileTypeButtons: [ProfileButton]!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var creditButton: UIButton!
    @IBOutlet weak var circleNumberView: CustomView!
    
    @IBOutlet weak var followingButton: ProfileButton!
    @IBOutlet weak var numberFollowingButton: UIButton!
    @IBOutlet weak var numberFollowerButton: UIButton!
    @IBOutlet weak var stackVip: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var didDismisController: (() -> Void)?

    private var photos: [Gallery] = []
    private var timer: Timer?
    private var currentIndex: Int = 0
    private var selectedImageIndex: Int = 0
    @IBOutlet weak var btnUpgrade: UIButton!
    
    private var isZoom: Bool = false {
        didSet {
            imageWidthConstant.constant = isZoom ? self.view.frame.width : 120.0
            avatarImageView.layer.cornerRadius = imageWidthConstant.constant/2
            self.view.layoutIfNeeded()
        }
    }
    
    private var socialItems: [HomeSocialItem] = []
    private var customLinks: [CustomLink] = [] {
        didSet {
            let rows = customLinks.count/2 + (customLinks.count%2 > 0 ? 1 : 0)
            customLinkCollectionHeight.constant = CGFloat(rows) * CustomLinkCollectionViewCell.cellSize.height
            customLinkCollectionView.reloadData()
        }
    }
    
    private var userInfo: UserInfomation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUser()
    }
    
    override func backAction() {
        navigationController?.popViewController(animated: true)
        self.didDismisController?()
    }
    
    @IBAction func zoomImageAction(_ sender: Any) {
        isZoom.toggle()
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAccount = UIAlertAction(title: "Delete Account", style: .destructive) { action in
            self.navigationController?.pushViewController(AccountStatusViewController.instantiate(), animated: true)
        }
        let favorite = UIAlertAction(title: FavoriteStatus.unFavorite.description, style: .default, handler: nil)
        let block = UIAlertAction(title: "Block User", style: .destructive, handler: nil)
        let report = UIAlertAction(title: "Report", style: .destructive, handler: nil)
        let copy = UIAlertAction(title: "Copy Profile URL", style: .default, handler: nil)
        let shareProfile = UIAlertAction(title: "Share this Profile", style: .default, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(deleteAccount)
        alert.addAction(block)
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
    
    @IBAction func doUpgrade(_ sender: Any) {
        let controller = UpgradePremiumViewController.instantiate(from: StoryboardName.authentication.rawValue)
        controller.delegate = self
        controller.userInfomation = self.userInfo
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func showCircleList(_ sender: Any) {
        let controller = MyCircleViewController.instantiate()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func copyUserNameAction(_ sender: Any) {
        guard let username = AppSettings.shared.userLogin?.username else { return }
        UIPasteboard.general.string = username
        self.view.makeToast("Username is copied.")
    }
    
    @IBAction func didTapViewFollowing(_ sender: Any) {
        let controller = FollowingViewController.instantiate()
        controller.basicInfo = UniversalUser(id: userInfo?.userId, username: userInfo?.username, country: userInfo?.country, pic: userInfo?.pic)
        controller.followingStatus = .following
        navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func UserNameAction(_ sender: Any) {
        let controller = FriendProfileViewUserNameController.instantiate()
        controller.basicInfo =  UniversalUser(id: userInfo?.userId, username: userInfo?.username, country: userInfo?.country, pic: userInfo?.pic)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func didTapViewFollower(_ sender: Any) {
        let controller = FollowingViewController.instantiate()
        controller.basicInfo = UniversalUser(id: userInfo?.userId, username: userInfo?.username, country: userInfo?.country, pic: userInfo?.pic)
        controller.followingStatus = .followers
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func didTapFollowingButton(_ sender: Any) {
    }
}

extension MyProfileViewController {
    
    private func setup() {
        setupUI()
        setupAlbumCollectionView()
        setupCollectionView()
        setupCustomLinkCollectionView()
        updateUI()
    }
    
    private func setupUI() {
        for button in profileTypeButtons {
            button.personalAccount = AppSettings.shared.currentUser?.accountType == AccountType.business ? false : true
        }
        
        followingButton.personalAccount = AppSettings.shared.currentUser?.accountType == AccountType.business ? false : true
        scrollView.alpha = 0
        bottomStackView.alpha = 0
        
        albumCollectionHeight.constant = (UIScreen.main.bounds.width - 60)/3
        albumCollectionView.isHidden = true
        
        avatarImageView.setupUserAvatar()
        userNameLabel.text = AppSettings.shared.currentUser?.username
        locationLabel.text = AppSettings.shared.currentUser?.locationInfomation
        flagLabel.text = AppSettings.shared.currentUser?.country?.flagIcon
        nameLabel.text = (AppSettings.shared.currentUser?.fname ?? "") + " " +  (AppSettings.shared.currentUser?.lname ?? "")
        if nameLabel.text!.trimmed.isEmpty{
            nameLabel.isHidden = true
        }
        else{
            nameLabel.isHidden = false
        }
        datingCircleButton.isHidden = true
        profileInfoStack.isHidden = true
        circleNumberView.isHidden = true
        circleNumberView.layer.cornerRadius = 15.0
        circleNumberView.layer.borderWidth = 1.5
        circleNumberView.layer.borderColor = UIColor.white.cgColor
        
        accountTypeLabel.text = AppSettings.shared.currentUser?.accountType.text
        
        let creditTitle = "CLICK HERE to Join CircleCue for Credit to \(AppSettings.shared.userLogin?.username ?? "")"
        creditButton.titleLabel?.text = creditTitle
        creditButton.setTitle(creditTitle, for: .normal)
        
        userBioTextView.font = UIFont.myriadProRegular(ofSize: 17)
        userBioTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                              NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                              NSAttributedString.Key.underlineColor: UIColor.white]
        userBioTextView.textContainerInset = UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 15)
    }
    
    private func updatePrivateSection(user: UserInfomation) {
        self.userInfo = user
        UIView.animate(withDuration: 0.2) {
            self.scrollView.alpha = 1
            self.bottomStackView.alpha = 1
        }
        flagLabel.text = user.country?.flagIcon
        userBioTextView.text = user.bio
        userBioTextView.isHidden = user.bio.trimmed.isEmpty
        profileInfoStack.isHidden = false
        reviewButton.isHidden = user.hideReview
        circleNumberView.isHidden = user.hideCircleInnerNumber
        circleNumberLabel.text = "\(user.totalcircle)"
        resumeButton.isHidden = user.hideResume
        blogButton.isHidden = user.hideBlog
        jobOfferButton.isHidden = user.hideJob
        datingCircleButton.isHidden = (user.accountType == .business || user.dating_status == false)
        numberFollowingButton.setButtonTitle(title: user.followingDisplay)
        numberFollowerButton.setButtonTitle(title: user.followerDisplay)
        stackVip.isHidden = !user.premium
        if !AppSettings.shared.showPurchaseView{
            btnUpgrade.isHidden = true
        }
        else{
            btnUpgrade.isHidden = user.premium
        }
       
        if user.status == .inner || user.album_status == false {
            if user.album_count == 0 {
                albumButton.isHidden = true
            } else {
                albumButton.isHidden = false
                self.fetchPhoto()
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
        let items = DummyData.share.getSocialItem(with: AppSettings.shared.currentUser)
        socialItems = items.filter({$0.shouldHide == false})
        if socialItems.isEmpty {
            collectionViewHeight.constant = 0
        } else {
            let rows = socialItems.count/3 + (socialItems.count%3 > 0 ? 1 : 0)
            collectionViewHeight.constant = CGFloat(rows) * ProfileSocialCollectionViewCell.size.height
        }
    }
    
    private func fetchUserData() {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        fetchUserInfo(userId: userId)
        fetchCustomLink(userId: userId)
    }
    
    private func fetchUserInfo(userId: String) {
        showSimpleHUD(text: nil, fromView: self.navigationController?.view)
        ManageAPI.shared.fetchUserInfo(userId) {[weak self] (user, error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let user = user {
                    self.updatePrivateSection(user: user)
                    AppSettings.shared.currentUser = user
                    self.updateUI()
                }
            }
        }
    }
    
    private func fetchCustomLink(userId: String) {
        ManageAPI.shared.fetchUserCustomLink(userId) {[weak self] (results) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.customLinks = results.filter({ !$0.isPrivate })
            }
        }
    }
    
    private func refreshUser() {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        ManageAPI.shared.fetchUserInfo(userId) {[weak self] (user, error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let user = user {
                    self.numberFollowingButton.setButtonTitle(title: user.followingDisplay)
                    self.numberFollowerButton.setButtonTitle(title: user.followerDisplay)
                }
            }
        }
    }
    
    private func fetchPhoto() {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
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

extension MyProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileSocialCollectionViewCell", for: indexPath) as! ProfileSocialCollectionViewCell
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
extension MyProfileViewController: DTPhotoViewerControllerDataSource {
    
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
extension MyProfileViewController: DTPhotoViewerControllerDelegate {
    
    func photoViewerControllerDidEndPresentingAnimation(_ photoViewerController: DTPhotoViewerController) {
        photoViewerController.scrollToPhoto(at: selectedImageIndex, animated: false)
    }
    
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, didScrollToPhotoAt index: Int) {
        selectedImageIndex = index
        currentIndex = index
        let indexPath = IndexPath(item: selectedImageIndex, section: 0)
        if !albumCollectionView.indexPathsForVisibleItems.contains(indexPath) {
            albumCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
}

extension MyProfileViewController: CustomPhotoViewerControllerDelegate {
    func didDismisViewerController() {
        setupTimer()
    }
    
    func updateLikes(likes: [PhotoLike], for photo: Gallery) {
        if let index = self.photos.firstIndex(where: {$0.id == photo.id}) {
            self.photos[index].likes = likes
        }
    }
}

extension MyProfileViewController: CardInfomationDelegate {
    func didCreateSubscribe(status: Bool, uid: String) {
        fetchUserData()
    }
}
*/

import UIKit
import Alamofire
import AVKit
import SwiftUI
import SDWebImage
import DTPhotoViewerController
class MyProfileViewController: BaseViewController {
    @IBOutlet weak var tblHome: UITableView!
    var tabSelect = 0
    private var photos: [Gallery] = []
    private var videos: [Gallery] = []
    private var socialItems: [HomeSocialItem] = []
    private var selectedImageIndex: Int = 0
    private var isCall: Bool = true
    var pickerController: ImagePicker?
    private var radomUsers: [RadomUser] = []
    private let picker = UIImagePickerController()
    private let cropper = UIImageCropper(cropRatio: 2/3)
    var imageAvatar: UIImage?
    var headerProfileDashboardTableViewCell: HeaderProfileDashboardTableViewCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }

    @IBAction func doMenu(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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

extension MyProfileViewController{
    private func updateUI(){
        tblHome.registerNibCell(identifier: "HeaderProfileDashboardTableViewCell")
        tblHome.registerNibCell(identifier: "DashboardProfileTableViewCell")
        tblHome.registerNibCell(identifier: "HeaderProfileActionTableViewCell")
        tblHome.sectionHeaderTopPadding = 0
        pickerController = ImagePicker(presentationController: self, delegate: self, mediaTypes: [.image], allowsEditing: false, iCloud: true)
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        getRadomUser(userId: userId)
        

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
    
    private func getRadomUser(userId: String){
        ManageAPI.shared.fetchRadomUser(for: userId) {[weak self]   list, error in
            guard let self = self else { return }
            self.radomUsers.removeAll()
            self.radomUsers = list
            DispatchQueue.main.async {
                self.tblHome.reloadData()
            }
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
    
    func presentCropViewController(image: UIImage) {
        let cropper = UIImageCropper(cropRatio: 1/0.35)
        cropper.delegate = self
        cropper.picker = nil
        cropper.image = image
        cropper.modalPresentationStyle = .fullScreen
        cropper.cancelButtonText = "Cancel"
        self.present(cropper, animated: true, completion: nil)
    }

  
}
extension MyProfileViewController: UIImageCropperProtocol {
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        //imageView.image = croppedImage
        self.imageAvatar = croppedImage
        if let header = self.headerProfileDashboardTableViewCell{
            header.bannerImage.image = croppedImage
            guard let userId = AppSettings.shared.userLogin?.userId else { return }
            let param = ["id": userId]
            ManageAPI.shared.banner_image(params: param, img1: croppedImage) { success, error in
                
            }
        }
    }

    //optional
    func didCancel() {
        picker.dismiss(animated: true, completion: nil)
        print("did cancel")
    }
}
extension MyProfileViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tabSelect == 3{
            return 0
        }
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
                cell.updateUI(user, radomUsers)
                if let imageAvatar = self.imageAvatar{
                    cell.bannerImage.image = imageAvatar
                }
                else{
                    if user.banner_image != nil{
                        cell.bannerImage.setImage(with: user.banner_image ?? "", placeholderImage: .none)
                    }
                   
                }
            }
            
            cell.delegate = self
            self.headerProfileDashboardTableViewCell = cell
            
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
extension MyProfileViewController: DashboardProfileTableViewCellDelegate{
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



extension MyProfileViewController: HeaderProfileDashboardTableViewCellDelegate{
    func didTapAddCircle(indexP: Int) {
        let object = self.radomUsers[indexP]
        self.showAlert(title: object.isbusiness ? "Are you sure you want to add this business in your Circle?" : "Are you sure you want to add this person in your Circle?", message: "", buttonTitles: ["Cancel", "Yes"], highlightedButtonIndex: 1) { (index) in
            if index == 1 {
               
                if !object.isRequest{
                    let otherId = object.id
                    guard let userId = AppSettings.shared.userLogin?.userId else { return }
                    self.showSimpleHUD(text: nil, fromView: self.navigationController?.view)
                    ManageAPI.shared.sendCircleRequest(userId, otherId) { [weak self] (error) in
                        guard let self = self else { return }
                        self.hideLoading()
                        if let err = error {
                           
                            self.showErrorAlert(message: err)
                            return
                        }
                        object.isRequest = true
                        DispatchQueue.main.async {
                            self.tblHome.reloadData()
                        }
                    }
                }
               
            }
        }
    }
    func didTapProfileUser(indexP: Int) {
        let object = self.radomUsers[indexP]
        let controller = FriendProfileViewController.instantiate()
        controller.isPresentProfile = true
        controller.basicInfo = UniversalUser(id: object.id, username: object.username, country: "", pic: "")
        let nav = UINavigationController(rootViewController: controller)
        nav.isNavigationBarHidden = true
       // nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    func didTapRemoveRadomUser(indexP: Int) {
        self.radomUsers.remove(at: indexP)
        if self.radomUsers.count == 0{
            self.tblHome.reloadData()
        }
//        else{
//            self.tblHome.reloadSections(IndexSet.init(integer: 0), with: .none)
//        }
//        
    }
    
    func didTapEditBanner() {
        pickerController?.present(title: "Choose a Photo", message: nil, from: self.view)
    }
    
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
extension MyProfileViewController: ImageViewerControllerDelegate {
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
extension MyProfileViewController: HeaderProfileActionTableViewCellDelegate{
    func didSelectTab(_ index: Int) {
        tabSelect = index
        //tblHome.reloadSections(IndexSet(integer: 1), with: .fade)
        tblHome.reloadData()
    }
    
    
}

extension MyProfileViewController: PhotoAlbumDelegate{
    func didAddNewPhoto() {
        fetchPhoto()
    }
    
    func deletePhoto(photo: Gallery) {
        
    }
    
    func changeShowOnFeed(photo: Gallery) {
        
    }
    
    
}

extension MyProfileViewController: CustomPhotoViewerControllerDelegate {
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
extension MyProfileViewController: DTPhotoViewerControllerDataSource {
    
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
extension MyProfileViewController: DTPhotoViewerControllerDelegate {
    
    func photoViewerControllerDidEndPresentingAnimation(_ photoViewerController: DTPhotoViewerController) {
        photoViewerController.scrollToPhoto(at: selectedImageIndex, animated: false)
    }
    
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, didScrollToPhotoAt index: Int) {
        selectedImageIndex = index
       
    }
}



extension MyProfileViewController: CardInfomationDelegate {
    func didCreateSubscribe(status: Bool, uid: String) {
        
    }
}
extension MyProfileViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        print(image as Any)
        if let image = image {
            self.presentCropViewController(image: image)
        }
       // self.showUploadPicture(image)
    }
    
    func didSelect(videoURL: URL?) {
        print(videoURL as Any)
    }
    
}
