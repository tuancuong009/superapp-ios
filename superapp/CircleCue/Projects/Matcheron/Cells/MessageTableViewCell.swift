//
//  MessageTableViewCell.swift
//  Matcheron
//
//  Created by QTS Coder on 2/10/24.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var icRead: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setup(message: MessageDashboard) {
        imgAvatar.setImage(with: message.pic, placeholderImage: .avatar_small)
        lblName.text = message.username
        lblMessage.text = message.msg
        lblTime.text = message.time
        icRead.setDeliveryImage(message.readstatus)
       
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
