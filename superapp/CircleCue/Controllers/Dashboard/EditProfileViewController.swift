//
//  EditProfileViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/7/20.
//

import UIKit
import MobileCoreServices
import Alamofire
import FBSDKLoginKit

protocol EditProfileViewControllerDelegate: AnyObject {
    func didUpdate()
}

class EditProfileViewController: BaseViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var socialItems: [EditSocialObject] = []
    var headerViews: [GroupHeaderView]  = []
    
    var isUploadAvatar: Bool?
    var picturePath: String?
    var resumePath: String?
    var pickerController: ImagePicker?
    weak var delegate: EditProfileViewControllerDelegate?
    var isHideBlogStatus: Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchCustomLink()
        isHideBlogStatus = AppSettings.shared.currentUser?.blog_status ??  false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(tableViewHeight.constant)
        print(tableView.contentSize.height)
        tableViewHeight.constant = tableView.contentSize.height
    }
    
    @IBAction func viewPublicProfileAction(_ sender: Any) {
        let controller = MyProfileViewController.instantiate()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func didTapChangePassword(_ sender: Any) {
        self.navigationController?.pushViewController(ChangePasswordViewController.instantiate(), animated: true)
    }
    
    @IBAction func changeAvatarAction(_ sender: Any) {
        isUploadAvatar = true
        pickerController = ImagePicker(presentationController: self, delegate: self, mediaTypes: [.image], allowsEditing: true, iCloud: true)
        pickerController?.present(title: "Select a picture", message: nil, from: self.profileImageView)
    }
    
    @IBAction func updateAction(_ sender: Any) {
        guard let para = createPara() else { return }
        showSimpleHUD(text: "Updating...")
        self.updateAvatar()
        print("Para--->",para)
        ManageAPI.shared.updateUserInfo(para) {[weak self] (error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let error = error {
                    self.hideLoading()
                    self.showErrorAlert(title: "Oops!", message: error)
                    return
                }
                self.delegate?.didUpdate()
                self.showSuccessHUD(text: "Your profile has been updated.")
            }
        }
    }
}

extension EditProfileViewController {
    
    private func createPara() -> Parameters? {
        guard let id = AppSettings.shared.userLogin?.userId else { return nil }
        var parameters: Parameters = ["userid": id]
        let missingItems: [String] = ["job_status", "blog_status", "google_plus_status", "reddit_status", "eharmony_status", "my_space_status", "jdate_status", "personal_web_site_status", "business_web_site_status"]
        for item in missingItems {
            if item == "blog_status"{
                if let isHideBlogStatus = isHideBlogStatus{
                    parameters.updateValue(isHideBlogStatus, forKey: item)
                }
            }
            else{
                parameters.updateValue(0, forKey: item)
            }
        }
        
        for items in socialItems {
            switch items.type {
            case .personalInfo, .businessInfo:
                for item in items.profileItems {
                   
                    print("item.type.key--->",item.type.key)
                    print("item.type.value--->",item.value)
                    if item.type == .pushNotification {
                        continue
                    }
                    if !item.type.key.isEmpty {
                        parameters.updateValue(item.value, forKey: item.type.key)
                        if item.type == .uploadResume {
                            if let path = resumePath {
                                parameters.updateValue(path, forKey: "resume")
                            } else {
                                var resume = AppSettings.shared.currentUser?.resume?.replacingOccurrences(of: Constants.UPLOAD_URL_RETURN, with: "")
                                resume = resume?.replacingOccurrences(of: Constants.UPLOAD_URL, with: "")
                                parameters.updateValue(resume ?? "", forKey: "resume")
                            }
                            parameters.updateValue(AppSettings.shared.currentUser?.resume_text ?? "", forKey: "resume_text")
                        }
                    }
                   
                }
            case .customlink:
                let customValue = items.customLinkItems.map({$0.key}).dropLast().filter({$0.isEmpty == false})
                if !customValue.isEmpty {
                    let customLink = customValue.joined(separator: "#")
                    parameters.updateValue(customLink, forKey: "slinkarray")
                }
            case .sociallinks:
                for item in items.socialItems {
                    if let key = item.type.key, let key_status = item.type.key_status {
                        var username = item.link ?? ""
                        if let domain = item.type.domain {
                            username = username.replacingOccurrences(of: domain, with: "")
                        }
                        parameters.updateValue(username, forKey: key)
                        parameters.updateValue(item.isPrivateValue, forKey: key_status)
                    }
                }
            }
        }
        
        return parameters
    }
}

