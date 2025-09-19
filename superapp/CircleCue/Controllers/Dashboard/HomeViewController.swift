//
//  HomeViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/5/20.
//

import UIKit

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewProfileCountButton: UIButton!
    @IBOutlet weak var lineViewProfileCount: UILabel!
    @IBOutlet weak var spaceTopViewProfileCount: NSLayoutConstraint!
    
    var isFirstLoad: Bool = true
    var socialItems: [HomeSocialItem] = []
    
    lazy var headerView: HomeHeaderView = {
        let v = HomeHeaderView()
        v.backgroundColor = .clear
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchUserInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewHeight.constant = tableView.contentSize.height
    }
    
    override func editProfile() {
        let controller = EditProfileViewController.instantiate()
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func viewAction(_ sender: Any) {
        if let user = AppSettings.shared.currentUser, user.premium{
            navigationController?.pushViewController(VisitorStatViewController.instantiate(), animated: true)
        }
        else{
            self.showAlert(title: nil, message: "This feature for the VIP member only")
        }
    }
}

extension HomeViewController {
    
    private func setup() {
        setupTabelView()
        updateUI()
        if let user = AppSettings.shared.currentUser, !user.premium{
            viewProfileCountButton.isHidden = true
            lineViewProfileCount.isHidden = true
            spaceTopViewProfileCount.constant = -30
        }
    }
    
    private func updateUI() {
        nameLabel.text = AppSettings.shared.currentUser?.username ?? AppSettings.shared.userLogin?.username ?? " "
        locationLabel.text = AppSettings.shared.currentUser?.country ?? " "
        profileImageView.setupUserAvatar()
        
        let viewCount = "Views: \(AppSettings.shared.currentUser?.profilecount ?? 0)"
        viewProfileCountButton.titleLabel?.text = viewCount
        viewProfileCountButton.setTitle(viewCount, for: .normal)
        
        socialItems = DummyData.share.getSocialItem(with: AppSettings.shared.currentUser)
        reloadTableView()
    }
    
    private func setupTabelView() {
        tableView.register(UINib(nibName: "HomeSocialTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeSocialTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func reloadTableView() {
        self.tableView.reloadData()
        tableViewHeight.constant = socialItems.count.cgFloat * HomeSocialTableViewCell.cellHeight + 30
    }
    
    private func fetchUserInfo(withLoading: Bool = true) {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        if withLoading {
            showSimpleHUD()
        }
        ManageAPI.shared.fetchUserInfo(userId) {[weak self] (user, error) in
            guard let this = self else { return }
            this.hideLoading()
            DispatchQueue.main.async {
                if let user = user {
                    AppSettings.shared.currentUser = user
                    this.updateUI()
                    this.reloadTableView()
                    this.reloadMenu()
                    return
                }
                this.showAlert(title: "Opps!", message: error)
            }
        }
    }
    
    private func reloadMenu() {
        NotificationCenter.default.post(name: NSNotification.Name("KEY_UPDATE_MENU"), object: nil)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return socialItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSocialTableViewCell", for: indexPath) as! HomeSocialTableViewCell
        cell.setup(item: socialItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HomeSocialTableViewCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < socialItems.count else { return }
        let item = socialItems[indexPath.row]
        self.viewUserSocialProfile(with: item)
    }
}

extension HomeViewController: EditProfileViewControllerDelegate {
    func didUpdate() {
        fetchUserInfo(withLoading: false)
    }
}
