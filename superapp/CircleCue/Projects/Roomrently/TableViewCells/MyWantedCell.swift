//
//  MyWantedCell.swift
//  Roomrently
//
//  Created by QTS Coder on 05/04/2024.
//

import UIKit

class MyWantedCell: UITableViewCell {

    @IBOutlet weak var lblCoutry: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblPriceBuy: UILabel!
    @IBOutlet weak var lblPriceRent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
