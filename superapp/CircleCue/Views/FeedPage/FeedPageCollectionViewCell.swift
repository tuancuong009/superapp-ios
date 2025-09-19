//
//  FeedPageCollectionViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 12/30/20.
//

import UIKit

class FeedPageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarImageView: RoundImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userCountryLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
        avatarImageView.layer.borderColor = UIColor.init(hex: "ffffff").cgColor
        avatarImageView.layer.borderWidth = 1.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        avatarImageView.layer.cornerRadius = avatarImageView.frame.height/2
    }
    
    func setup(_ user: UniversalUser) {
        avatarImageView.setImage(with: user.pic ?? "", placeholderImage: .avatar)
        userNameLabel.text = user.username
        userCountryLabel.text = user.locationInfomation
    }
}
