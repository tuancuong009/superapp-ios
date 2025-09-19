//
//  OldPostTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/23/20.
//

import UIKit

protocol ReviewDelegate: AnyObject {
    func viewUserProfile(_ review: Review)
}

class OldPostTableViewCell: UITableViewCell {

    @IBOutlet weak var businessNameButton: UIButton!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    weak var delegate: ReviewDelegate?
    private var review: Review?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        review = nil
    }
    
    func setup(_ review: Review, hideArrow: Bool = true) {
        self.review = review
        businessNameButton.titleLabel?.text = review.bname
        businessNameButton.setTitle(review.bname, for: .normal)
        detailLabel.text = review.content
        ratingView.rating = review.rating
        arrowIcon.isHidden = hideArrow
        dateLabel.text = review.createdDate?.toDateString(.noteDashboard)
    }
    
    @IBAction func viewProfileAction(_ sender: Any) {
        guard let review = review else { return }
        delegate?.viewUserProfile(review)
    }
}
