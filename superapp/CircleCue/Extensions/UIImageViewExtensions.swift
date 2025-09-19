//
//  UIImageViewExtensions.swift
//  CircleCue
//
//  Created by QTS Coder on 10/12/20.
//

import UIKit
import SDWebImage

enum PlaceHolderImage {
    case avatar
    case avatar_small
    case photoFeed
    case photo
    case video
    case none
    
    var image: UIImage? {
        switch self {
        case .avatar:
            return #imageLiteral(resourceName: "avatar")
        case .avatar_small:
            return #imageLiteral(resourceName: "avatar_small")
        case .photo:
            return #imageLiteral(resourceName: "placeholder_image")
        case .video:
            return UIImage(named: "bg_video")
        case .photoFeed:
            return UIImage(named: "feed_image_placeholder")
        default:
            return nil
        }
    }
}

extension UIImageView {
    
    func setupUserAvatar() {
        self.setImage(with: (AppSettings.shared.currentUser?.pic ?? (AppSettings.shared.userLogin?.pic ?? AppSettings.shared.userLogin?.pic2)) ?? "", placeholderImage: .avatar)
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.5
        self.contentMode = .scaleAspectFill
    }
    
    func setImage(with urlString: String, placeholderImage: PlaceHolderImage = .avatar) {
        self.contentMode = .scaleAspectFill
        self.sd_imageTransition = .fade
        self.animationDuration = 0.15
//        if urlString.lowercased().hasSuffix("pdf") {
//            self.image = placeholderImage.image
//            return
//        }
        self.sd_setImage(with: URL.init(string: urlString), placeholderImage: placeholderImage.image, options: [.continueInBackground, .retryFailed, .refreshCached], context: nil)
    }
    
    func setDeliveryImage(_ status: ReadMessageStatus) {
        switch status {
        case .read:
            self.image = #imageLiteral(resourceName: "ic_received")
        case .sent:
            self.image = #imageLiteral(resourceName: "ic_sent")
        default:
            self.image = #imageLiteral(resourceName: "ic_received")
        }
    }
}
