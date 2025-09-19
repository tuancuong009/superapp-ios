//
//  rentalCollectionViewCell.swift
//  Roomrently
//
//  Created by QTS Coder on 16/08/2023.
//

import UIKit
import SDWebImage

class rentalCollectionViewCell: UICollectionViewCell {
    var tapDetail: (() ->())?
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblHotel: UILabel!
    @IBOutlet weak var btnInquire: UIButton!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var viewContent: UIView!
    let DATETIMESHOW = 24 * 60 * 60
    @IBAction func doDetail(_ sender: Any) {
        self.tapDetail?()
    }
    
    func configCell(_ dict: NSDictionary){
        viewContent.layer.cornerRadius = 10
        viewContent.layer.masksToBounds = true
        imgCell.layer.cornerRadius = 10
        imgCell.layer.masksToBounds = true
        if let property = dict.object(forKey: "property") as? NSDictionary{
            let id = (property.object(forKey: "pid") as? String ?? "")
            var hous = ""
            if let createAt = property.object(forKey: "created") as? String, let dateCreate = self.converCreateAt(createAt){
                if (dateCreate.timeIntervalSince1970 + Double(DATETIMESHOW)) > Date().timeIntervalSince1970{
                    hous = " 🏠"
                }
            }
            lblName.text = id + hous
           
            let rent = property.object(forKey: "rent") as? String ?? ""
            let rtype = property.object(forKey: "rtype") as? String ?? ""
            if let type = property.object(forKey: "type") as? String, type == "Rent"{
                lblPrice.text  = "$" + rent + "/" + rtype
                lblType.text = type.uppercased()
            }
            else{
                
                lblPrice.text  = "$" + rent
                lblType.text = "Buy".uppercased()
            }
           
            let city = property.object(forKey: "city") as? String ?? ""
            let state = property.object(forKey: "state") as? String ?? ""
            lblHotel.text = city + ", " + state
            if let img1 = property.object(forKey: "img1") as? String{
                imgCell.sd_setImage(with: URL.init(string: LINK_URL.URL_PHOTO + img1))
            }
            else  if let img1 = property.object(forKey: "img2") as? String{
                imgCell.sd_setImage(with: URL.init(string: LINK_URL.URL_PHOTO + img1))
            }
            else  if let img1 = property.object(forKey: "img3") as? String{
                imgCell.sd_setImage(with: URL.init(string: LINK_URL.URL_PHOTO + img1))
            }
            else  if let img1 = property.object(forKey: "img4") as? String{
                imgCell.sd_setImage(with: URL.init(string: LINK_URL.URL_PHOTO + img1))
            }
        }
    }
    
    func configCellIquire(_ property: NSDictionary){
        viewContent.layer.cornerRadius = 10
        viewContent.layer.masksToBounds = true
        imgCell.layer.cornerRadius = 10
        imgCell.layer.masksToBounds = true
        let id = (property.object(forKey: "pid") as? String ?? "")
        var hous = ""
        if let createAt = property.object(forKey: "created") as? String, let dateCreate = self.converCreateAt(createAt){
            if (dateCreate.timeIntervalSince1970 + Double(DATETIMESHOW)) > Date().timeIntervalSince1970{
                hous = " 🏠"
            }
        }
        lblName.text = id + hous
       
        let rent = property.object(forKey: "rent") as? String ?? ""
        let rtype = property.object(forKey: "rtype") as? String ?? ""
        if let type = property.object(forKey: "type") as? String, type == "Rent"{
            lblPrice.text  = "$" + rent + "/" + rtype
        }
        else{
            
            lblPrice.text  = "$" + rent
        }
        let city = property.object(forKey: "city") as? String ?? ""
        let state = property.object(forKey: "state") as? String ?? ""
        lblHotel.text = city + ", " + state
        if let img1 = property.object(forKey: "img1") as? String{
            imgCell.sd_setImage(with: URL.init(string: LINK_URL.URL_PHOTO + img1))
        }
        else  if let img1 = property.object(forKey: "img2") as? String{
            imgCell.sd_setImage(with: URL.init(string: LINK_URL.URL_PHOTO + img1))
        }
        else  if let img1 = property.object(forKey: "img3") as? String{
            imgCell.sd_setImage(with: URL.init(string: LINK_URL.URL_PHOTO + img1))
        }
        else  if let img1 = property.object(forKey: "img4") as? String{
            imgCell.sd_setImage(with: URL.init(string: LINK_URL.URL_PHOTO + img1))
        }
    }
    
    func df2so(_ price: Double) -> String{
       let numberFormatter = NumberFormatter()
       numberFormatter.groupingSeparator = ","
       numberFormatter.groupingSize = 3
       numberFormatter.usesGroupingSeparator = true
       numberFormatter.decimalSeparator = "."
       numberFormatter.numberStyle = .decimal
       numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: price as NSNumber)! 
   }
    
    
    private func converCreateAt(_ date: String)-> Date?{
        //2024-10-11 01:14:27
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        format.timeZone = TimeZone(abbreviation: "EST")
        return format.date(from: date)
        
    }
}
