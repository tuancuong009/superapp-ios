//
//  SuperCollectionViewCell.swift
//  SuperApp
//
//  Created by QTS Coder on 26/3/25.
//

import UIKit

class SuperCollectionViewCell: UICollectionViewCell {
    var tapOption:(()->())?
    @IBOutlet weak var imgApp: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func doMore(_ sender: Any) {
        self.tapOption?()
    }
}
