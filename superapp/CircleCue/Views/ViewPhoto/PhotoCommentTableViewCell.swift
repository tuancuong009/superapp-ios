//
//  PhotoCommentTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 1/6/21.
//

import UIKit

class PhotoCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var userAvatarImageView: RoundImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var optionButton: UIButton!
    
    private var comment: PhotoComment?
    weak var delegate: CommentViewControllerDelegate?
    
    func setup(_ comment: PhotoComment) {
        self.comment = comment
        optionButton.isHidden = !comment.isMyComment
        userAvatarImageView.setImage(with: comment.pic, placeholderImage: .avatar_small)
        setComment(comment: comment)
        timeLabel.text = comment.created?.getElapsedTime()
    }
    
    private func setComment(comment: PhotoComment) {
        let nameAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.myriadProBold(ofSize: 15), .foregroundColor: Constants.yellow]
        let commentAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.myriadProRegular(ofSize: 15), .foregroundColor: UIColor.white]

        let attribute = NSMutableAttributedString()
        attribute.append(NSAttributedString(string: comment.username + ": ", attributes: nameAttribute))
        attribute.append(NSAttributedString(string: comment.comment, attributes: commentAttribute))

        commentLabel.attributedText = attribute
    }
    
    @IBAction func optionAction(_ sender: Any) {
        guard let comment = comment else { return }
        delegate?.showCommentOption(comment)
    }
    
    @IBAction func viewProfileAction(_ sender: Any) {
        guard let comment = comment else { return }
        delegate?.viewProfile(comment)
    }
}
