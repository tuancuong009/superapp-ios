//
//  ChatAppTableViewCell.swift
//  SuperApp
//
//  Created by QTS Coder on 25/9/25.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class ChatAppTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblDayAgo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.height/2
        imgAvatar.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configCell(_ dict: NSDictionary){
        self.lblName.text = nil
        lblMessage.text = dict.object(forKey: "message") as? String
        if let user_id = dict.object(forKey: "user_id") as? String{
            fetchUserProfile(uid: user_id) { data in
                if let data = data {
                    self.lblName.text = data["name"] as? String
                    if let avatar =  data["avatar"] as? String{
                        self.imgAvatar.image = FirebaseImageHelper.base64ToImage(avatar)
                    }
                } else {
                    print("❌ No profile found")
                }
            }
        }
        else{
            self.imgAvatar.image = UIImage(named: "noavatar")
        }
        
        if let createdAt = dict.object(forKey: "createdAt") as? Double{
            let date = Date(timeIntervalSince1970: createdAt)
            lblDayAgo.text = DateHelper.timeAgoTwoDate(date)
        }
        else{
            lblDayAgo.text = "Just Now"
        }
    }
    
    func fetchUserProfile(uid: String, completion: @escaping ([String: Any]?) -> Void) {
        let ref = Database.database().reference()
        ref.child(FIREBASE_TABLE.USERS).child(uid).observeSingleEvent(of: .value) { snapshot in
            if let data = snapshot.value as? [String: Any] {
                completion(data)
            } else {
                completion(nil)
            }
        }
    }
}
