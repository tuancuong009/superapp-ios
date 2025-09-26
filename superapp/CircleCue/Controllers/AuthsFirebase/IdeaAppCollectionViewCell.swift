//
//  IdeaAppCollectionViewCell.swift
//  SuperApp
//
//  Created by QTS Coder on 25/9/25.
//

import UIKit

class IdeaAppCollectionViewCell: UICollectionViewCell {
    var tapOption:(()->())?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        // Initialization code
    }

    @IBAction func doTapDetail(_ sender: Any) {
        tapOption?()
    }
}
