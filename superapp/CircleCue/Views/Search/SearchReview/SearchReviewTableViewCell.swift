//
//  SearchReviewTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 1/20/21.
//

import UIKit

class SearchReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var reviewNameButton: UIButton!
    @IBOutlet weak var reviewDateLabel: UILabel!
    
    weak var delegate: ReviewDelegate?
    private var review: Review?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        review = nil
    }
    
    func setup(_ review: Review) {
        self.review = review
        businessNameLabel.text = review.bname
        detailLabel.text = review.content
        ratingView.rating = review.rating
        let rname = "By: \(review.rname)"
        reviewNameButton.titleLabel?.text = rname
        reviewNameButton.setTitle(rname, for: .normal)
        reviewDateLabel.text = review.createdDate?.toDateString(.noteDashboard)
    }
    
    @IBAction func viewProfileAction(_ sender: Any) {
        guard let review = review else { return }
        delegate?.viewUserProfile(review)
    }
}
