//
//  NotificationTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 14/06/2021.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var descitpionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var unseenView: UIView!
    
    func setup(_ notification: NotificationObject) {
        descitpionLabel.text = notification.description
        dateLabel.text = notification.created?.toDateString(.messageDashboard)
        descitpionLabel.font = notification.seen ? UIFont.myriadProRegular(ofSize: 17) : UIFont.myriadProBold(ofSize: 17)
        unseenView.isHidden = notification.seen
    }
}
