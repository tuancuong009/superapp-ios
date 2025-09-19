//
//  MessageViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/6/20.
//

import UIKit

class MessageViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    var type: MenuItem?
    
    private var page = 1
    private var hasLoadMore = true
    private var isLoading = false
    private var messages: [MessageDashboard] = [] {
        didSet {
            noDataLabel.isHidden = !messages.isEmpty
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataLabel.text = "No Inbox messages yet"
        noDataLabel.isHidden = true
        setupTableView()
        fetchMessageList()
    }
}

extension MessageViewController {
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "MessageDashboardTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageDashboardTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 85
        tableView.backgroundColor = .clear
    }
    
    private func fetchMessageList() {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        showSimpleHUD()
        ManageAPI.shared.fetchUserMessageList(userId) {[weak self] (results) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                self.messages = results.filter({ $0.id.isEmpty == false })
                self.hasLoadMore = !results.isEmpty
                self.tableView.reloadData()
            }
        }
    }
    
    private func fetchMoreMessageList() {
        guard hasLoadMore, !isLoading, let userId = AppSettings.shared.userLogin?.userId else { return }
        isLoading = true
        page += 1
        ManageAPI.shared.fetchUserMessageList(userId, page: page) {[weak self] (results) in
            guard let self = self else { return }
            self.isLoading = false
            DispatchQueue.main.async {
                self.messages.append(contentsOf: results.filter({ $0.id.isEmpty == false }))
                self.hasLoadMore = !results.isEmpty
                self.tableView.reloadData()
            }
        }
    }
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageDashboardTableViewCell", for: indexPath) as! MessageDashboardTableViewCell
        cell.setup(message: messages[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard hasLoadMore, indexPath.row == messages.count-1 else { return }
        fetchMoreMessageList()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < messages.count else { return }
        let message = messages[indexPath.row]
        let controller = MessageStreamViewController.instantiate()
        controller.friendUser = UniversalUser(id: message.id, username: message.username, country: message.country, pic: message.pic)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Contextual Actions
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [
            makeArchiveContextualAction(forRowAt: indexPath)
        ])
    }
    
    //MARK: - Contextual Actions
    private func makeArchiveContextualAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Archive") { (action, swipeButtonView, completion) in
            DispatchQueue.main.async {
                self.showAlert(title: "Archive Message", message: "Once archived it can't be unarchived. It will permanently disappear from your inbox. You can also block and report the user to admin@circlecue.com", buttonTitles: ["Cancel", "Archive"], highlightedButtonIndex: 1) { index in
                    if index == 1 {
                        self.archiveMessage(message: self.messages[indexPath.row], at: indexPath)
                    }
                }
            }
            completion(true)
        }
        action.backgroundColor = .systemBlue
        return action
    }
    
    private func archiveMessage(message: MessageDashboard, at indexPath: IndexPath) {
        self.showSimpleHUD(text: "Archiving...")
        ManageAPI.shared.archiveMessage(from: message.id1, to: message.id2) { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hideLoading()
                guard error == nil else {
                    self.showErrorAlert(message: error)
                    return
                }
                self.messages.remove(at: indexPath.row)
                self.tableView.performBatchUpdates {
                    self.tableView.deleteRows(at: [indexPath], with: .left)
                } completion: { _ in
                    self.tableView.reloadData()
                }
                
                self.view.makeToast("Your message has been archived")
            }
        }
    }
}
