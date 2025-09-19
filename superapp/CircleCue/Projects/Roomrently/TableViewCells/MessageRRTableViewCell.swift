//
//  MessageTableViewCell.swift
//  MuslimMMM
//
//  Created by QTS Coder on 30/11/2022.
//

import UIKit
import SDWebImage
class MessageRRTableViewCell: UITableViewCell {
    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var icRead: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(_ dict: NSDictionary){
        imgAvatar.layer.borderWidth = 1.0
        imgAvatar.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.lblFrom.text = dict.object(forKey: "username") as? String
        self.lblMessage.text = dict.object(forKey: "msg") as? String
        self.lblDate.text =  self.formatTimeAgo((dict.object(forKey: "time") as? String ?? ""))
        lblMessage.numberOfLines = 0
        if let pic = dict.object(forKey: "pic") as? String{
            if let url = URL.init(string: pic){
                self.imgAvatar.sd_setImage(with: url) { image, error, type, url in
                    
                }
            }
        }
        if let readstatus = dict.object(forKey: "readstatus") as? String, let intread = Int(readstatus), intread == 0{
            icRead.isHidden = false
        }
        else{
            icRead.isHidden = true
        }
    }
    
    private func formatTimeAgo(_ strDate: String)-> String{
        
        let format = DateFormatter.init()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        format.timeZone = TimeZone(abbreviation: "EST")
        //format.locale = self.getPreferredLocale()
        if let dateS = format.date(from: strDate){
            print(dateS)
            return DateHelper.timeAgoTwoDate(dateS)
        }
        return ""
    }
    
}
