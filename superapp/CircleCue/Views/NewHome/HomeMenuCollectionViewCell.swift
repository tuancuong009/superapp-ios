//
//  HomeMenuCollectionViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 29/10/2021.
//

import UIKit

class HomeMenuCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var menuIconImageView: UIImageView!
    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var unreadCountView: UIView!
    @IBOutlet weak var unreadCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup(menu: MenuItem, unreadMessage: Int, unreadNotification: Int) {
        unreadCountView.isHidden = true
        menuNameLabel.text = menu.rawValue
        menuIconImageView.image = menu.image
        switch menu {
        case .message:
            unreadCountView.isHidden = unreadMessage == 0
            unreadCountLabel.text = unreadMessage.string
        case .notification:
            unreadCountView.isHidden = unreadNotification == 0
            unreadCountLabel.text = unreadNotification.string
        default:
            unreadCountView.isHidden = true
        }
    }
}
