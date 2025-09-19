//
//  BusinessFeedbackTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/23/20.
//

import UIKit

class BusinessFeedbackTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postByLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var replyTitleLabel: UILabel!
    @IBOutlet weak var replyContentLabel: UILabel!
    
    weak var delegate: ReviewDelegate?
    private var review: Review?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateLabel.text = nil
    }
    
    func setup(review: Review) {
        self.review = review
        postByLabel.createBasicAttribute(content: "Posted by ", highlightContent: review.rname, highlightFont: UIFont.myriadProBold(ofSize: 17), highlightColor: .white)
        dateLabel.text = review.createdDate?.toDateString(.noteDashboard)
        ratingView.rating = review.rating
        commentLabel.text = review.content
        if review.isReplied {
            replyTitleLabel.createCustomAttribute(content: "Reply by CC Business ", highlightContent: review.bname + ":", highlightFont: UIFont.myriadProBold(ofSize: 17), highlightColor: .white, contentFont: .myriadProRegular(ofSize: 17), contentColor: Constants.yellow)
            replyContentLabel.text = "\"\(review.rply ?? "")\""
        } else {
            replyTitleLabel.text = "No reply."
            replyContentLabel.text = nil
        }
    }
    
    @IBAction func viewUserProfile(_ sender: Any) {
        guard let review = review else { return }
        delegate?.viewUserProfile(review)
    }
}
