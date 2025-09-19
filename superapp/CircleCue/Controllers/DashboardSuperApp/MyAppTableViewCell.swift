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
}
