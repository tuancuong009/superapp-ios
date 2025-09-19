//
//  ProfileUserViewController.swift
//  Matcheron
//
//  Created by QTS Coder on 2/10/24.
//

import UIKit
import SDWebImage
import ImageViewer_swift
class ProfileUserViewController: AllViewController {
    var tapSuccess: (() ->())?
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var scrollPage: UIScrollView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRegiron: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblMatcheron: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblProfession: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var btnBlock: UIButton!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var viewContryOfOrigin: UIView!
    @IBOutlet weak var lblCountryOfOrigin: UILabel!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var lblPhone: UILabel!
    var dictUser: NSDictionary?
    var profileID = ""
    var profileName = ""
    var isBlock = false
    var idBlock = ""
    var arrAvatars = [String]()
    var profileUrl = ""
    var isMenuLike = false
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        getProfileUrl()
        getListBlock()
        // Do any additional setup after loading the view.
    }
    
    private func getProfileUrl(){
        APIHelper.shared.myprofile(id: self.profileID) { success, dict in
            if let result = dict{
                self.profileUrl = result.object(forKey: "profileur") as? String ?? ""
                print("self.profileUrl---->",self.profileUrl)
            }
        }
    }

    private func getListBlock(){
        let userID = UserDefaults.standard.value(forKey: USER_ID) as? String ?? ""
        APIHelper.shared.getListBlock(userID) { success, dict in
            if let dict = dict {
                for item in dict{
                   
                    if let blocked = item.object(forKey: "blocked") as? String, blocked == self.profileID{
                        self.isBlock = true
                        print("self.isBlock--->",self.isBlock)
                        if let id = item.object(forKey: "id") as? String{
                            self.idBlock = "\(id)"
                            print("UID BLOCK--->",self.idBlock)
                        }
                        break
                    }
                    
                }
            }
            if self.isBlock{
                self.btnBlock.setTitle("Unblock", for: .normal)
            }
            else{
                self.btnBlock.setTitle("Block", for: .normal)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doViewAvatar(_ sender: Any) {
        var imageURLs: [URL] = []
        for arrAvatar in arrAvatars {
            imageURLs.append(URL.init(string: arrAvatar)!)
        }
        let vc = ImageViewerController.init(imageURLs: imageURLs)
        vc.delegate = self
        self.present(vc, animated: true)
    }
    @IBAction func doBlock(_ sender: Any) {
      
        if !self.isBlock{
            self.showAlertMessageAction("Are you sure you want to block this user?") { success in
                if success{
                    let userID = UserDefaults.standard.value(forKey: USER_ID) as? String ?? ""
                    let param = ["blockby": userID, "blocked": self.profileID]
                    self.isBlock = true
                    self.btnBlock.setTitle("Unblock", for: .normal)
                    
                    APIHelper.shared.addBlock(param) { success, erro in
                        self.getListBlock()
                    }
                }
            }
           
        }
        else{
            self.showAlertMessageAction("Are you sure you want to unblock this user?") { success in
                if success{
                    self.isBlock = false
                    self.btnBlock.setTitle("Block", for: .normal)
                    APIHelper.shared.removeBlock(self.idBlock) { success, erro in
                        
                    }
                }
            }
           
        }
    }
    @IBAction func doOption(_ sender: Any) {
        let alert = UIAlertController(title: APP_NAME,
                                      message: nil,
                                      preferredStyle: UIAlertController.Style.actionSheet)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { action in
         
        }
        
        alert.addAction(cancelAction)
        if isMenuLike{
            let moveMayBe = UIAlertAction.init(title: "Move to Maybe", style: .default) { action in
                let userID = UserDefaults.standard.value(forKey: USER_ID) as? String ?? ""
                self.showBusy()
                APIHelper.shared.addMaybe(id: userID, id2: self.profileID) { success, erro in
                        self.hideBusy()
                        if success!{
                            self.tapSuccess?()
                            self.navigationController?.popViewController(animated: true)
                        }
                        else{
                            self.showAlertMessage(message: erro ?? "")
                        }
                    }
            }
            
            alert.addAction(moveMayBe)
            
            let moveDelte = UIAlertAction.init(title: "Move to No/Delete", style: .default) { action in
                let userID = UserDefaults.standard.value(forKey: USER_ID) as? String ?? ""
                self.showBusy()
                APIHelper.shared.rejectNo(id: userID, id2: self.profileID) { success, erro in
                    self.hideBusy()
                    if success!{
                        self.tapSuccess?()
                        self.navigationController?.popViewController(animated: true)
                    }
                    else{
                        self.showAlertMessage(message: erro ?? "")
                    }
                }
            }
            
            alert.addAction(moveDelte)
        }
        let yesAction = UIAlertAction.init(title: "Copy Profile Url", style: .default) { action in
            var url = self.profileUrl
            if url.isEmpty{
                url = "https://matcheron.com/SA000\(self.profileID)"
                print("NOOOOOO")
            }
            UIPasteboard.general.string = url
            self.showAlertMessage(message: "Profile URL copied!")
        }
        
        alert.addAction(yesAction)
        let report = UIAlertAction.init(title: "Report", style: .default) { action in
            let vc = ReportViewController.init()
            self.present(vc, animated: true)
        }
        
        alert.addAction(report)
        
       
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doPhone(_ sender: Any) {
        if let dictUser = dictUser, let phone = dictUser.object(forKey: "phone") as? String{
            if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func doSendMessage(_ sender: Any) {
        let vc = SendMessageViewController()
        vc.profileID = self.profileID
        vc.profileName = self.profileName
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    private func updateUI(){
        arrAvatars.removeAll()
        pageControl.isHidden = true
        if let dict = dictUser{
            self.profileID = dict.object(forKey: "id") as? String ?? ""
            self.profileName = dict.object(forKey: "fname") as? String ?? ""
            var genderStr = ""
            if let createAt = dict.object(forKey: "created") as? String, let dateCreate = self.converCreateAt(createAt){
                if (dateCreate.timeIntervalSince1970 + Double(DATETIMESHOWMALE)) > Date().timeIntervalSince1970{
                    let gender = dict.object(forKey: "gender") as? String ?? ""
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
                lblName.text = (dict.object(forKey: "fname") as? String ?? "") +  " - " + (dict.object(forKey: "age") as? String ?? "")
            }
            else{
                lblName.text = (dict.object(forKey: "fname") as? String ?? "") +  " - " + (dict.object(forKey: "age") as? String ?? "")  +  " - " + genderStr
            }
           
            self.convertAtributteLableName(label: self.lblName, textColor: (dict.object(forKey: "fname") as? String ?? "") + " - ")
            self.lblRegiron.text = (dict.object(forKey: "religion") as? String ?? "") + ": " + (dict.object(forKey: "pairing") as? String ?? "")
            self.convertAtributteLable(label: self.lblRegiron, textColor: (dict.object(forKey: "religion") as? String ?? "") + ": ")
            
            self.lblStatus.text =  (dict.object(forKey: "status") as? String ?? "") + "/" + (dict.object(forKey: "gender") as? String ?? "") + ":" + " Seeking " + (dict.object(forKey: "seeking") as? String ?? "")
            self.convertAtributteLable(label: self.lblStatus, textColor: ((dict.object(forKey: "status") as? String ?? "") + "/" + (dict.object(forKey: "gender") as? String ?? "") + ":"))
            
            self.lblMatcheron.text = "Matcheron: " + (dict.object(forKey: "goal") as? String ?? "")
            self.convertAtributteLable(label: self.lblMatcheron, textColor: "Matcheron: ")
            
            self.lblHeight.text =  "Height: " + (dict.object(forKey: "height") as? String ?? "")
            self.lblWeight.text = "Weight: " + (dict.object(forKey: "weight") as? String ?? "") + " lbs"
            self.convertAtributteLable(label: self.lblHeight, textColor: "Height: ")
            self.convertAtributteLable(label: self.lblWeight, textColor: "Weight: ")
           // self.lblWeight.text = (dict.object(forKey: "weight") as? String ?? "") + "lbs"
            let countryOfOrigin = dict.object(forKey: "origin_country") as? String ?? ""
            if countryOfOrigin.isEmpty{
                self.viewContryOfOrigin.isHidden = true
            }
            else{
                self.viewContryOfOrigin.isHidden = false
                self.lblCountryOfOrigin.text = "Country of Origin: " + countryOfOrigin
                self.convertAtributteLable(label: self.lblCountryOfOrigin, textColor: "Country of Origin: ")
            }
            var country = (dict.object(forKey: "country") as? String ?? "")
            if country == "United States"{
                country = "U.S"
            }
            self.lblCountry.text =   "Current Country: " + (country.isEmpty ? "U.S" : country) + ", " + (dict.object(forKey: "state") as? String ?? "") + " "
            self.convertAtributteLable(label: lblCountry, textColor: "Current Country: ")
            self.lblProfession.text =  "Profession: " + (dict.object(forKey: "profession") as? String ?? "")
            self.convertAtributteLable(label: self.lblProfession, textColor: "Profession: ")
            self.lblComment.text = dict.object(forKey: "bio") as? String
            self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.height/2
            self.imgAvatar.layer.masksToBounds = true
            if let img1 = dict.object(forKey: "img1") as? String, !img1.isEmpty{
                self.imgAvatar.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.imgAvatar.sd_setImage(with: URL.init(string: img1)) { image1, errr, type, url in
                    
                }
                self.arrAvatars.append(img1)
            }
            if let img2 = dict.object(forKey: "img2") as? String, !img2.isEmpty{
                self.arrAvatars.append(img2)
            }
            
            if let img3 = dict.object(forKey: "img3") as? String, !img3.isEmpty{
                self.arrAvatars.append(img3)
            }
            if self.arrAvatars.count > 1{
                pageControl.isHidden = false
                pageControl.numberOfPages = self.arrAvatars.count
            }
            else{
                pageControl.isHidden = true
            }
            var phoneVisible = true
            if let phoneStatus =  dict.object(forKey: "phonestatus") as? String{
                phoneVisible = phoneStatus == "1" ? true : false
            }
            else if let phoneStatus =  dict.object(forKey: "phonestatus") as? Int{
                phoneVisible = phoneStatus == 1 ? true : false
            }
            viewPhone.isHidden = phoneVisible ? false : true
            self.lblPhone.text = "Phone: " + (dict.object(forKey: "phone") as? String ?? "")
            self.convertAtributteLable(label: self.lblPhone, textColor: "Phone: ")
        }
        else{
            self.showBusy()
            self.scrollPage.isHidden = true
            APIHelper.shared.myprofile(id: self.profileID) { success, dict in
                self.hideBusy()
                self.scrollPage.isHidden = false
                self.dictUser = dict
                if let dict = self.dictUser{
                    self.profileID = dict.object(forKey: "id") as? String ?? ""
                    self.profileName = dict.object(forKey: "fname") as? String ?? ""
                    var genderStr = ""
                    if let createAt = dict.object(forKey: "created") as? String, let dateCreate = self.converCreateAt(createAt){
                        if (dateCreate.timeIntervalSince1970 + Double(DATETIMESHOWMALE)) > Date().timeIntervalSince1970{
                            let gender = dict.object(forKey: "gender") as? String ?? ""
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
                        self.lblName.text = (dict.object(forKey: "fname") as? String ?? "") +  " - " + (dict.object(forKey: "age") as? String ?? "")
                    }
                    else{
                        self.lblName.text = (dict.object(forKey: "fname") as? String ?? "") +  " - " + (dict.object(forKey: "age") as? String ?? "")  +  " - " + genderStr
                    }
                    
                   
                    self.convertAtributteLableName(label: self.lblName, textColor: (dict.object(forKey: "fname") as? String ?? "") + " - ")
                    self.lblRegiron.text = (dict.object(forKey: "religion") as? String ?? "") + ": " + (dict.object(forKey: "pairing") as? String ?? "")
                    self.convertAtributteLable(label: self.lblRegiron, textColor: (dict.object(forKey: "religion") as? String ?? "") + ": ")
                    
                    self.lblStatus.text =  (dict.object(forKey: "status") as? String ?? "") + "/" + (dict.object(forKey: "gender") as? String ?? "") + ":" + " Seeking " + (dict.object(forKey: "seeking") as? String ?? "")
                    self.convertAtributteLable(label: self.lblStatus, textColor: ((dict.object(forKey: "status") as? String ?? "") + "/" + (dict.object(forKey: "gender") as? String ?? "") + ":"))
                    
                    self.lblMatcheron.text = "Matcheron: " + (dict.object(forKey: "goal") as? String ?? "")
                    self.convertAtributteLable(label: self.lblMatcheron, textColor: "Matcheron: ")
                    
                    self.lblHeight.text =  "Height: " + (dict.object(forKey: "height") as? String ?? "")
                    self.lblWeight.text = "Weight: " + (dict.object(forKey: "weight") as? String ?? "") + " lbs"
                    self.convertAtributteLable(label: self.lblHeight, textColor: "Height: ")
                    self.convertAtributteLable(label: self.lblWeight, textColor: "Weight: ")
                    let countryOfOrigin = dict.object(forKey: "origin_country") as? String ?? ""
                    if countryOfOrigin.isEmpty{
                        self.viewContryOfOrigin.isHidden = true
                    }
                    else{
                        self.viewContryOfOrigin.isHidden = false
                        self.lblCountryOfOrigin.text = "Country of Origin: " + countryOfOrigin
                        self.convertAtributteLable(label: self.lblCountryOfOrigin, textColor: "Country of Origin: ")
                    }
                    var country = (dict.object(forKey: "country") as? String ?? "")
                    if country == "United States"{
                        country = "U.S"
                    }
                    self.lblCountry.text =   "Current Country: " + (country.isEmpty ? "U.S" : country) + ", " + (dict.object(forKey: "state") as? String ?? "") + " "
                    self.convertAtributteLable(label: self.lblCountry, textColor: "Current Country: ")
                    self.lblProfession.text =  "Profession: " + (dict.object(forKey: "profession") as? String ?? "")
                    self.convertAtributteLable(label: self.lblProfession, textColor: "Profession: ")
                    self.lblComment.text = dict.object(forKey: "bio") as? String
                    self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.height/2
                    self.imgAvatar.layer.masksToBounds = true
                    if let img1 = dict.object(forKey: "img1") as? String, !img1.isEmpty{
                        self.imgAvatar.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        self.imgAvatar.sd_setImage(with: URL.init(string: img1)) { image1, errr, type, url in
                            
                        }
                        self.arrAvatars.append(img1)
                    }
                    if let img2 = dict.object(forKey: "img2") as? String, !img2.isEmpty{
                        self.arrAvatars.append(img2)
                    }
                    
                    if let img3 = dict.object(forKey: "img3") as? String, !img3.isEmpty{
                        self.arrAvatars.append(img3)
                    }
                    
                    if self.arrAvatars.count > 1{
                        self.pageControl.isHidden = false
                        self.pageControl.numberOfPages = self.arrAvatars.count
                    }
                    else{
                        self.pageControl.isHidden = true
                    }
                    
                    var phoneVisible = true
                    if let phoneStatus =  dict.object(forKey: "phonestatus") as? String{
                        phoneVisible = phoneStatus == "1" ? true : false
                    }
                    else if let phoneStatus =  dict.object(forKey: "phonestatus") as? Int{
                        phoneVisible = phoneStatus == 1 ? true : false
                    }
                    self.viewPhone.isHidden = phoneVisible ? false : true
                    self.lblPhone.text = "Phone: " + (dict.object(forKey: "phone") as? String ?? "")
                    self.convertAtributteLable(label: self.lblPhone, textColor: "Phone: ")
                }
                
                
            }
        }
    }
    
    func convertAtributteLableName(label: UILabel, textColor: String){
        let attrStri = NSMutableAttributedString.init(string: label.text!)
        let nsRange = NSString(string: label.text!)
                .range(of: "\(textColor)", options: String.CompareOptions.caseInsensitive)
        
        attrStri.addAttributes([
            NSAttributedString.Key.foregroundColor : UIColor.init(hex: "EF7380"),
            NSAttributedString.Key.font: UIFont.init(name: "Baloo2-SemiBold", size: label.font.pointSize) as Any
        ], range: nsRange)
        
        
      
        label.attributedText = attrStri
    }
    
    func convertAtributteLable(label: UILabel, textColor: String){
        let attrStri = NSMutableAttributedString.init(string: label.text!)
        let nsRange = NSString(string: label.text!)
                .range(of: "\(textColor)", options: String.CompareOptions.caseInsensitive)
        
        attrStri.addAttributes([
            NSAttributedString.Key.foregroundColor : UIColor.init(hex: "EF7380"),
            NSAttributedString.Key.font: UIFont.init(name: "Baloo2-Medium", size: label.font.pointSize) as Any
        ], range: nsRange)
        
        
      
        label.attributedText = attrStri
    }
    
    private func converCreateAt(_ date: String)-> Date?{
        //2024-10-11 01:14:27
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        format.timeZone = TimeZone(abbreviation: "EST")
        return format.date(from: date)
        
    }
}
extension ProfileUserViewController: ImageViewerControllerDelegate {
    func load(_ imageURL: URL, into imageView: UIImageView, completion: (() -> Void)?) {
        imageView.sd_setImage(with: imageURL) { image, error, type, url in
            completion?()
        }
    }
}
