//
//  MyCircleViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/6/20.
//

import UIKit

class MyCircleViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isPreviewing: Bool = false
    var type: MenuItem = .mycirlce
    var headers: [CircleHeaderView] = []
    var users: [[CircleUser]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        fetchUser()
    }
    
    @IBAction func didTapBackMenuButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension MyCircleViewController {

    private func setupUI() {
        self.topBarMenuView.title = "Inner Circle"
        topBarMenuView.leftButtonType = 1
    }
    
    private func setupTableView() {
        tableView.registerNibCell(identifier: MyCircleTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupHeader(users: [CircleUser]) {
        let innerUser = users.filter({$0.status == .inner})
        let pendingUser = users.filter({$0.status != .inner})
        self.users = [innerUser, pendingUser]
        
        let innerView = CircleHeaderView()
        innerView.setup("Inner Circle:   \(innerUser.count)")
        
        let pending = CircleHeaderView()
        pending.setup("Pending:   \(pendingUser.count)")
        
        headers = [innerView, pending]
    }
    
    private func fetchUser(loading: Bool = true) {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        showSimpleHUD()
        ManageAPI.shared.fetchCircleUsers(userId: userId) {[weak self] (users, error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let err = error {
                    self.showErrorAlert(message: err)
                    return
                }
                self.setupHeader(users: users)
                self.tableView.reloadData()
            }
        }
    }
    
    private func acceptRequest(requestId: String) {
        showSimpleHUD()
        ManageAPI.shared.acceptCircleRequest(requestId) {[weak self] (error) in
            guard let self = self else { return }
            if let err = error {
                self.hideLoading()
                self.showErrorAlert(message: err)
                return
            }
            
            self.fetchUser()
        }
    }
    
    private func declineRequest(requestId: String) {
        showSimpleHUD()
        ManageAPI.shared.declineCircleRequest(requestId) {[weak self] (error) in
            guard let self = self else { return }
            if let err = error {
                self.hideLoading()
                self.showErrorAlert(message: err)
                return
            }
            
            self.fetchUser()
        }
    }
}

extension MyCircleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyCircleTableViewCell = tableView.dequeueCell(for: indexPath)
        let user = users[indexPath.section][indexPath.row]
        cell.setup(user: user)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headers[section]
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section < users.count, indexPath.row < users[indexPath.section].count else { return }
        let user = users[indexPath.section][indexPath.row]
        guard !user.id.isEmpty else {
            self.showErrorAlert(message: "User not found.")
            return
        }
        let controller = FriendProfileViewController.instantiate()
        controller.innerCircleStatus = user.status
        controller.basicInfo = UniversalUser(circleUser: user)
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension MyCircleViewController: MyCircleDelegate {
    
    func myCircleCellAction(_ action: MyCircleAction, circleUser: CircleUser) {
        switch action {
        case .privacy:
            let controller = MangePrivacyViewController.instantiate()
            controller.basicUser = circleUser
            self.navigationController?.pushViewController(controller, animated: true)
        case .accept:
            self.acceptRequest(requestId: circleUser.idd)
        case .decline:
            self.declineRequest(requestId: circleUser.idd)
        case .cancel:
            self.showAlert(title: "Cancel Request", message: "Are you sure you want to remove this request?", buttonTitles: ["No", "Yes"], highlightedButtonIndex: 1) { (index) in
                if index == 1 {
                    self.declineRequest(requestId: circleUser.idd)
                }
            }
        case .remove:
            self.showAlert(title: "Remove User", message: "Are you sure you want to remove this user from Circle?", buttonTitles: ["No", "Yes"], highlightedButtonIndex: 1) { (index) in
                if index == 1 {
                    self.declineRequest(requestId: circleUser.idd)
                }
            }
        default:
            break
        }
    }
}

extension MyCircleViewController: ViewFriendProfileDelegate {
    func updateList() {
        fetchUser(loading: false)
    }
}
