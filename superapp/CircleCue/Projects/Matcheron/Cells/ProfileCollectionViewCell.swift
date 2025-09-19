//
//  ProfileCollectionViewCell.swift
//  Matcheron
//
//  Created by QTS Coder on 3/10/24.
//

import UIKit
import SDWebImage
class ProfileCollectionViewCell: UICollectionViewCell {
    var tapMessaged:(()->())?
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var lblNameAge: UILabel!
    @IBOutlet weak var lblProfression: UILabel!
    @IBOutlet weak var lblStateCountry: UILabel!
    @IBOutlet weak var btnMessaged: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgCard.layer.cornerRadius = 16
        imgCard.layer.masksToBounds = true
        // Initialization code
    }

    
    public func configCell(object: NSDictionary){
        var genderStr = ""
        if let createAt = object.object(forKey: "created") as? String, let dateCreate = self.converCreateAt(createAt){
            if (dateCreate.timeIntervalSince1970 + Double(DATETIMESHOWMALE)) > Date().timeIntervalSince1970{
                let gender = object.object(forKey: "gender") as? String ?? ""
                if gender.lowercased() == "female"
                {
                    genderStr = "🦋"
                }
                else{
                    genderStr = "🦅"
                }
            }
        }
        if genderStr.isEmpty{
            self.lblNameAge.text = (object.object(forKey: "fname") as? String ?? "") +  " - " +  (object.object(forKey: "age") as? String ?? "")
        }
        else{
            self.lblNameAge.text = (object.object(forKey: "fname") as? String ?? "") +  " - " +  (object.object(forKey: "age") as? String ?? "") +  " - " + genderStr
        }
       
        self.lblProfression.text =  (object.object(forKey: "profession") as? String ?? "")
        var country = (object.object(forKey: "country") as? String ?? "")
        if country == "United States"{
            country = "U.S"
        }
        self.lblStateCountry.text = (object.object(forKey: "state") as? String ?? "") + ", " + country + "."
        if let img1 = object.object(forKey: "img1") as? String{
            self.imgCard.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.imgCard.sd_setImage(with: URL.init(string: img1)) { image1, errr, type, url in
                
            }
        }
        
    }
    @IBAction func domessage(_ sender: Any) {
        self.tapMessaged?()
    }
    
    
    private func converCreateAt(_ date: String)-> Date?{
        //2024-10-11 01:14:27
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        format.timeZone = TimeZone(abbreviation: "EST")
        return format.date(from: date)
        
    }
}
