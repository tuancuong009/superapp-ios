//
//  MyProductCell.swift
//  CircleCue
//
//  Created by QTS Coder on 5/8/24.
//

import UIKit

class MyProductCell: UITableViewCell {
    var tapDelete: (() ->())?
    var tapEdit: (() ->())?
    var tapMakeAsSold: (() ->())?
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var btnMakeAsSold: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func doEdit(_ sender: Any) {
        self.tapEdit?()
    }
    @IBAction func doDelete(_ sender: Any) {
        self.tapDelete?()
    }
    @IBAction func doMarkAsSold(_ sender: Any) {
        self.tapMakeAsSold?()
    }
}