extension EditProfileViewController {
    
    private func setup() {
        setupUI()
        setupTabelView()
    }
    
    private func setupUI() {
        socialItems = DummyData.share.editSocialItems
        profileImageView.setupUserAvatar()
        nameLabel.text = AppSettings.shared.currentUser?.username
        locationLabel.text = AppSettings.shared.currentUser?.country
    }
    
    private func setupTabelView() {
        tableView.registerNibCell(identifier: EditTableViewCell.identifier)
        tableView.registerNibCell(identifier: SelectAllTableViewCell.identifier)
        tableView.registerNibCell(identifier: ProfileInfoTableViewCell.identifier)
        tableView.registerNibCell(identifier: "ProfileInfoUrlTableViewCell")
        tableView.registerNibCell(identifier: AddNewCustomLinkTableViewCell.identifier)
        tableView.registerNibCell(identifier: AddCustomLinkTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        updateTableHeight()
        setupTableHeader()
    }
    
    private func updateTableHeight() {
        var numberOfItem = 0
        for item in socialItems {
            if item.isExpanding {
                switch item.type {
                case .personalInfo, .businessInfo:
                    numberOfItem += item.profileItems.count
                case .customlink:
                    numberOfItem += item.customLinkItems.count
                default:
                    numberOfItem += item.socialItems.count
                }
            }
        }
        tableViewHeight.constant = numberOfItem.cgFloat * EditTableViewCell.cellHeight + CGFloat(socialItems.count) * GroupHeaderView.height
    }
    
    private func setupTableHeader() {
        for _ in socialItems {
            let header = GroupHeaderView()
            header.delegate = self
            headerViews.append(header)
        }
    }
    
    private func nextCustomIndex(_ items: [CustomLink]) -> Int {
        if items.count <= 1 {
            return 0
        }
        var index = 0
        let customArray = items.dropLast()
        for custom in customArray {
            if custom.id > index {
                index = custom.id
            }
        }
        return index + 1
    }
    
    private func fetchCustomLink() {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        showSimpleHUD()
        ManageAPI.shared.fetchUserCustomLink(userId) {[weak self] (results) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                self.updateCustomLink(results)
            }
        }
    }
    
    private func updateCustomLink(_ result: [CustomLink]) {
        guard !result.isEmpty else { return }
        if let index = socialItems.firstIndex(where: {$0.type == .customlink}) {
            let customLink = result + socialItems[index].customLinkItems
            socialItems[index].customLinkItems = customLink
            self.tableView.reloadData()
        }
    }
}

