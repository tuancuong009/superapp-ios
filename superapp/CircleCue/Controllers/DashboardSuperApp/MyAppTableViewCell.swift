//
//  MyAppTableViewCell.swift
//  SuperApp
//
//  Created by QTS Coder on 14/5/25.
//

import UIKit

class MyAppTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLink: UILabel!
    @IBOutlet weak var imagePic: UIImageView!
    var tapOption:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func doOptions(_ sender: Any) {
        tapOption?()
    }
    
    public func configCellMyAPp(_ value: NSDictionary){
       if  let dict = value.object(forKey: "business_name") as? NSDictionary{
           lblName.text = dict.object(forKey: "app_name") as? String
           lblLink.text = dict.object(forKey: "app_link") as? String
        }
       
    }
    
    public func configCellFirebase(_ value: NSDictionary){
        lblName.text = value.object(forKey: "name") as? String
        lblLink.text = value.object(forKey: "link") as? String
        if let values = value["screenshots"] as? [String], values.count > 0{
            imagePic.image = FirebaseImageHelper.base64ToImage(values[0])
        }
        imagePic.layer.cornerRadius = 10
        imagePic.layer.borderWidth = 1.0
        imagePic.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
    }
}
