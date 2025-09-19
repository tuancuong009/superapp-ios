//
//  ViewBusinessReviewViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 12/14/20.
//

import UIKit

class ViewBusinessReviewViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    var businessUserId: String?
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

extension ViewBusinessReviewViewController {
    private func fetchReview() {
        guard let userId = businessUserId else { return }
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

extension ViewBusinessReviewViewController {
    
    private func setupTableView() {
        tableView.registerNibCell(identifier: BusinessFeedbackTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension ViewBusinessReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let review = reviews[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: BusinessFeedbackTableViewCell.identifier, for: indexPath) as! BusinessFeedbackTableViewCell
        cell.setup(review: review)
        cell.delegate = self
        return cell
    }
}

extension ViewBusinessReviewViewController: ReviewDelegate {
    
    func viewUserProfile(_ review: Review) {
        print(review)
        if review.uid1 == AppSettings.shared.userLogin?.userId {
            navigationController?.pushViewController(MyProfileViewController.instantiate(), animated: true)
        } else {
            let controller = FriendProfileViewController.instantiate()
            controller.basicInfo = UniversalUser(id: review.uid1, username: review.rname, country: nil, pic: nil)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

