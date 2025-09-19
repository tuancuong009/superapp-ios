//
//  FollowingViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 06/06/2022.
//

import UIKit

enum FollowingStatus: String {
    case following
    case followers
}

class FollowingViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var basicInfo: UniversalUser?
    var followingStatus: FollowingStatus = .following
    
    private var users: [FollowingUser] = []
    private var searchUsers: [FollowingUser] = []
    private var isFisrtLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        
        switch followingStatus {
        case .following:
            fetchFollowingUser()
        case .followers:
            fetchFollwerUser()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard !isFisrtLoad else {
            isFisrtLoad = false
            return
        }
        switch followingStatus {
        case .following:
            refreshFollowingUser()
        case .followers:
            refreshFollowerUser()
        }
    }
    
    override func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapBackMenuButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension FollowingViewController {
    
    private func setupUI() {
        self.topBarMenuView.title = followingStatus.rawValue.capitalized
        self.searchTextField.addTarget(self, action: #selector(self.handleSearch(_:)), for: .editingChanged)
        self.searchTextField.delegate = self
    }
    
    private func setupTableView() {
        tableView.registerNibCell(identifier: SearchTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @objc private func handleSearch(_ textField: UITextField) {
        guard let text = textField.trimmedText, !text.isEmpty else {
            self.searchUsers = users
            self.tableView.reloadData()
            return
        }
        
        self.searchUsers.removeAll()
        for user in users {
            let nameRange = user.username.lowercased().range(of: text, options: .caseInsensitive, range: nil, locale: nil)
            if nameRange != nil {
                searchUsers.append(user)
            }
        }
        self.tableView.reloadData()
    }
    
    private func fetchFollowingUser() {
        guard let userId = basicInfo?.id else { return }
        showSimpleHUD()
        ManageAPI.shared.fetchFollowingUsers(userId: userId) {[weak self] (users, error) in
            guard let self = self else { return }
            self.hideLoading()
            self.users = users
            self.searchUsers = users
            DispatchQueue.main.async {
                if let err = error {
                    self.showErrorAlert(message: err)
                    return
                }
                self.tableView.reloadData()
            }
        }
    }
    
    private func fetchFollwerUser() {
        guard let userId = basicInfo?.id else { return }
        showSimpleHUD()
        ManageAPI.shared.fetchFollowerUsers(userId: userId) {[weak self] (users, error) in
            guard let self = self else { return }
            self.hideLoading()
            self.users = users
            self.searchUsers = users
            DispatchQueue.main.async {
                if let err = error {
                    self.showErrorAlert(message: err)
                    return
                }
                self.tableView.reloadData()
            }
        }
    }
    
    private func refreshFollowingUser() {
        guard let userId = basicInfo?.id, userId == AppSettings.shared.userLogin?.userId else { return }
        ManageAPI.shared.fetchFollowingUsers(userId: userId) {[weak self] (users, error) in
            guard let self = self else { return }
            self.users = users
            self.searchUsers = users
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func refreshFollowerUser() {
        guard let userId = basicInfo?.id, userId == AppSettings.shared.userLogin?.userId else { return }
        ManageAPI.shared.fetchFollowerUsers(userId: userId) {[weak self] (users, error) in
            guard let self = self else { return }
            self.users = users
            self.searchUsers = users
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension FollowingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.setupFollowingUser(user: searchUsers[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < searchUsers.count else { return }
        let user = searchUsers[indexPath.row]
        let userId = followingStatus == .following ? user.toid : user.fromid
        if userId == AppSettings.shared.userLogin?.userId {
            navigationController?.pushViewController(MyProfileViewController.instantiate(), animated: true)
        } else {
            let controller = FriendProfileViewController.instantiate()
            controller.basicInfo = UniversalUser(id: userId, username: user.username, country: nil, pic: nil)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension FollowingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
