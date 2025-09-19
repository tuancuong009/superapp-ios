//
//  HomeSocialTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/5/20.
//

import UIKit

class HomeSocialTableViewCell: UITableViewCell {

    @IBOutlet weak var socialIcon: UIImageView!
    @IBOutlet weak var socialLinkLabel: UILabel!
    @IBOutlet weak var privateButton: UIButton!
    @IBOutlet weak var numberClickLabel: UILabel!
    
    static let cellHeight: CGFloat = 70.0
    var homeItem: HomeSocialItem?
    
    func setup(item: HomeSocialItem) {
        homeItem = item
        socialIcon.image = item.type.image
        if let userName = item.link, !userName.isEmpty {
            if let domain = item.type.domain {
                if userName.isValidSocialLink(host: domain) {
                    socialLinkLabel.text = userName
                } else {
                    socialLinkLabel.text = domain + userName
                }
            } else {
                socialLinkLabel.text = userName
            }
        } else {
            socialLinkLabel.text = nil
        }
        
        numberClickLabel.text = "Click: \(item.numberOfClick)"
        privateButton.setHomePrivateStatus(item.isPrivate)
    }
    
    @IBAction func privateAction(_ sender: UIButton) {
//        homeItem?.isPrivate.toggle()
//        privateButton.setHomePrivateStatus(homeItem?.isPrivate ?? false)
    }
}
