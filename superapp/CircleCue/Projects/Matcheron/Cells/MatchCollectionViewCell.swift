//
//  MatchCollectionViewCell.swift
//  MuslimMMM
//
//  Created by QTS Coder on 09/11/2022.
//

import UIKit
import SDWebImage
class MatchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.width/2
        imgAvatar.layer.masksToBounds = true
        // Initialization code
    }

    
    func configCell(_ object: NSDictionary){
        lblName.text = (object.object(forKey: "fname") as? String ?? "") +  " - " +  (object.object(forKey: "age") as? String ?? "")
        var country = (object.object(forKey: "country") as? String ?? "")
        if country == "United States"{
            country = "U.S"
        }
        lblAddress.text = (object.object(forKey: "state") as? String ?? "") + ", " + country + "."
        if let img1 = object.object(forKey: "img1") as? String{
            imgAvatar.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imgAvatar.sd_setImage(with: URL.init(string: img1)) { image1, errr, type, url in
                
            }
        }
    }
}
