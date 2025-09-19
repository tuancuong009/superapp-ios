//
//  ForwardMessageTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/20/20.
//

import UIKit

protocol ForwardMessageDelegate: AnyObject {
    func update(_ user: CircleUser)
}

class ForwardMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var userAvatar: RoundImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var user: CircleUser?
    weak var delegate: ForwardMessageDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        user = nil
    }

    func setup(user: CircleUser) {
        self.user = user
        userAvatar.setImage(with: user.pic, placeholderImage: .avatar_small)
        userNameLabel.text = user.username
        selectButton.setImage(user.isSelected ? #imageLiteral(resourceName: "ic_radio_selected") : #imageLiteral(resourceName: "ic_radio_white"), for: .normal)
    }
    
    @IBAction func selectAction(_ sender: UIButton) {
        guard var user = user else { return }
        user.isSelected.toggle()
        delegate?.update(user)
    }
}
