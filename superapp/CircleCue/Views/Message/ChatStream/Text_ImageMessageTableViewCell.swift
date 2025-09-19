//
//  ImageMessageTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/14/20.
//

import UIKit
import SDWebImage

class Text_ImageMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var friendView: UIView!
    @IBOutlet weak var myView: UIView!
    
    @IBOutlet weak var friendContainerView: UIView!
    @IBOutlet weak var myContainerView: UIView!
    
    @IBOutlet weak var friendMessageImage: UIImageView!
    @IBOutlet weak var myMessageImage: UIImageView!
    
    @IBOutlet weak var friendTextLabel: ChatMessageLabel!
    @IBOutlet weak var myTextLabel: ChatMessageLabel!
    
    @IBOutlet weak var myMessageTimeLabel: UILabel!
    @IBOutlet weak var friendMessageTimeLabel: UILabel!
    
    var message: Message?
    weak var delegate: MessageStreamViewControllerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let myLongPress = UILongPressGestureRecognizer()
        myLongPress.addTarget(self, action: #selector(longTapAction(_:)))
        myLongPress.minimumPressDuration = 0.3
        myContainerView.addGestureRecognizer(myLongPress)
        
        let myTapGesture = UITapGestureRecognizer()
        myTapGesture.addTarget(self, action: #selector(tapAction(_:)))
        myMessageImage.addGestureRecognizer(myTapGesture)
        
        let friendTapGesture = UITapGestureRecognizer()
        friendTapGesture.addTarget(self, action: #selector(tapAction(_:)))
        friendMessageImage.addGestureRecognizer(friendTapGesture)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        message = nil
        friendView.isHidden = true
        myView.isHidden = true
    }
    
    func setup(message: Message) {
        self.message = message
        myMessageTimeLabel.text = message.created_at?.toDateString(.noteDashboard)
        friendMessageTimeLabel.text = message.created_at?.toDateString(.noteDashboard)
        switch message.sender {
        case .me:
            friendView.isHidden = true
            myView.isHidden = false
            myMessageImage.setImage(with: message.mediaUrl, placeholderImage: .photo)
            myTextLabel.text = message.message
        case .friend:
            friendView.isHidden = false
            myView.isHidden = true
            friendMessageImage.setImage(with: message.mediaUrl, placeholderImage: .photo)
            friendTextLabel.text = message.message
        }
    }
    
    @objc func longTapAction(_ sender: UILongPressGestureRecognizer) {
        guard let message = message else { return }
        delegate?.showOption(message)
    }
    
    @objc func tapAction(_ sender: UITapGestureRecognizer) {
        guard let message = message else { return }
        if message.sender == .me {
            delegate?.showImage(message, imageView: myMessageImage)
        } else {
            delegate?.showImage(message, imageView: friendMessageImage)
        }
    }
}
