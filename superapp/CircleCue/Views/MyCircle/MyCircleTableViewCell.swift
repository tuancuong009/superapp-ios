//
//  MyCircleTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/10/20.
//

import UIKit

protocol MyCircleDelegate: AnyObject {
    func myCircleCellAction(_ action: MyCircleAction, circleUser: CircleUser)
}

class MyCircleTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTitleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var innerView: UIStackView!
    @IBOutlet weak var sentPendingView: UIStackView!
    @IBOutlet weak var icVip: UIImageView!
    @IBOutlet weak var receivedPendingView: UIStackView!
    
    weak var delegate: MyCircleDelegate?
    var user: CircleUser?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        innerView.isHidden = true
        sentPendingView.isHidden = true
        receivedPendingView.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        user = nil
    }
    
    func setup(user: CircleUser) {
        self.user = user
        avatarImageView.setImage(with: user.pic, placeholderImage: .avatar)
        userNameLabel.text = user.username
        userTitleLabel.text = user.title
        locationLabel.text = user.country
        
        innerView.isHidden = user.status != .inner
        sentPendingView.isHidden = user.status != .sentPending
        receivedPendingView.isHidden = user.status != .receivedPending
        icVip.isHidden = !user.premium
        
    }
    
    @IBAction func cellAction(_ sender: UIButton) {
        guard let action = MyCircleAction(rawValue: sender.tag), let user = user, !user.idd.isEmpty else { return }
        delegate?.myCircleCellAction(action, circleUser: user)
    }
}
