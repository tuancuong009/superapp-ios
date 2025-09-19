//
//  WantedCollect.swift
//  Roomrently
//
//  Created by QTS Coder on 05/04/2024.
//

import UIKit

class WantedCollect: UICollectionViewCell {
    @IBOutlet weak var lblType: UILabel!
    var tapDetail: (() ->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        viewLayout.layer.cornerRadius = 10.0
        viewLayout.layer.masksToBounds = true
        viewLayout.layer.borderWidth = 1.0
        viewLayout.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        // Initialization code
    }

    @IBOutlet weak var viewLayout: UIView!
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBAction func doView(_ sender: Any) {
        self.tapDetail?()
    }
    
    func configCell(_ dict: NSDictionary){
        if let property = dict.object(forKey: "property") as? NSDictionary{
            let country = property.object(forKey: "country") as? String ?? ""
            let state = property.object(forKey: "state") as? String ?? ""
            let city = property.object(forKey: "city") as? String ?? ""
            let zip = property.object(forKey: "zip") as? String ?? ""
            lblID.text = property.object(forKey: "pid") as? String
            lblDesc.text = country + ", " + state + ", " + city + ", " + zip
            if let seeking = property.object(forKey: "seeking") as? String{
                if seeking == "1"{
                    lblType.text = "BUY"
                } else if seeking == "2"{
                    lblType.text = "RENT"
                }
                else{
                    lblType.text = "BOTH"
                }
            }
        }
    }
}
