//
//  ForwardMessageViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/20/20.
//

import UIKit
import Alamofire

class ForwardMessageViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: MessageStreamViewControllerDelegate?
    var currentId: String?
    var message: Message?
    var users: [CircleUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchUser()
    }
    
    @IBAction func sendAction(_ sender: Any) {
        guard let message = message, let userId = AppSettings.shared.userLogin?.userId else { return }
        let selectedUser = users.filter({$0.isSelected == true})
        if selectedUser.isEmpty {
            self.showErrorAlert(message: "Please select at least one user.")
            return
        }
        
        self.showSimpleHUD(text: "Forwarding...")
        let group = DispatchGroup()
        for user in selectedUser {
            var para: Parameters = ["sid": userId, "rid": user.id, "msg": message.message, "media": message.media]
            switch message.messageType {
            case .image, .imageWithText, .video, .videoWithText:
                para.updateValue(message.type as Any, forKey: "type")
            default:
                break
            }
            group.enter()
            sendMessage(para: para, group: group)
        }
        
        group.notify(queue: .main) {
            self.hideLoading()
            if let _ = selectedUser.firstIndex(where: {$0.id == message.receiver_id}) {
                self.delegate?.fetchNewMessage()
            }
            self.showAlert(title: "", message: "Your message has been forwarded.", buttonTitles: ["OK"], highlightedButtonIndex: nil) { (_) in
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        print(selectedUser)
    }
}

extension ForwardMessageViewController {
    
    private func setupTableView() {
        tableView.registerNibCell(identifier: ForwardMessageTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.backgroundColor = .clear
    }
    
    private func fetchUser() {
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
                self.users = users
                self.tableView.reloadData()
            }
        }
    }
    
    private func sendMessage(para: Parameters, group: DispatchGroup) {
        ManageAPI.shared.sendMessageToUser(para: para) { (_) in
            group.leave()
        }
    }
}

extension ForwardMessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForwardMessageTableViewCell.identifier, for: indexPath) as! ForwardMessageTableViewCell
        cell.setup(user: users[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension ForwardMessageViewController: ForwardMessageDelegate {
    func update(_ user: CircleUser) {
        if let index = users.firstIndex(where: {$0.idd == user.idd}) {
            users[index] = user
            UIView.performWithoutAnimation {
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
}