extension EditProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return socialItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if socialItems[section].isExpanding {
            switch socialItems[section].type {
            case .personalInfo, .businessInfo:
                return socialItems[section].profileItems.count
            case .customlink:
                return socialItems[section].customLinkItems.count
            default:
                return socialItems[section].socialItems.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let editItem = socialItems[indexPath.section]
        switch editItem.type {
        case .personalInfo, .businessInfo:
            if socialItems[indexPath.section].profileItems[indexPath.row].type == .blog{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoUrlTableViewCell", for: indexPath) as! ProfileInfoTableViewCell
                cell.isBlogStatus = isHideBlogStatus ?? false
                cell.setup(item: socialItems[indexPath.section].profileItems[indexPath.row])
                cell.delegate = self
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoTableViewCell.identifier, for: indexPath) as! ProfileInfoTableViewCell
                cell.setup(item: socialItems[indexPath.section].profileItems[indexPath.row])
                cell.delegate = self
                return cell
            }
           
        case .customlink:
            let item = editItem.customLinkItems[indexPath.row]
            switch item.type {
            case .addMore:
                let cell = tableView.dequeueReusableCell(withIdentifier: AddNewCustomLinkTableViewCell.identifier, for: indexPath) as! AddNewCustomLinkTableViewCell
                cell.delegate = self
                return cell
            case .custom:
                let cell = tableView.dequeueReusableCell(withIdentifier: AddCustomLinkTableViewCell.identifier, for: indexPath) as! AddCustomLinkTableViewCell
                cell.setup(item: item)
                cell.delegate = self
                return cell
            }
        default:
            let item = editItem.socialItems[indexPath.row]
            switch item.type {
            case .selectAll:
                let cell = tableView.dequeueReusableCell(withIdentifier: SelectAllTableViewCell.identifier, for: indexPath) as! SelectAllTableViewCell
                cell.setup(item: editItem)
                cell.delegate = self
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: EditTableViewCell.identifier, for: indexPath) as! EditTableViewCell
                cell.setup(item: editItem.socialItems[indexPath.row])
                cell.delegate = self
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let editItem = socialItems[indexPath.section]
        switch editItem.type {
        case .personalInfo, .businessInfo:
            switch editItem.profileItems[indexPath.row].type {
            case .bio:
                return 100
                
            default:
                return EditTableViewCell.cellHeight
            }
            
        default:
            return EditTableViewCell.cellHeight
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = headerViews[section]
        header.setup(item: socialItems[section])
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return GroupHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard socialItems[indexPath.section].type == .customlink else { return }
        switch editingStyle {
        case .delete:
            socialItems[indexPath.section].customLinkItems.remove(at: indexPath.row)
            self.updateTableHeight()
            self.tableView.reloadData()
        default:
            break
        }
    }
}

extension EditProfileViewController: GroupHeaderViewDelegate {
    func expanding(_ item: EditSocialObject) {
        for i in 0..<socialItems.count {
            if socialItems[i].type == item.type {
                socialItems[i].isExpanding.toggle()
            } else {
                socialItems[i].isExpanding = false
            }
        }
        updateTableHeight()
        tableView.reloadData()
    }
}

extension EditProfileViewController: EditProfileDelegate {
    
    func didChangePushNotification(currentStatus: Bool) {
        if currentStatus {
            self.showAlert(title: "Push Notification", message: "By turning off you will miss out the activities related to your profile & interests. Are you sure you want to Turn Off?", buttonTitles: ["No", "Yes"], highlightedButtonIndex: 1) { index in
                if index == 1 {
                    self.updatePushNotificationStatus(status: !currentStatus)
                }
            }
        } else {
            self.updatePushNotificationStatus(status: !currentStatus)
        }
    }
    
    private func updatePushNotificationStatus(status: Bool) {
        guard let userid = AppSettings.shared.currentUser?.userId else { return }
        ManageAPI.shared.updatePushNotificationStatus(userId: userid, status: status ? 1 : 0) { [weak self] error in
            guard let self = self else { return }
            guard error == nil else {
                print(error?.msg as Any)
                return
            }
            self.updateUserPushInfo()
        }
    }
    
    private func updateUserPushInfo() {
        guard let index = socialItems.firstIndex(where: {$0.type == .personalInfo || $0.type == .businessInfo}),
              let itemIndex = socialItems[index].profileItems.firstIndex(where: { $0.type == .pushNotification }) else {
            return
        }
        AppSettings.shared.currentUser?.push.toggle()
        socialItems[index].profileItems[itemIndex].push.toggle()
        self.tableView.reloadData()
    }
    
