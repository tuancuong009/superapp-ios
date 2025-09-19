//
//  ProfileAlbumCollectionViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 1/4/21.
//

import UIKit
import AVKit

class ProfileAlbumCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: RoundImageView!
    @IBOutlet weak var photoTypeImage: UIImageView!
    
    static let width: CGFloat = (UIScreen.main.bounds.width - 80) / 3
    static let cellSize: CGSize = CGSize(width: width, height: width)
    
    private var item: Gallery?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoTypeImage.image = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        item = nil
        photoTypeImage.image = nil
        photoImageView.image = nil
    }
    
    func setup(_ item: Gallery) {
        self.item = item
        photoTypeImage.image = item.albumType.image
        switch item.albumType {
        case .image:
            if UIDevice.current.userInterfaceIdiom == .pad {
                photoImageView.setImage(with: item.pic, placeholderImage: .none)
            } else {
                photoImageView.setImage(with: item.pic, placeholderImage: .photo)
            }
        case .video:
            if let url = URL(string: item.pic) {
                VideoThumbnail.shared.getThumbnailImageFromVideoUrl(url: url) { (image) in
                    DispatchQueue.main.async {
                        if let image = image {
                            self.photoImageView.image = image
                        } else {
                            self.photoImageView.image = PlaceHolderImage.video.image
                        }
                    }
                }
            }
        }
    }
}
