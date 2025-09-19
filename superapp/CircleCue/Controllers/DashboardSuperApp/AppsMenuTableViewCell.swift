//
//  AppsMenuTableViewCell.swift
//  SuperApp
//
//  Created by QTS Coder on 11/4/25.
//

import UIKit
import SDWebImage
class AppsMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    public func configCell(_ dict: NSDictionary){
        lblName.text = dict.object(forKey: "app_name") as? String
        lblCategory.text = dict.object(forKey: "category") as? String
        imgLogo.layer.cornerRadius = imgLogo.frame.size.height/2
        imgLogo.layer.masksToBounds = true
    
        imgLogo.backgroundColor = .systemGroupedBackground
        if let applogo  = dict.object(forKey: "applogo") as? String{
            imgLogo.setImage(with: applogo)
        }
    }
    
    
}
