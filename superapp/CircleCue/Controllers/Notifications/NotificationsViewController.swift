//
//  NotificationsViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 14/06/2021.
//

import UIKit
import Alamofire
class NotificationsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var swiftNotification: UISwitch!
    
    private var notifications: [NotificationObject] = [] {
        didSet {
            noDataLabel.isHidden = !notifications.isEmpty
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataLabel.text = "No Notifications"
        noDataLabel.isHidden = true
        setupTableView()
        fetchNotificationList()
        
        swiftNotification.isOn = !(AppSettings.shared.currentUser?.notifications ?? false)
    }
    @IBAction func changeNotifications(_ sender: Any) {
        let param: Parameters = ["id": AppSettings.shared.currentUser?.userId ?? "", "notifications": swiftNotification.isOn ? "0" : "1"]
        AppSettings.shared.currentUser?.notifications = swiftNotification.isOn ? false : true
        ManageAPI.shared.updateNotifications(params: param) { success, error in
            
        }
    }
}

extension NotificationsViewController {
    
    private func setupTableView() {
        tableView.registerNibCell(identifier: NotificationTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
    }
    
    private func fetchNotificationList() {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        showSimpleHUD()
        ManageAPI.shared.fetchNotification(for: userId) { [weak self] (results, error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                self.notifications = results
                self.tableView.reloadData()
            }
        }
    }
    
    private func makeNotificationAsSeen(id: String) {
        ManageAPI.shared.makeNotificationAsSeen(id: id) { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard error != nil else { return }
                self.showErrorAlert(message: error?.msg)
                if let index = self.notifications.firstIndex(where: { $0.id == id }) {
                    self.notifications[index].seen = false
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.identifier, for: indexPath) as! NotificationTableViewCell
        cell.setup(notifications[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < notifications.count else { return }
        let item = notifications[indexPath.row]
        guard !item.seen else { return }
        makeNotificationAsSeen(id: item.id)
        item.seen = true
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    //MARK: - Contextual Actions
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [
            makeDeleteContextualAction(forRowAt: indexPath)
        ])
    }
    
    //MARK: - Contextual Actions
    private func makeDeleteContextualAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, swipeButtonView, completion) in
            print("DELETE HERE")
            DispatchQueue.main.async {
                self.deleteNotification(notification: self.notifications[indexPath.row])
            }
            completion(true)
        }
        action.backgroundColor = .systemRed
        return action
    }
    
    private func deleteNotification(notification: NotificationObject) {
        self.showSimpleHUD()
        ManageAPI.shared.deleteNotification(id: notification.id) {[weak self] error in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                guard error == nil else {
                    self.showErrorAlert(message: error?.msg)
                    return
                }
                
                guard let index = self.notifications.firstIndex(where: { $0.id == notification.id }) else { return }
                self.notifications.remove(at: index)
                self.tableView.performBatchUpdates {
                    self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
                } completion: { _ in
                    self.tableView.reloadData()
                }
            }
        }
    }
}
