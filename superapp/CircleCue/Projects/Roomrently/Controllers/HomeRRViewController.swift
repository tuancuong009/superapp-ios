//
//  HomeViewController.swift
//  Roomrently
//
//  Created by QTS Coder on 16/08/2023.
//

import UIKit
import SafariServices
class HomeRRViewController: BaseRRViewController {
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var viewNoLogin: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnRent: UIButton!
    @IBOutlet weak var btnBuy: UIButton!
    @IBOutlet weak var btnWanted: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var lblNoFee: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if isCheckLogin(){
            btnProfile.setTitle("My Profile", for: .normal)
            btnRegister.setTitle("List", for: .normal)
            img1.image = UIImage.init(named: "slice1_login")
            img2.image = UIImage.init(named: "slice2_login")
           //btnSearch.setBackgroundImage(UIImage.init(named: "btn_all"), for: .normal)
            imgHome.image = UIImage.init(named: "bg1")
            lblNoFee.isHidden = true
        }
        else{
            btnProfile.setTitle("Free Signup", for: .normal)
            btnRegister.setTitle("Login", for: .normal)
            imgHome.image = UIImage.init(named: "bg2")
            img1.image = UIImage.init(named: "slice1")
            img2.image = UIImage.init(named: "slice2")
            lblNoFee.isHidden = false
        }
        img1.layer.cornerRadius = 10
        img1.layer.masksToBounds = true
        img2.layer.cornerRadius = 10
        img2.layer.masksToBounds = true
        btnBuy.underline()
        btnRent.underline()
        btnSearch.underline()
        btnWanted.underline()
        showAlertNewRegister()
        APP_DELEGATE.updateToken()
    }
  
    func showAlertNewRegister(){
        if APP_DELEGATE.isRegisterNew{
            APP_DELEGATE.isRegisterNew = false
            let alert = UIAlertController(title: "Your registration is complete",
                                          message: "Please check your email, including the spam folder, for login information. If you have any issues, please reply to service@roomrently.com or leave a message at 1-833-RRENTLY (1-833-773-6859).",
                                          preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "Ok",
                                             style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func doProfile(_ sender: Any) {
        if isCheckLogin(){
            let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    @IBAction func doList(_ sender: Any) {
        if !isCheckLogin(){
            let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            vc.isLogin = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    
    private func openLink(_ link: String){
        let vc = SFSafariViewController.init(url: URL.init(string: link)!)
        self.present(vc, animated: true)
    }
    @IBAction func doRentta(_ sender: Any) {
        let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "SearchRRViewController") as! SearchRRViewController
        vc.isHome = true
        vc.selectType = "Rent"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func doSelling(_ sender: Any) {
        let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "SearchRRViewController") as! SearchRRViewController
        vc.isHome = true
        vc.selectType = "Sell"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doRegister(_ sender: Any) {
        let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doLogin(_ sender: Any) {
        let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.isLogin = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doSearch(_ sender: Any) {
        let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "SearchRRViewController") as! SearchRRViewController
        vc.isHome = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func doWanted(_ sender: Any) {
        let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "WantedVC") as! WantedVC
        vc.isHome = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func doCC(_ sender: Any) {
        self.openLink(LINK_URL.URL_CC)
    }
    @IBAction func doIS(_ sender: Any) {
        self.openLink(LINK_URL.URL_IS)
    }
}
extension UILabel {
    func underline() {
        if let textString = self.text {
          let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
          attributedText = attributedString
        }
    }
}
extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        //NSAttributedStringKey.foregroundColor : UIColor.blue
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
