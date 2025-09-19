//
//  ShopCollectionViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 25/7/24.
//

import UIKit

class ShopCollectionViewCell: UICollectionViewCell {
    var tapBuyNow: (() ->())?
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var btnInquire: UIButton!
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBadge: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblSold: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func doBuyNow(_ sender: Any) {
        self.tapBuyNow?()
    }
}
