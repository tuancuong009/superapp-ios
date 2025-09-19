//
//  NotificationSuperViewController.swift
//  SuperApp
//
//  Created by QTS Coder on 13/5/25.
//

import UIKit
import LGSideMenuController
class NotificationSuperViewController: BaseViewController {

    @IBOutlet weak var tblNotifications: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    private var notifications: [NotificationObject] = [] {
        didSet {
            noDataLabel.isHidden = !notifications.isEmpty
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataLabel.isHidden = true
        tblNotifications.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
        fetchNotificationList()
        // Do any additional setup after loading the view.
    }

    private func fetchNotificationList() {
        guard let userId = UserDefaults.standard.value(forKey: USER_ID_SUPER_APP) as? String else { return }
        showSimpleHUD()
        ManageAPI.shared.fetchNotificationSuperApp(for: "1") { [weak self] (results, error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                self.notifications = results
                self.tblNotifications.reloadData()
            }
        }
    }
    
    private func makeNotificationAsSeen(id: String) {
        ManageAPI.shared.makeNotificationAsSeenSuperApp(id: id) { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard error != nil else { return }
                self.showErrorAlert(message: error?.msg)
                if let index = self.notifications.firstIndex(where: { $0.id == id }) {
                    self.notifications[index].seen = false
                    self.tblNotifications.reloadData()
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doMenu(_ sender: Any) {
        self.sideMenuController?.showLeftView()
    }
    
}

extension NotificationSuperViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblNotifications.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell
        cell.descitpionLabel.textColor = .black
        cell.setup(notifications[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblNotifications.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < notifications.count else { return }
        let item = notifications[indexPath.row]
        guard !item.seen else { return }
        makeNotificationAsSeen(id: item.id)
        item.seen = true
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
