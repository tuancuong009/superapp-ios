//
//  OldFeedbackViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/23/20.
//

import UIKit

class OldFeedbackViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
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

extension OldFeedbackViewController {
    
    private func fetchMyReview(_ loading: Bool = true) {
        guard isViewLoaded else { return }
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        if loading {
            showSimpleHUD()
        }
        
        ManageAPI.shared.fetchMyReviews(userId) {[weak self] (results) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                self.reviews = results
                self.tableView.reloadData()
            }
        }
    }
    
    func updateData() {
        fetchMyReview()
    }
}

extension OldFeedbackViewController {
    private func setupTableView() {
        tableView.registerNibCell(identifier: OldPostTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func delete(review: Review) {
        showSimpleHUD()
        ManageAPI.shared.deleteReview(review.id) {[weak self] (error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let err = error {
                    self.hideLoading()
                    return self.showErrorAlert(message: err)
                }
                
                self.fetchMyReview()
            }
        }
    }
    
    private func edit(review: Review) {
        let controller = EditFeedbackViewController.instantiate()
        controller.delegate = self
        controller.review = review
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func showDeleteConfirm(review: Review) {
        let alert = UIAlertController(title: "Are you sure you want to delete ?", message: nil, preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            self.delete(review: review)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            alert.popoverPresentationController?.permittedArrowDirections = []
        }
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension OldFeedbackViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OldPostTableViewCell.identifier, for: indexPath) as! OldPostTableViewCell
        let review = reviews[indexPath.row]
        cell.setup(review, hideArrow: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.showDeleteConfirm(review: self.reviews[indexPath.row])
        }

        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.edit(review: self.reviews[indexPath.row])
        }

        edit.backgroundColor = Constants.light_blue

        return [delete, edit]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < reviews.count else { return }
        let controller = OldFeedbackDetailViewController.instantiate()
        controller.review = reviews[indexPath.row]
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension OldFeedbackViewController: EditFeedbackDelegate {
    
    func shouldReload() {
        fetchMyReview(false)
    }
}
