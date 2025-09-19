//
//  CircularMessageTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/14/20.
//

import UIKit

class CircularMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var myMessageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var message: Message?
    weak var delegate: MessageStreamViewControllerDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        message = nil
    }
    
    func setupCircularChat(message: CircularMessage) {
        myMessageLabel.text = message.msg
        dateLabel.text = message.created?.toDateString(.noteDashboard)
    }
}
