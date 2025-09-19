//
//  MangePrivacyViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/20/20.
//

import UIKit
import Alamofire

class MangePrivacyViewController: BaseViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var managePrivacyLabel: UILabel!
    
    var privacyItems: [PrivacyItem] = []
    var basicUser: CircleUser?
    
    var isZoom: Bool = false {
        didSet {
            imageWidthConstant.constant = isZoom ? self.view.frame.width : 120.0
            avatarImageView.layer.cornerRadius = imageWidthConstant.constant/2
            self.view.layoutIfNeeded()
        }
    }
    
    var isSelectAll: Bool = false {
        didSet {
            guard !privacyItems.isEmpty else { return }
            selectAllButton.setHomePrivateStatus(isSelectAll)
            for index in 0...privacyItems.count-1 {
                privacyItems[index].isPrivate = isSelectAll
            }
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        fetchPrivacy()
    }

    @IBAction func updateAction(_ sender: Any) {
        updatePrivacy()
    }
    
    @IBAction func zoomImageAction(_ sender: Any) {
        isZoom.toggle()
    }
    
    @IBAction func selectAllAction(_ sender: UIButton) {
        isSelectAll.toggle()
    }
}

extension MangePrivacyViewController {
    
    private func createParameter() -> Parameters? {
        guard let userId = AppSettings.shared.userLogin?.userId, let partnerId = basicUser?.id else { return nil }
        var para: Parameters = ["userid": userId, "userid2": partnerId]
        guard !privacyItems.isEmpty else { return para }
        
        for privacy in privacyItems {
            if let key = privacy.type.key_status {
                para.updateValue(privacy.isPrivateValue, forKey: key)
            }
        }
        
        var missingItems = ["google_plus_status", "reddit_status", "eharmony_status", "my_space_status", "jdate_status"]
        if AppSettings.shared.currentUser?.accountType == .business {
            missingItems.append("personal_web_site_status")
        } else {
            missingItems.append("business_web_site_status")
        }
        for item in missingItems {
            para.updateValue(1, forKey: item)
        }

        return para
    }
    
    private func fetchPrivacy() {
        guard let userId = AppSettings.shared.userLogin?.userId, let partnerId = basicUser?.id else { return }
        self.showSimpleHUD()
        ManageAPI.shared.fetchPrivacy(userId, partnerId: partnerId) {[weak self] (result) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                self.updateUI(result: result ?? UserInfomation())
                print(result?.album_status as Any)
            }
        }
    }
    
    private func updatePrivacy() {
        showSimpleHUD(text: "Updating...")
        let para = createParameter()
        ManageAPI.shared.updatePrivacy(para: para) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            if let err = error {
                self.showErrorAlert(message: err)
                return
            }
            
            self.showAlert(title: "Success!", message: "Privacy has been updated.", buttonTitles: ["OK"], highlightedButtonIndex: nil) { (_) in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension MangePrivacyViewController {
    
    private func setupUI() {
        managePrivacyLabel.text = "Manage privacy for \(basicUser?.username ?? "")"
        avatarImageView.setImage(with: basicUser?.pic ?? "", placeholderImage: .avatar)
        userNameLabel.text = basicUser?.username
        locationLabel.text = basicUser?.country
    }
    
    private func setupTableView() {
        tableView.registerNibCell(identifier: ManagePrivacyTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 55
        tableView.backgroundColor = .clear
        tableViewHeight.constant = privacyItems.count.cgFloat * 55
    }
    
    private func updateUI(result: UserInfomation) {
        privacyItems = DummyData.share.getPrivacyItem(with: result)
        print(result.facebook_status)
        print(privacyItems.map({$0.isPrivate}))
        tableViewHeight.constant = privacyItems.count.cgFloat * 55
        self.tableView.reloadData()
    }
}

extension MangePrivacyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return privacyItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ManagePrivacyTableViewCell.identifier, for: indexPath) as! ManagePrivacyTableViewCell
        cell.setup(privacyItem: privacyItems[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension MangePrivacyViewController: ManagePrivacyDelegate {
    func updateStatus(_ item: PrivacyItem?) {
        guard let item = item else { return }
        if let index = privacyItems.firstIndex(where: {$0.type == item.type}) {
            privacyItems[index].isPrivate.toggle()
        }
    }
}
