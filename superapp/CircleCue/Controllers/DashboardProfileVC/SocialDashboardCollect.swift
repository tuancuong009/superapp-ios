//
//  SocialDashboardCollect.swift
//  CircleCue
//
//  Created by QTS Coder on 27/12/24.
//

import UIKit

class SocialDashboardCollect: UICollectionViewCell {

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var iconSocial: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContent.layer.cornerRadius = 10
        viewContent.layer.borderWidth = 1.0
        viewContent.layer.borderColor = UIColor.black.withAlphaComponent(0.15).cgColor
        // Initialization code
    }
    func setup(_ item: HomeSocialItem) {
        iconSocial.image = item.type.image
    }
}
