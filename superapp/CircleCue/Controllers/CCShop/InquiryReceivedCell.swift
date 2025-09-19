//
//  InquiryReceivedCell.swift
//  CircleCue
//
//  Created by QTS Coder on 6/8/24.
//

import UIKit

class InquiryReceivedCell: UITableViewCell {
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblShipTo: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblApartment: UILabel!
    @IBOutlet weak var lblBuyerName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
