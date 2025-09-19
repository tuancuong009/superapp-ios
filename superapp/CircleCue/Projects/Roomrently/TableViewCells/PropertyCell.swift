//
//  PropertyCell.swift
//  Roomrently
//
//  Created by QTS Coder on 18/09/2023.
//

import UIKit
import SDWebImage
class PropertyCell: UITableViewCell {
    var tapOption: (() ->())?
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblID: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func doOption(_ sender: Any) {
        self.tapOption?()
    }
    
    func updateCell(_ dict: NSDictionary){
        imgCell.layer.cornerRadius = 5
        imgCell.layer.masksToBounds = true
        if let property =  dict.object(forKey: "property") as? NSDictionary{
            let state = property.object(forKey: "state") as? String ?? ""
            let city = property.object(forKey: "city") as? String ?? ""
            lblName.text = city + ", " + state
            if let img1 = property.object(forKey: "img1") as? String{
                imgCell.sd_setImage(with: URL.init(string: LINK_URL.URL_PHOTO + img1))
            }
            lblType.text = property.object(forKey: "type") as? String
            lblID.text = (property.object(forKey: "pid") as? String ?? "")
        }
       
    }
}
