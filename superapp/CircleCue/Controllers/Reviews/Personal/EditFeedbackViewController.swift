//
//  EditFeedbackViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/27/20.
//

import UIKit
import Alamofire

protocol EditFeedbackDelegate: AnyObject {
    func shouldReload()
}

class EditFeedbackViewController: BaseViewController {
    
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
        
    var review: Review?
    weak var delegate: EditFeedbackDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func updateAction(_ sender: Any) {
        guard let reviewId = review?.id, !reviewId.isEmpty else { return }
        view.endEditing(true)
        var error: [String] = []
        var para: Parameters = ["id": reviewId]
        
        if ratingView.rating == 0 {
            error.append(ErrorMessage.notRating.rawValue)
        } else {
            para.updateValue(ratingView.rating, forKey: "rating")
        }
        
        if reviewTextView.text.trimmed.isEmpty {
            error.append(ErrorMessage.reviewEmpty.rawValue)
        } else {
            para.updateValue(reviewTextView.text.trimmed, forKey: "content")
        }
    
        guard error.isEmpty else {
            let errorMessage = error.joined(separator: "\n")
            self.showErrorAlert(message: errorMessage)
            return
        }
        
        self.updateReview(para)
    }
}

extension EditFeedbackViewController {
    
    private func updateReview(_ para: Parameters) {
        showSimpleHUD()
        ManageAPI.shared.updateReview(para: para) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let err = error {
                    return self.showErrorAlert(message: err)
                }
                self.delegate?.shouldReload()
                self.showAlert(title: "Successfully Updated!", message: "Your review has been updated.") { (index) in
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    private func setup() {
        setupUI()
        setupTextView()
    }
    
    private func setupUI() {
        guard let review = review else { return }
        businessNameLabel.createBasicAttribute(content: "Name/Address of the Business: ", highlightContent: review.bname, highlightFont: .myriadProBold(ofSize: 17), highlightColor: Constants.yellow)
        emailLabel.isHidden = review.bemail.isEmpty
        emailLabel.createBasicAttribute(content: "Email Address/Telephone (Optional):\n", highlightContent: review.bemail, highlightFont: .myriadProBold(ofSize: 17), highlightColor: Constants.yellow)
        
        emailLabel.numberOfLines = 0
        
        ratingView.rating = review.rating
        reviewTextView.text = review.content
        placeholderLabel.isHidden = reviewTextView.hasText
    }
    
    private func setupTextView() {
        reviewTextView.textContainerInset.left = 6
        reviewTextView.textContainerInset.right = 6
        reviewTextView.delegate = self
    }
}

extension EditFeedbackViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.hasText
    }
}
