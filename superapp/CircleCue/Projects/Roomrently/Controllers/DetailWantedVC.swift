//
//  DetailWantedVC.swift
//  Roomrently
//
//  Created by QTS Coder on 05/04/2024.
//

import UIKit

class DetailWantedVC: BaseRRViewController {

    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblZip: UILabel!
    @IBOutlet weak var viewPriceBuy: UIStackView!
    @IBOutlet weak var viewPriceRent: UIStackView!
    @IBOutlet weak var lblPriceRent: UILabel!
    @IBOutlet weak var lblPriceBuy: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblNameHost: UILabel!
    var dict: NSDictionary?
    var idHost = ""
    var pid = ""
    var share_url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }

    @IBAction func doProfile(_ sender: Any) {
        
        if self.isCheckLogin(){
            let vc = SendMessageRRVC.init(nibName: "SendMessageRRVC", bundle: nil)
            vc.profileName = self.lblNameHost.text!
            vc.profileID = self.idHost
            vc.idDetailSearch = true
            vc.messageDefault = pid
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            vc.isLogin = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func doShare(_ sender: Any) {
        let text = share_url
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doMessage(_ sender: Any) {
        if self.isCheckLogin(){
            let vc = SendMessageRRVC.init(nibName: "SendMessageRRVC", bundle: nil)
            vc.profileName =  self.lblNameHost.text!
            vc.profileID = self.idHost
            vc.idDetailSearch = true
            vc.messageDefault = pid
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            vc.isLogin = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func updateUI(){
        if let dict = dict, let property = dict.object(forKey: "property") as? NSDictionary{
            pid = property.object(forKey: "pid") as? String ?? ""
            self.share_url = (property.object(forKey: "url") as? String ?? "")
            lblCountry.text = property.object(forKey: "country") as? String
            lblState.text = property.object(forKey: "state") as? String
            lblCity.text = property.object(forKey: "city") as? String
            lblZip.text = property.object(forKey: "zip") as? String
            if let seeking = property.object(forKey: "seeking") as? String{
                if seeking == "1"{
                    viewPriceBuy.isHidden = false
                    viewPriceRent.isHidden = true
                    lblPriceBuy.text = property.object(forKey: "price_buy") as? String
                }
                else if seeking == "2"{
                    viewPriceBuy.isHidden = true
                    viewPriceRent.isHidden = false
                    lblPriceRent.text = property.object(forKey: "price_rent") as? String
                }
                else{
                    viewPriceBuy.isHidden = false
                    viewPriceRent.isHidden = false
                    lblPriceBuy.text = property.object(forKey: "price_buy") as? String
                    lblPriceRent.text = property.object(forKey: "price_rent") as? String
                }
            }
            lblDesc.text = property.object(forKey: "discription") as? String
            self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.width/2
            self.imgAvatar.layer.masksToBounds = true
            if let host = property.object(forKey: "host") as? NSDictionary{
                self.idHost = host.object(forKey: "id") as? String ?? ""
                let firstName = host.object(forKey: "fname") as? String ?? ""
                let lastName = host.object(forKey: "lname") as? String ?? ""
                self.idHost = host.object(forKey: "id") as? String ?? ""
                if let pic = host.object(forKey: "pic") as? String{
                    self.imgAvatar.sd_setImage(with: URL.init(string: pic))
                    self.imgAvatar.setupImageViewer(
                        urls: [URL.init(string: pic)!],
                        initialIndex: 0,
                        options: [
                            
                        ],
                        from: self)
                }
                if lastName.count > 0{
                    let l = lastName.prefix(1)
                    self.lblNameHost.text = firstName + " " + l
                }
                else{
                    self.lblNameHost.text = firstName
                }
                
            }
        }
    }
    
}
