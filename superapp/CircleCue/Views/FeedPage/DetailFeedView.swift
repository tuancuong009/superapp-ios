//
//  DetailFeedView.swift
//  CircleCue
//
//  Created by QTS Coder on 5/20/21.
//

import UIKit

open class DetailFeedView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var likeContentLabel: UILabel!
    @IBOutlet private weak var numberOfCommentButtton: UIButton!
    @IBOutlet private weak var photoDescriptionLabel: UILabel!
    @IBOutlet private weak var userAvatarImageView: RoundImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var photoLocationLabel: UILabel!
    @IBOutlet weak var tvText: UITextView!
    @IBOutlet weak var constraintTextView: NSLayoutConstraint!
    
    weak var delegate: BMPlayerControlViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        Bundle.main.loadNibNamed("DetailFeedView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func getTextHeight(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        // Định nghĩa kích thước tối đa mà văn bản có thể chiếm
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        // Tính toán chiều cao của văn bản
        let boundingRect = (text as NSString).boundingRect(
            with: maxSize, // Kích thước giới hạn (chiều rộng và chiều cao lớn nhất)
            options: .usesLineFragmentOrigin, // Đảm bảo tính toán dòng đầy đủ
            attributes: [.font: font], // Đặt font chữ cho văn bản
            context: nil
        )
        
        return boundingRect.height
    }
    
    func updateUI(newFeed: NewFeed) {
        tvText.contentInset = .zero
        
        tvText.text = newFeed.description
        let height = self.getTextHeight(text: newFeed.description, font: tvText.font!, width: UIScreen.main.bounds.size.width - 30)
        if height >  UIScreen.main.bounds.size.height * 0.6{
            constraintTextView.constant = UIScreen.main.bounds.size.height * 0.4
        }
        else{
            print("Height--->",height)
            constraintTextView.constant = height + 50
        }
        
        photoDescriptionLabel.text = ""
        userAvatarImageView.setImage(with: newFeed.userpic, placeholderImage: .avatar_small)
        userNameLabel.text = newFeed.username
        photoLocationLabel.text = newFeed.title
        dateLabel.text = newFeed.date
        self.numberOfCommentButtton.isHidden = (newFeed.comment_count == 0)
        let comments = newFeed.comment_count <= 1 ? "\(newFeed.comment_count) comment" : "\(newFeed.comment_count) comments"
        numberOfCommentButtton.titleLabel?.text = comments
        numberOfCommentButtton.setTitle(comments, for: .normal)
     
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
    }
    
    @IBAction func viewUserProfileAction(_ sender: Any) {
        delegate?.viewUserProfile()
    }
    
    @IBAction func likeAction(_ sender: Any) {
        delegate?.didTapLikeAction()
    }
    
    @IBAction func commentAction(_ sender: Any) {
        delegate?.viewFeedCommentDetail()
        print(#function, self)
    }
    
    @IBAction func viewLikeAction(_ sender: Any) {
        delegate?.viewFeedLikedDetail()
    }
}
