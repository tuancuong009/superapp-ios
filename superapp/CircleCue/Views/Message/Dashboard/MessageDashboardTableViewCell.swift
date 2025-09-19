//
//  MessageDashboardTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/10/20.
//

import UIKit

class MessageDashboardTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageContentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var deliveryImageView: UIImageView!
    @IBOutlet weak var icVip: UIImageView!
    
    func setup(message: MessageDashboard) {
        avatarImageView.setImage(with: message.pic, placeholderImage: .avatar_small)
        userNameLabel.text = message.username
        messageContentLabel.text = message.msg
        timeLabel.text = message.time
        deliveryImageView.setDeliveryImage(message.readstatus)
        if message.isbusiness{
            userNameLabel.textColor = UIColor.init(hex: "1eff00")
        }
        else{
            userNameLabel.textColor = UIColor.white
        }
        if message.paid{
            icVip.isHidden = false
        }
        else{
            icVip.isHidden = true
        }
    }
    
    func setupNotification(notification: NotificationObject) {
        deliveryImageView.isHidden = true
        userNameLabel.text = notification.title
        messageContentLabel.text = notification.description
        timeLabel.text = notification.created?.toDateString(.messageDashboard)
    }
}
