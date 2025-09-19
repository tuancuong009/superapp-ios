//
//  InnerCircleViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 12/24/20.
//

import UIKit

class InnerCircleViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var basicInfo: UniversalUser?
    private var users: [CircleUser] = []
    public var isTotalLikeProfile = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topBarMenuView.title = "Inner Circle"
        setupTableView()
        fetchInnerCircleUser()
    }

    override func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapBackMenuButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension InnerCircleViewController {
    
    private func setupTableView() {
        tableView.registerNibCell(identifier: SearchTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func fetchInnerCircleUser() {
        guard let userId = basicInfo?.id else { return }
        showSimpleHUD()
        if isTotalLikeProfile{
            ManageAPI.shared.fetchTotaLikes(userId: userId) {[weak self] (users, error) in
                guard let self = self else { return }
                self.hideLoading()
                self.users = users
                DispatchQueue.main.async {
                    if let err = error {
                        self.showErrorAlert(message: err)
                        return
                    }
                    self.tableView.reloadData()
                }
            }
        }
        else{
            ManageAPI.shared.fetchCircleUsers(userId: userId) {[weak self] (users, error) in
                guard let self = self else { return }
                self.hideLoading()
                self.users = users.filter({$0.status == .inner})
                DispatchQueue.main.async {
                    if let err = error {
                        self.showErrorAlert(message: err)
                        return
                    }
                    self.tableView.reloadData()
                }
            }
        }
      
    }
}

extension InnerCircleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.setupInnerCircleUser(users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < users.count else { return }
        let user = users[indexPath.row]
        if user.id == AppSettings.shared.userLogin?.userId {
            navigationController?.pushViewController(MyProfileViewController.instantiate(), animated: true)
        } else {
            let controller = FriendProfileViewController.instantiate()
            controller.basicInfo = UniversalUser(circleUser: user)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
