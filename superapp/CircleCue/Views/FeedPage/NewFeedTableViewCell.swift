//
//  NewFeedTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 3/26/21.
//

import UIKit

protocol NewFeedTableViewCellDelegate: AnyObject {
    func viewUserProfileAction(_ newFeed: NewFeed)
    func likeAction(_ newFeed: NewFeed)
    func viewComment(_ newFeed: NewFeed)
    func viewLikeAction(_ newFeed: NewFeed)
    func playVideo(_ newFeed: NewFeed)
    func viewPhoto(_ newFeed: NewFeed, imageView: UIImageView)
}

class NewFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var userAvatarImageView: RoundImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var photoLocationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var feedImageView: RoundImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeContentLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var numberOfCommentButtton: UIButton!
    @IBOutlet weak var photoDescriptionLabel: UILabel!
    
    private var newFeed: NewFeed?
    weak var delegate: NewFeedTableViewCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newFeed = nil
        numberOfCommentButtton.isHidden = true
        photoDescriptionLabel.text = nil
    }
    
    func setup(newFeed: NewFeed) {
        self.newFeed = newFeed
        self.numberOfCommentButtton.isHidden = (newFeed.comment_count == 0)
        
        let comments = newFeed.comment_count <= 1 ? "\(newFeed.comment_count) comment" : "\(newFeed.comment_count) comments"
        numberOfCommentButtton.titleLabel?.text = comments
        numberOfCommentButtton.setTitle(comments, for: .normal)
        
        let mediaImage = newFeed.newFeedType == .image ? nil : UIImage(named: "btn_play")
        playButton.setImage(mediaImage, for: .normal)
        userAvatarImageView.setImage(with: newFeed.userpic, placeholderImage: .avatar_small)
        userNameLabel.text = newFeed.username
        photoLocationLabel.text = newFeed.title
        dateLabel.text = newFeed.date
        photoDescriptionLabel.text = newFeed.description
        let image = newFeed.user_like ? UIImage(named: "ic_like") : UIImage(named: "ic_unlike")
        likeButton.setImage(image, for: .normal)
        
        if newFeed.user_like {
            if newFeed.like_count > 1 {
                let title = "You and \((newFeed.like_count - 1).toOtherLike)"
                likeContentLabel.text = title
            } else {
                let title = "You liked this"
                likeContentLabel.text = title
            }
        } else {
            if newFeed.like_count > 0 {
                let title = "\(newFeed.like_count) liked this"
                likeContentLabel.text = title
            } else {
                likeContentLabel.text = nil
            }
        }
        
        switch newFeed.newFeedType {
        case .image:
            if UIDevice.current.userInterfaceIdiom == .pad {
                feedImageView.setImage(with: newFeed.pic, placeholderImage: .none)
            } else {
                feedImageView.setImage(with: newFeed.pic, placeholderImage: .photoFeed)
            }
        case .video:
            feedImageView.image = nil
            if let url = URL(string: newFeed.pic) {
                VideoThumbnail.shared.getThumbnailImageFromVideoUrl(url: url) { (image) in
                    DispatchQueue.main.async {
                        if let image = image {
                            self.feedImageView.image = image
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func viewUserProfileAction(_ sender: Any) {
        guard let newFeed = newFeed else { return }
        delegate?.viewUserProfileAction(newFeed)
    }
    

    @IBAction func likeAction(_ sender: Any) {
        guard let newFeed = newFeed else { return }
        delegate?.likeAction(newFeed)
    }
    
    @IBAction func commentAction(_ sender: Any) {
        guard let newFeed = newFeed else { return }
        delegate?.viewComment(newFeed)
    }
    
    @IBAction func viewLikeAction(_ sender: Any) {
        guard let newFeed = newFeed, newFeed.like_count > 0 else { return }
        delegate?.viewLikeAction(newFeed)
    }
    
    @IBAction func playAction(_ sender: Any) {
        guard let newFeed = newFeed else { return }
        switch newFeed.newFeedType {
        case .image:
            delegate?.viewPhoto(newFeed, imageView: self.feedImageView)
        case .video:
            delegate?.playVideo(newFeed)
        }
    }
    
}
