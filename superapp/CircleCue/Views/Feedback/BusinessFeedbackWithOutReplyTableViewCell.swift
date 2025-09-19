//
//  BusinessFeedbackWithOutReplyTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/23/20.
//

import UIKit

protocol BusinessFeedbackDelegate: AnyObject {
    func showReplyViewFor(_ review: Review)
    func textViewDidChange(_ review: Review)
    func cancelReply(_ review: Review)
    func submitReply(_ review: Review)
}

class BusinessFeedbackWithOutReplyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postByLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var replyContainerView: UIView!
    
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var replyTextView: UITextView!
    
    weak var delegate: BusinessFeedbackDelegate?
    var review: Review?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        replyContainerView.isHidden = true
        replyTextView.textContainerInset.left = 4
        dateLabel.text = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        review = nil
        replyContainerView.isHidden = true
        replyButton.isHidden = false
    }
    
    func setup(review: Review) {
        self.review = review
        postByLabel.createBasicAttribute(content: "Posted by ", highlightContent: review.rname, highlightFont: UIFont.myriadProBold(ofSize: 17), highlightColor: .white)
        dateLabel.text = review.createdDate?.toDateString(.noteDashboard)
        ratingView.rating = review.rating
        commentLabel.text = review.content
        replyContainerView.isHidden = !review.isRepling
        replyButton.isHidden = review.isRepling
        replyTextView.text = review.rply
        placeholderLabel.isHidden = replyTextView.hasText
    }
    
    @IBAction func replyAction(_ sender: Any) {
        guard let review = review else { return }
        delegate?.showReplyViewFor(review)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        guard let review = review else { return }
        delegate?.cancelReply(review)
        replyTextView.text = nil
    }
    
    @IBAction func submitAction(_ sender: Any) {
        guard var review = review, replyTextView.hasText else { return }
        review.rply = replyTextView.text.trimmed
        delegate?.submitReply(review)
    }
}

extension BusinessFeedbackWithOutReplyTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.hasText
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard var review = review else { return }
        review.rply = textView.text.trimmed
        delegate?.textViewDidChange(review)
    }
}
