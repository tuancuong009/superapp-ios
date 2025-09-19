//
//  DatingRequestTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 11/27/20.
//

import UIKit

class DatingRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    weak var delegate: MessageStreamViewControllerDelegate?
    
    @IBAction func responseAction(_ sender: UIButton) {
        delegate?.responseDatingRequest(sender.tag)
    }
}
