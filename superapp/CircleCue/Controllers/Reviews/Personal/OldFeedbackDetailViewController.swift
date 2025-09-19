//
//  OldFeedbackDetailViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 11/13/20.
//

import UIKit

class OldFeedbackDetailViewController: BaseViewController {
    
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var myCommentLabel: UILabel!
    @IBOutlet weak var replyFromLabel: UILabel!
    @IBOutlet weak var replyContentLabel: UILabel!
    @IBOutlet weak var editOptionStackView: UIStackView!
    @IBOutlet weak var reviewNameButton: UIButton!
    @IBOutlet weak var reviewDateLabel: UILabel!
    
    var viewing: Bool = false
    var review: Review?
    weak var delegate: EditFeedbackDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func editAction(_ sender: Any) {
        let controller = EditFeedbackViewController.instantiate()
        controller.review = review
        controller.delegate = delegate
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        showDeleteConfirm(review: review)
    }
    
    @IBAction func viewProfileAction(_ sender: Any) {
        guard let review = review else { return }
        if review.uid1 == AppSettings.shared.userLogin?.userId {
            return
        } else {
            let controller = FriendProfileViewController.instantiate()
            controller.basicInfo = UniversalUser(id: review.uid1, username: review.rname, country: nil, pic: nil)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension OldFeedbackDetailViewController {
    
    private func setup() {
        editOptionStackView.isHidden = viewing
        topBarMenuView.title = "Review Details"
        setupUI()
    }
    
    private func setupUI() {
        guard let review = review else { return }
        reviewNameButton.createCustomAttribute(content: "By: ", highlightContent: review.rname, highlightFont: .myriadProBold(ofSize: 17), highlightColor: Constants.yellow, contentFont: .myriadProRegular(ofSize: 17), contentColor: .white)
        reviewDateLabel.text = review.createdDate?.toDateString(.noteDashboard)
        if viewing {
            businessNameLabel.createBasicAttribute(content: "For: ", highlightContent: review.bname, highlightFont: .myriadProBold(ofSize: 17), highlightColor: Constants.yellow)
            emailLabel.isHidden = true
        } else {
            businessNameLabel.createBasicAttribute(content: "Name/Address of the Business: ", highlightContent: review.bname, highlightFont: .myriadProBold(ofSize: 17), highlightColor: Constants.yellow)
            emailLabel.isHidden = review.bemail.isEmpty
            emailLabel.createBasicAttribute(content: "Email Address/Telephone (Optional):\n", highlightContent: review.bemail, highlightFont: .myriadProBold(ofSize: 17), highlightColor: Constants.yellow)
            
            emailLabel.numberOfLines = 0
        }
        
        ratingView.rating = review.rating
        myCommentLabel.text = review.content
        if let reply = review.rply {
            replyFromLabel.createBasicAttribute(content: "Replied by CC Business - ", highlightContent: review.bname + ":", highlightFont: .myriadProBold(ofSize: 17), highlightColor: .white)
            replyContentLabel.text = reply
        } else {
            replyFromLabel.text = nil
            replyContentLabel.text = nil
        }
    }
    
    private func showDeleteConfirm(review: Review?) {
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
    
    private func delete(review: Review?) {
        guard let review = review else { return }
        showSimpleHUD()
        ManageAPI.shared.deleteReview(review.id) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let err = error {
                    return self.showErrorAlert(message: err)
                }
                self.delegate?.shouldReload()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
