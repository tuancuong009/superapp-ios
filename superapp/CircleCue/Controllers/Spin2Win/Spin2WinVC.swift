//
//  Spin2WinVC.swift
//  CircleCue
//
//  Created by QTS Coder on 17/04/2023.
//

import UIKit

class Spin2WinVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnTitle: UIButton!
    @IBOutlet weak var lblWarning: UILabel!
    @IBOutlet weak var btnWarning: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabelTitle()
        updateLabelWarning()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapWarning(_ sender: Any) {
        btnWarning.isHidden = true
        lblWarning.text = "To ensure fairness, only one user account is allowed per person.\n\nIf you try to participate in the SPIN2WIN program using different email addresses, our software will track you based on your Name, Mobile phone, geolocation, IP address, Cash App ID, PayPal Email ID, and mailing address. We will then ban you permanently. So please don't even try. Let everyone have a fair chance to win and have fun."
    }
    
    @IBAction func didMoreTitle(_ sender: Any) {
        btnTitle.isHidden = true
        lblTitle.text = "This is a FUN game that you can enjoy without any purchase or upgrade. However, please note that winning is not guaranteed. The game's results are random and based on a monthly budget allocated for CircleCue Members.\n\nAnyone located in the USA can download the CircleCue App and play without any obligations. You can spin 365 times within a year, but only one spin is allowed within 24 hours.\n\nIf you happen to win, you will be asked to choose a payment option. You must provide your mobile number, Cash App ID or PayPal email, full name, and mailing address.\nGood luck and have fun!"
    }
    
    private func updateLabelTitle(){
        let strSignup = "This is a FUN game that you can enjoy without any purchase or upgrade. However, please note that winning is not guaranteed. The game's results are random and based on a monthly budget allocated for CircleCue Members...More"
            let rangeSignUp = NSString(string: strSignup).range(of: "More", options: String.CompareOptions.caseInsensitive)
            let rangeFull = NSString(string: strSignup).range(of: strSignup, options: String.CompareOptions.caseInsensitive)
            let attrStr = NSMutableAttributedString.init(string:strSignup)
            attrStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white,
                                   NSAttributedString.Key.font : UIFont.myriadProRegular(ofSize: 17) as Any],range: rangeFull)
            attrStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white,
                                   NSAttributedString.Key.font : UIFont.myriadProBold(ofSize: 17),
                                  NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue as Any],range: rangeSignUp) // for swift 4 -> Change thick to styleThick
            lblTitle.attributedText = attrStr
    }
    
    private func updateLabelWarning(){
        let strSignup = "To ensure fairness, only one user account is allowed per person...More"
            let rangeSignUp = NSString(string: strSignup).range(of: "More", options: String.CompareOptions.caseInsensitive)
            let rangeFull = NSString(string: strSignup).range(of: strSignup, options: String.CompareOptions.caseInsensitive)
            let attrStr = NSMutableAttributedString.init(string:strSignup)
            attrStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white,
                                   NSAttributedString.Key.font : UIFont.myriadProRegular(ofSize: 17) as Any],range: rangeFull)
            attrStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white,
                                   NSAttributedString.Key.font : UIFont.myriadProBold(ofSize: 17),
                                  NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue as Any],range: rangeSignUp) // for swift 4 -> Change thick to styleThick
            lblWarning.attributedText = attrStr
        
    }
    @IBAction func doWarning(_ sender: Any) {
       // let vc = RuleSpin2WinVC.init()
       // self.present(vc, animated: true)
    }
    
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
