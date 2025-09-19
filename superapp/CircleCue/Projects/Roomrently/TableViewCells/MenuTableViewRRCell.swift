//
//  MenuTableViewCell.swift
//  Shereef Homes
//
//  Created by QTS Coder on 08/08/2023.
//

import UIKit

class MenuTableViewRRCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNotification: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblNotification.layer.cornerRadius = lblNotification.frame.size.width/2
        lblNotification.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
