//
//  StoryFeedCollectionViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 08/12/2023.
//

import UIKit

class StoryFeedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var icAdd: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var icAvatar: UIImageView!
    @IBOutlet weak var imgCell: UIImageView!
    func setup(newFeed: NewFeed) {
        icAvatar.setImage(with: newFeed.userpic, placeholderImage: .avatar_small)
        lblName.text = newFeed.username
        switch newFeed.newFeedType {
        case .image:
            if UIDevice.current.userInterfaceIdiom == .pad {
                imgCell.setImage(with: newFeed.pic, placeholderImage: .none)
            } else {
                imgCell.setImage(with: newFeed.pic, placeholderImage: .photoFeed)
            }
        case .video:
            imgCell.image = nil
            if let url = URL(string: newFeed.pic) {
                VideoThumbnail.shared.getThumbnailImageFromVideoUrl(url: url) { (image) in
                    DispatchQueue.main.async {
                        if let image = image {
                            self.imgCell.image = image
                        }
                    }
                }
            }
        }
    }
}
