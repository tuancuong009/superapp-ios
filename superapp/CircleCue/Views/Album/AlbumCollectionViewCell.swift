//
//  AlbumCollectionViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 11/10/20.
//

import UIKit
import AVFoundation

class AlbumCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var videoTypeImage: UIImageView!
    @IBOutlet weak var switchButton: UISwitch!
    
    weak var delegate: PhotoAlbumDelegate?
    var photo: Gallery?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        videoTypeImage.image = nil
        switchButton.layer.cornerRadius = 16
        switchButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photo = nil
        videoTypeImage.image = nil
    }
    
    func setup(item: Gallery) {
        self.photo = item
        locationLabel.text = item.title
        captionLabel.text = item.description
        timeLabel.text = item.date.toDate(.addNote)?.toAlbumDate()
        videoTypeImage.image = item.albumType.image
        switchButton.isOn = item.showOnFeed
        
        switch item.albumType {
        case .image:
            if UIDevice.current.userInterfaceIdiom == .pad {
                photoImageView.setImage(with: item.pic, placeholderImage: .none)
            } else {
                photoImageView.setImage(with: item.pic, placeholderImage: .photo)
            }
        case .video:
            photoImageView.image = PlaceHolderImage.video.image
            if let url = URL(string: item.pic) {
                VideoThumbnail.shared.getThumbnailImageFromVideoUrl(url: url) { (image) in
                    DispatchQueue.main.async {
                        if let image = image {
                            self.photoImageView.image = image
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        guard let photo = photo else { return }
        delegate?.deletePhoto(photo: photo)
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        guard let photo = photo else { return }
        delegate?.changeShowOnFeed(photo: photo)
    }
}
