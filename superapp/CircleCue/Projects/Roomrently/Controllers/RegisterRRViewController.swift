//
//  RegisterViewController.swift
//  Roomrently
//
//  Created by QTS Coder on 13/09/2023.
//

import UIKit
import Alamofire
import LGSideMenuController
class RegisterRRViewController: BaseRRViewController {
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var txfFirstName: UITextField!
    @IBOutlet weak var txfLastName: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfPhone: UITextField!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnPersonal: UIButton!
    @IBOutlet weak var btnBusiness: UIButton!
    @IBOutlet weak var btnBoth: UIButton!
    @IBOutlet weak var txfState: UITextField!
    @IBOutlet weak var txfCountry: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var txfCity: UITextField!
    @IBOutlet weak var txfUserName: UITextField!
    @IBOutlet weak var lblReq: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    var img: UIImage?
    var isMenu = false
    var isHidden: Bool = false
    var account = 1
    var type = 1
    var arrStates = [NSDictionary]()
    var dictState: NSDictionary?
    override func viewDidLoad() {
        super.viewDidLoad()
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.width/2
        imgAvatar.layer.masksToBounds = true
        if self.isMenu{
            btnBack.setImage(UIImage.init(named: "btn_menu"), for: .normal)
        }
        lblReq.attributedText = self.decorateText(sub: "Rent or Buy or Sell", des: "Requirement/Offering: Please briefly describe what type of property you are seeking to Rent or Buy or Sell in which areas.")
        
        lblNote.attributedText = self.decorateTextMutile(sub: "Rent or Buy", sub2: "Rent and Sell", des: "(Upon Submission you can browse the properties to Rent or Buy and can also Post Properties to Rent and Sell)")
        getState()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doBack(_ sender: Any) {
        if self.isMenu{
            self.sideMenuController?.showLeftView(animated: true)
        }
        else{
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func loginWithGoogle(_ sender: Any) {
        self.signInWithGoogle()
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        self.signInWithFacebook()
    }
    
    @IBAction func loginWithApple(_ sender: Any) {
        self.performSignInWithApple()
    }
    func decorateText(sub:String, des:String)->NSAttributedString{
        let attrStri = NSMutableAttributedString.init(string:des)
        let nsRange = NSString(string:des)
                .range(of: sub, options: String.CompareOptions.caseInsensitive)
        attrStri.addAttributes([
            NSAttributedString.Key.foregroundColor : UIColor.init(hex: "f19725"),
            NSAttributedString.Key.font: UIFont.init(name: "Poppins-Medium", size: 17) as Any
        ], range: nsRange)
   
        
        return  attrStri
    }
    func decorateTextMutile(sub:String, sub2:String, des:String)->NSAttributedString{
        let attrStri = NSMutableAttributedString.init(string:des)
        let nsRange = NSString(string:des)
                .range(of: sub, options: String.CompareOptions.caseInsensitive)
        attrStri.addAttributes([
            NSAttributedString.Key.foregroundColor : UIColor.init(hex: "f19725"),
            NSAttributedString.Key.font: UIFont.init(name: "Poppins-Medium", size: 17) as Any
            
            
        ], range: nsRange)
   
        let nsRange2 = NSString(string:des)
                .range(of: sub2, options: String.CompareOptions.caseInsensitive)
        attrStri.addAttributes([
            NSAttributedString.Key.foregroundColor : UIColor.init(hex: "f19725"),
            NSAttributedString.Key.font: UIFont.init(name: "Poppins-Medium", size: 17) as Any
            
            
        ], range: nsRange2)
        
        
        return  attrStri
    }
    @IBAction func doState(_ sender: Any) {
        var arrs = [String]()
        for arrState in arrStates {
            arrs.append(arrState.object(forKey: "name") as? String ?? "")
        }
        DPPickerManager.shared.showPicker(title: "State", sender, selected: txfState.text, strings: arrs) { value, index, cancel in
            if !cancel{
                self.dictState = self.arrStates[index]
                self.txfState.text  = value
            }
        }
    }
    
   
    
    @IBAction func doAccount(_ sender: Any) {
        guard let btn = sender as? UIButton else {
            return
        }
        account = btn.tag + 1
        if btn.tag == 0{
            btnPersonal.setImage(UIImage.init(named: "radio_selected"), for: .normal)
            btnBusiness.setImage(UIImage.init(named: "radio"), for: .normal)
            btnBoth.setImage(UIImage.init(named: "radio"), for: .normal)
        }
        else if btn.tag == 1{
            btnPersonal.setImage(UIImage.init(named: "radio"), for: .normal)
            btnBusiness.setImage(UIImage.init(named: "radio_selected"), for: .normal)
            btnBoth.setImage(UIImage.init(named: "radio"), for: .normal)
        }
        else{
            btnPersonal.setImage(UIImage.init(named: "radio"), for: .normal)
            btnBusiness.setImage(UIImage.init(named: "radio"), for: .normal)
            btnBoth.setImage(UIImage.init(named: "radio_selected"), for: .normal)
        }
    }
    @IBAction func doAvatar(_ sender: Any) {
        self.showPhotoAndLibrary()
    }
    @IBAction func doSubmit(_ sender: Any) {
        let firstName = txfFirstName.text!.trimText()
        let lastName = txfLastName.text!.trimText()
        let email = txfEmail.text!.trimText()
        let phone = txfPhone.text!.trimText()
        let state =  txfState.text!.trimText()
        let country =  txfCountry.text!.trimText()
        let password =  txfPassword.text!
        let city =  txfCity.text!.trimText()
        let username =  txfUserName.text!.trimText()
        if img == nil{
            self.showAlertMessage(message: "Photo is required")
            return
        }

        if firstName.isEmpty{
            self.showAlertMessage(message: "First Name is required")
            return
        }
        if lastName.isEmpty{
            self.showAlertMessage(message: "Last Name is required")
            return
        }
        if username.isEmpty{
            self.showAlertMessage(message: "Username is required")
            return
        }
        if email.isEmpty{
            self.showAlertMessage(message: "Email is required")
            return
        }
        if !email.isValidEmail(){
            self.showAlertMessage(message: "Email is invalid")
            return
        }
        if city.isEmpty{
            self.showAlertMessage(message: "City is required")
            return
        }
        if state.isEmpty{
            self.showAlertMessage(message: "State is required")
            return
        }
        if country.isEmpty{
            self.showAlertMessage(message: "Country is required")
            return
        }
        if password.isEmpty{
            self.showAlertMessage(message: "Password is required")
            return
        }
        if phone.isEmpty{
            self.showAlertMessage(message: "Phone is required")
            return
        }
        var stateValue = ""
        if let dictState = dictState{
            let code = dictState.object(forKey: "code") as? String ?? ""
            stateValue = code
        }
        else{
            stateValue = state
        }
        self.showBusy()
        let param: Parameters = ["fname": firstName, "lname": lastName, "username": username, "src": "iOS", "email": email, "phone": phone, "btype": "\(account)", "state": stateValue, "country": country, "password": password, "city": city]
        APIRoomrentlyHelper.shared.registerUserAvatar(param, img!) { success, errer in
            self.hideBusy()
            if success!{
                APP_DELEGATE.isRegisterNew = true
                APP_DELEGATE.initHome()
            }
            else{
                if let errer = errer{
                    self.showAlertMessage(message: errer)
                }
            }
        }

    }
    
    private func getState()
    {
        self.showBusy()
        APIRoomrentlyHelper.shared.getStates { success, arrs in
            self.hideBusy()
            self.arrStates.removeAll()
            if let arrs = arrs{
                self.arrStates = arrs
            }
        }
    }
}
extension RegisterRRViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfFirstName{
            txfLastName.becomeFirstResponder()
        }
      
        else if textField == txfLastName{
            txfEmail.becomeFirstResponder()
        }
        else if textField == txfEmail{
            txfPhone.becomeFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       return true
        
    }
}
extension RegisterRRViewController{
    private func showPhotoAndLibrary()
    {
        var style = UIAlertController.Style.actionSheet
        if DEVICE_IPAD{
            style = UIAlertController.Style.alert
        }
        
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: style)
        let camera = UIAlertAction.init(title: "Take a photo", style: .default) { (action) in
            //self.showCamera()
            self.showCamera()
        }
        alert.addAction(camera)
        
        let library = UIAlertAction.init(title: "Choose from library", style: .default) { (action) in
            self.showLibrary()
        }
        alert.addAction(library)
        
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(cancel)
        self.present(alert, animated: true) {
            
        }
    }
    
    private func showCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = ["public.image"]
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
    private func showLibrary()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = ["public.image"]
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension RegisterRRViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
   
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            
            return
        }
        img = image
        imgAvatar.image = image
        imgAvatar.isHidden = false
        self.dismiss(animated: true)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
            
        }
    }
}