    func updateSocialLink(_ item: HomeSocialItem) {
        print(item)
        runloop: for section in 0..<socialItems.count {
            let items = socialItems[section].socialItems
            for index in 0..<items.count {
                if items[index].type == item.type {
                    print(section, index)
                    socialItems[section].socialItems[index] = item
                    break runloop
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    func updatePersonalInfo(_ info: ProfileInfomation) {
        print(info)
        if let index = socialItems.firstIndex(where: {$0.type == .personalInfo || $0.type == .businessInfo}) {
            if let itemIndex = socialItems[index].profileItems.firstIndex(where: {$0.type == info.type}) {
                socialItems[index].profileItems[itemIndex] = info
                self.tableView.reloadData()
            }
        }
    }
    
    func addMoreCustomLink() {
        if let index = socialItems.firstIndex(where: {$0.type == .customlink}) {
            let items = socialItems[index].customLinkItems
            let itemIndex = nextCustomIndex(items)
            socialItems[index].customLinkItems.insert(CustomLink(index: itemIndex), at: items.count - 1)
            updateTableHeight()
            self.tableView.reloadData()
        }
    }
    
    func updateBlogStatus(_ info: Bool) {
        print(info)
        isHideBlogStatus = info
        print("isHideBlogStatus---->",isHideBlogStatus)
    }
    
    func updateCustomLink(_ customLink: CustomLink) {
        if let index = socialItems.firstIndex(where: {$0.type == .customlink}) {
            let items = socialItems[index].customLinkItems
            runloop: for itemIndex in 0...items.count {
                let item = items[itemIndex]
                if item.id == customLink.id {
                    socialItems[index].customLinkItems[itemIndex] = customLink
                    break runloop
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func selectingAll(item: EditSocialObject) {
        for itemIndex in 0...socialItems.count-1 {
            switch socialItems[itemIndex].type {
            case .sociallinks:
                for index in 0...socialItems[itemIndex].socialItems.count-1 {
                    socialItems[itemIndex].socialItems[index].isPrivate = !item.isSelectingAll
                }
            default:
                break
            }
        }
        self.tableView.reloadData()
    }
    
    func uploadAction(_ item: ProfileInfomation) {
    }
    
    func socialLogin(_ item: HomeSocialItem) {
        switch item.type {
        case .facebook:
            LoginManager().logOut()
            signInWithFacebook(item: item)
        case .instagram:
            signInWithInstagram()
        case .linkedin:
            signInWithLinkedIn()
        case .twitter:
            signInWithTwitter {[weak self] (username) in
                guard let self = self else { return}
                guard let username = username else { return }
                DispatchQueue.main.async {
                    runloop: for section in 0..<self.socialItems.count {
                        let items = self.socialItems[section].socialItems
                        for index in 0..<items.count {
                            if items[index].type == .twitter {
                                print(section, index)
                                self.socialItems[section].socialItems[index].link = username
                                break runloop
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        default:
            break
        }
    }
}

extension EditProfileViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        print(image as Any)
        uploadImage(image: image)
    }
    
    private func uploadImage(image: UIImage?) {
        guard let userId = AppSettings.shared.userLogin?.userId, let data = image?.jpegData(compressionQuality: 0.5) else { return }
        let fileName = "\(userId)\(randomString()).jpg"
        showSimpleHUD(text: "Uploading...")
        ManageAPI.shared.uploadFile(file: data, fileName) {[weak self] (path, error) in
            guard let self = self else { return }
            if let path = path {
                if self.isUploadAvatar == true {
                    self.profileImageView.image = image
                    self.picturePath = path
                } else {
                    self.resumePath = path
                }
                self.showSuccessHUD(text: "Your file has been uploaded.")
                return
            }
            self.showErrorHUD(text: error)
        }
    }
    
    private func updateAvatar() {
        
        guard let userId = AppSettings.shared.userLogin?.userId, let pic = self.picturePath else { return }
        ManageAPI.shared.updateUserAvatar(userId, pic: pic) { (error) in
            print("Update avatar with error =", error?.msg as Any)
        }
    }
}

extension EditProfileViewController {
    
    func signInWithFacebook(item: HomeSocialItem) {
        let loginManager = LoginManager()
        let permissions = ["public_profile", "email", "user_link"]
        loginManager.logIn(permissions: permissions, from: self) { (result: LoginManagerLoginResult?, error: Error?) in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(title: "Oops!", message: error.localizedDescription)
                    return
                }
            }
            
            guard let token = result?.token else {
                return
            }
            print(token.tokenString)
            self.getFacebookData(token: token.tokenString, item: item)
        }
    }
    
    private func getFacebookData(token: String?, item: HomeSocialItem) {
        self.showSimpleHUD()
        let parameters = ["fields": "id, email, name, link"]
        GraphRequest(graphPath: "me", parameters: parameters, tokenString: token, version: nil, httpMethod: .get).start { (connection, result, error) in
            if let error = error {
                self.hideLoading()
                self.showAlert(title: "Oops!", message: error.localizedDescription)
                return
            }
            self.hideLoading()
            if let info = result as? [String : AnyObject], let link = info["link"] as? String {
                print(result as Any)
                DispatchQueue.main.async {
                    runloop: for section in 0..<self.socialItems.count {
                        let items = self.socialItems[section].socialItems
                        for index in 0..<items.count {
                            if items[index].type == item.type {
                                print(section, index)
                                self.socialItems[section].socialItems[index].link = link
                                break runloop
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
}
