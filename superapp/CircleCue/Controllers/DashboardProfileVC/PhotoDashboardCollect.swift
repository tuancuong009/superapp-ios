//
//  PhotoDashboardCollect.swift
//  CircleCue
//
//  Created by QTS Coder on 27/12/24.
//

import UIKit

class PhotoDashboardCollect: UICollectionViewCell {

    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var btnPlay: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setup(_ item: Gallery) {
        switch item.albumType {
        case .image:
            btnPlay.isHidden = true
            if UIDevice.current.userInterfaceIdiom == .pad {
                imgCell.setImage(with: item.pic, placeholderImage: .none)
            } else {
                imgCell.setImage(with: item.pic, placeholderImage: .photo)
            }
        case .video:
            btnPlay.isHidden = false
            if let url = URL(string: item.pic) {
                VideoThumbnail.shared.getThumbnailImageFromVideoUrl(url: url) { (image) in
                    DispatchQueue.main.async {
                        if let image = image {
                            self.imgCell.image = image
                        } else {
                            self.imgCell.image = PlaceHolderImage.video.image
                        }
                    }
                }
            }
        }
    }
}
