//
//  PhotoLikeTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 1/8/21.
//

import UIKit

class PhotoLikeTableViewCell: UITableViewCell {

    @IBOutlet weak var userAvatarView: RoundImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    func setup(_ like: PhotoLike) {
        userAvatarView.setImage(with: like.pic, placeholderImage: .avatar_small)
        userNameLabel.text = like.username
    }
}
