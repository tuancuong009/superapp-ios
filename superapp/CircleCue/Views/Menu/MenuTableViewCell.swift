//
//  MenuTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/5/20.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var unreadView: UIView!
    @IBOutlet weak var unreadNumberLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    static let cellHeight: CGFloat = 60
    
    override func awakeFromNib() {
        super.awakeFromNib()
        unreadView.isHidden = true
    }
    
    func setup(menu: MenuItem) {
        menuIcon.image = menu.image
        menuNameLabel.text = menu.rawValue
        switch menu {
        case .dashboard, .feed, .search, .premier_circle_showcase, .album, .personal_service, .business_service, .message, .settings, .benifit:
            separatorView.isHidden = true
        default:
            separatorView.isHidden = false
        }
    }
    
    func updateListRead(_ number: Int) {
        unreadView.isHidden = number == 0
        unreadNumberLabel.text = "\(number)"
    }
}
