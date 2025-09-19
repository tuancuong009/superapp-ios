//
//  BusinessFeedbackViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/23/20.
//

import UIKit

class BusinessFeedbackViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    private var reviews: [Review] = [] {
        didSet {
            noDataLabel.isHidden = !reviews.isEmpty
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataLabel.text = "No Reviews Posted"
        noDataLabel.isHidden = true
        setupTableView()
        fetchReview()
    }
}

extension BusinessFeedbackViewController {
    private func fetchReview() {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        showSimpleHUD()
        ManageAPI.shared.fetchMyReviews(userId, isBusiness: true) {[weak self] (results) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                self.reviews = results
                self.tableView.reloadData()
            }
        }
    }
}

extension BusinessFeedbackViewController {
    
    private func setupTableView() {
        tableView.registerNibCell(identifier: BusinessFeedbackTableViewCell.identifier)
        tableView.registerNibCell(identifier: BusinessFeedbackWithOutReplyTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension BusinessFeedbackViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let review = reviews[indexPath.row]
        if review.isReplied && !review.isRepling {
            let cell = tableView.dequeueReusableCell(withIdentifier: BusinessFeedbackTableViewCell.identifier, for: indexPath) as! BusinessFeedbackTableViewCell
            cell.setup(review: review)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BusinessFeedbackWithOutReplyTableViewCell.identifier, for: indexPath) as! BusinessFeedbackWithOutReplyTableViewCell
        cell.setup(review: review)
        cell.delegate = self
        return cell
    }
}

extension BusinessFeedbackViewController: BusinessFeedbackDelegate {
    func showReplyViewFor(_ review: Review) {
        if let index = reviews.firstIndex(where: {$0.id == review.id}) {
            reviews[index].isRepling.toggle()
            tableView.beginUpdates()
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func textViewDidChange(_ review: Review) {
        if let index = reviews.firstIndex(where: {$0.id == review.id}) {
            reviews[index].isRepling = true
            reviews[index].rply = review.rply
            UIView.performWithoutAnimation {
                self.tableView.beginUpdates()
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                self.tableView.endUpdates()
            }
        }
    }
    
    func cancelReply(_ review: Review) {
        if let index = reviews.firstIndex(where: {$0.id == review.id}) {
            reviews[index].isRepling = false
            reviews[index].rply = nil
            tableView.beginUpdates()
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func submitReply(_ review: Review) {
        guard let userId = AppSettings.shared.userLogin?.userId, let reply = review.rply else { return }
        let para = ["rid": review.id, "bid": userId, "content": reply]
        view.endEditing(true)
        showSimpleHUD()
        ManageAPI.shared.replyReview(para) {[weak self] (error) in
            guard let self = self else { return }
            if error == nil {
                self.fetchReview()
                return
            }
            
            DispatchQueue.main.async {
                self.hideLoading()
                self.showErrorAlert(message: error)
            }
        }
    }
}
