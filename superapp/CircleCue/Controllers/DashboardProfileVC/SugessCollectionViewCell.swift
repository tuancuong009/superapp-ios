//
//  SugessCollectionViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/1/25.
//

import UIKit

class SugessCollectionViewCell: UICollectionViewCell {
    var tapRemove: (() ->())?
    var tapAdd: (() ->())?
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(_ radomUser: RadomUser){
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.height/2
        imgAvatar.layer.masksToBounds = true
        imgAvatar.layer.borderWidth = 1.0
        imgAvatar.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        lblName.text = radomUser.username
        imgAvatar.setImage(with: radomUser.pic)
        btnAdd.setTitle(radomUser.isRequest ? "Sent" : "Add", for: .normal)
        btnAdd.isEnabled = radomUser.isRequest ? false : true
    }

    @IBAction func doRemove(_ sender: Any) {
        self.tapRemove?()
    }
    @IBAction func doAdd(_ sender: Any) {
        self.tapAdd?()
    }
}
