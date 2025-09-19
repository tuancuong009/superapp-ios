//
//  CustomLinkCollectionViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 1/4/21.
//

import UIKit

class CustomLinkCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    static let width: CGFloat = (UIScreen.main.bounds.width - 50) / 2
    
    static let cellSize: CGSize = CGSize(width: width, height: 42)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
