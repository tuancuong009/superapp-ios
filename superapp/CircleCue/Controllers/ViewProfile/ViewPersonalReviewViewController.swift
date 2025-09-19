//
//  ViewPersonalReviewViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 12/14/20.
//

import UIKit

class ViewPersonalReviewViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    var personalUserId: String?
    var reviews: [Review] = [] {
        didSet {
            noDataLabel.isHidden = !reviews.isEmpty
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        noDataLabel.text = "No Reviews Posted"
        noDataLabel.isHidden = true
        setupTableView()
        fetchMyReview()
    }
}

extension ViewPersonalReviewViewController {
    
    private func fetchMyReview() {
        guard let userId = personalUserId else { return }
        showSimpleHUD()
        
        ManageAPI.shared.fetchMyReviews(userId) {[weak self] (results) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                self.reviews = results
                self.tableView.reloadData()
            }
        }
    }
}

extension ViewPersonalReviewViewController {
    private func setupTableView() {
        tableView.registerNibCell(identifier: OldPostTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension ViewPersonalReviewViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OldPostTableViewCell.identifier, for: indexPath) as! OldPostTableViewCell
        let review = reviews[indexPath.row]
        cell.setup(review)
        cell.delegate = self
        return cell
    }
}

extension ViewPersonalReviewViewController: ReviewDelegate {
    
    func viewUserProfile(_ review: Review) {
        print(review)
        if review.uid2 == AppSettings.shared.userLogin?.userId {
            navigationController?.pushViewController(MyProfileViewController.instantiate(), animated: true)
        } else {
            let controller = FriendProfileViewController.instantiate()
            controller.basicInfo = UniversalUser(id: review.uid2, username: review.bname, country: nil, pic: nil)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
