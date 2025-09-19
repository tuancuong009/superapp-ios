//
//  FavoritesViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/6/20.
//

import UIKit

protocol ViewFriendProfileDelegate: AnyObject {
    func updateList()
}

class FavoritesViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    var users: [UniversalUser] = [] {
        didSet {
            noDataLabel.isHidden = !users.isEmpty
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataLabel.text = "No Favorites added yet"
        noDataLabel.isHidden = true
        setupTableView()
        fetchUser()
    }
}

extension FavoritesViewController {
    
    private func setupTableView() {
        tableView.registerNibCell(identifier: SearchTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .clear
    }
    
    private func fetchUser(loading: Bool = true) {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        showSimpleHUD()
        ManageAPI.shared.fetchFavoriteUsers(userId: userId) {[weak self] (users, error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let err = error {
                    self.showErrorAlert(message: err)
                    return
                }
                self.users = users.filter({ $0.id != nil || $0.id?.isEmpty == false })
                self.tableView.reloadData()
            }
        }
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        cell.setup(users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < users.count else { return }
        let user = users[indexPath.row]
        guard user.id?.isEmpty == false else {
            self.showErrorAlert(message: "User not found.")
            return
        }
        let controller = FriendProfileViewController.instantiate()
        controller.favoriteStatus = .favorite
        controller.basicInfo = user
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension FavoritesViewController: ViewFriendProfileDelegate {
    func updateList() {
        fetchUser(loading: false)
    }
}
