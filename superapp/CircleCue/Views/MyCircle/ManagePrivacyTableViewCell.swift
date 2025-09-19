//
//  ManagePrivacyTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/20/20.
//

import UIKit

protocol ManagePrivacyDelegate: AnyObject {
    func updateStatus(_ item: PrivacyItem?)
}

class ManagePrivacyTableViewCell: UITableViewCell {

    @IBOutlet weak var socialIcon: RoundImageView!
    @IBOutlet weak var socialNameLabel: UILabel!
    @IBOutlet weak var hideButton: UIButton!
    
    weak var delegate: ManagePrivacyDelegate?
    var privacyItem: PrivacyItem?
    
    func setup(privacyItem: PrivacyItem) {
        self.privacyItem = privacyItem
        socialNameLabel.text = privacyItem.type.title
        hideButton.setHomePrivateStatus(privacyItem.isPrivate)
        socialIcon.image = privacyItem.type.icon
    }
    
    @IBAction func hideAction(_ sender: Any) {
        privacyItem?.isPrivate.toggle()
        hideButton.setHomePrivateStatus(privacyItem?.isPrivate ?? false)
        delegate?.updateStatus(privacyItem)
    }
}
