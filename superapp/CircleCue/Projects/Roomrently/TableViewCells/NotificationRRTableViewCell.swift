//
//  NotificationTableViewCell.swift
//  Roomrently
//
//  Created by QTS Coder on 04/01/2024.
//

import UIKit

class NotificationRRTableViewCell: UITableViewCell {
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var icRead: UILabel!
    @IBOutlet weak var spaceRight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configCell(_ dict: NSDictionary){
        icRead.layer.cornerRadius = icRead.frame.size.width/2
        icRead.layer.masksToBounds = true
        self.lblContent.text = dict.object(forKey: "description") as? String
        self.lblDesc.text =  self.formatTimeAgo((dict.object(forKey: "created") as? String ?? ""))
        if let seen = dict.object(forKey: "seen") as? String, let intseen = Int(seen), intseen == 0{
            icRead.isHidden = false
            self.lblContent.font = UIFont(name: "Poppins-Medium", size: 14)
            spaceRight.constant = 40
        }
        else{
            icRead.isHidden = true
            self.lblContent.font = UIFont(name: "Poppins-Regular", size: 14)
            spaceRight.constant = 20
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
