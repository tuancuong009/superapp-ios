//
//  SearchTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/10/20.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTitleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var viewVip: UIView!
    
    func setup(_ user: UniversalUser) {
        userImageView.setImage(with: user.pic ?? "")
        userNameLabel.text = user.username
        userTitleLabel.text = user.title
        locationLabel.text = user.location
        userTitleLabel.isHidden = (user.title == nil || user.title?.isEmpty == true)
        locationLabel.isHidden = (user.location == nil || user.location?.isEmpty == true)
        if user.premium{
            viewVip.isHidden = false
        }
        else{
            viewVip.isHidden = true
        }
    }
    
    func setupInnerCircleUser(_ user: CircleUser) {
        userImageView.setImage(with: user.pic)
        userNameLabel.text = user.username
        userTitleLabel.text = user.title
        locationLabel.text = user.country
        userTitleLabel.isHidden = user.title.isEmpty
        locationLabel.isHidden = user.country.isEmpty
    }
    
    func setupFollowingUser(user: FollowingUser) {
        userImageView.setImage(with: user.pic)
        userNameLabel.text = user.username
        userTitleLabel.isHidden = true
        locationLabel.isHidden = true
    }
}
