//
//  InquiryTableViewCell.swift
//  Roomrently
//
//  Created by QTS Coder on 18/09/2023.
//

import UIKit

class InquiryTableViewCell: UITableViewCell {

    @IBOutlet weak var lblProperty: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
