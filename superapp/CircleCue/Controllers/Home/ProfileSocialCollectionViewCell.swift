//
//  ProfileSocialCollectionViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/13/20.
//

import UIKit

class ProfileSocialCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var socialImageView: UIImageView!
    
    static let size = CGSize(width: (UIScreen.main.bounds.width - 80)/3, height: 80)
    
    func setup(_ item: HomeSocialItem) {
        socialImageView.image = item.type.image
        socialImageView.layer.borderWidth = (item.type == SocialMedia.website) ? 0 : 1
    }
}
