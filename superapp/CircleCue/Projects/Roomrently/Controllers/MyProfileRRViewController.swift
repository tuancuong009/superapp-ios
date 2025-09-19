//
//  MyProfileViewController.swift
//  Roomrently
//
//  Created by QTS Coder on 14/09/2023.
//


import UIKit
import Alamofire
import SDWebImage
class MyProfileRRViewController: BaseRRViewController {
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var txfFirstName: UITextField!
    @IBOutlet weak var txfLastName: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfPhone: UITextField!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet var arrForms: [UIView]!
    var img: UIImage?
    @IBOutlet weak var btnPersonal: UIButton!
    @IBOutlet weak var btnBusiness: UIButton!
    @IBOutlet weak var btnBoth: UIButton!
    @IBOutlet weak var txfState: UITextField!
    @IBOutlet weak var txfCountry: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var txfCity: UITextField!
    
    @IBOutlet weak var viewCity: UIView!
    @IBOutlet weak var viewState: UIView!
    @IBOutlet weak var viewCountry: UIView!
    @IBOutlet weak var scrollPage: UIScrollView!
    var isHidden: Bool = false
    var account = 1
    var type = 1
    var arrStates = [NSDictionary]()
    var dictState: NSDictionary?
    override func viewDidLoad() {
        super.viewDidLoad()
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.width/2
        imgAvatar.layer.masksToBounds = true
        getMyprofile()
        self.formEdit(false)
        getState()
        // Do any additional setup after loading the view.
    }
    @IBAction func doList(_ sender: Any) {
        let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
  
    @IBAction func doAccount(_ sender: Any) {
        if !btnEdit.isHidden{
            return
        }
        guard let btn = sender as? UIButton else {
            return
        }
        account = btn.tag + 1
        if btn.tag == 0{
            btnPersonal.setImage(UIImage.init(named: "radio_selected"), for: .normal)
            btnBusiness.setImage(UIImage.init(named: "radio"), for: .normal)
            btnBoth.setImage(UIImage.init(named: "radio"), for: .normal)
        }
        else  if btn.tag == 1{
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
    @IBAction func doMyWanted(_ sender: Any) {
        let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "MyWantedVC") as! MyWantedVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doMyInquiry(_ sender: Any) {
        let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "InquiryViewController") as! InquiryViewController
        vc.isProfile = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func doMyProperty(_ sender: Any) {
        let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "MyPropertyViewController") as! MyPropertyViewController
        vc.isProfile = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doDeleteAccount(_ sender: Any) {
        var stype = UIAlertController.Style.actionSheet
        if DEVICE_IPAD{
            stype = UIAlertController.Style.alert
        }
        let alert = UIAlertController(title: APP_NAME,
                                      message: "Are you sure you want to delete? If you delete it permanently then you will have to re-register.",
                                      preferredStyle: stype)
        let cancelAction = UIAlertAction(title: "No",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        let delete = UIAlertAction.init(title: "Yes", style: .destructive) { action in
            self.showBusy()
            let param: Parameters = ["id": UserDefaults.standard.value(forKey: USER_ID_RR) as? String ?? ""]
            APIRoomrentlyHelper.shared.deleteProfile(param) { success, erro in
                self.hideBusy()
                if success!{
                    UserDefaults.standard.removeObject(forKey: USER_ID_RR)
                    APP_DELEGATE.initShowCase()
                }
                else{
                    if let erro = erro{
                        self.showAlertMessage(message: erro)
                    }
                }
            }
            
        }
        alert.addAction(delete)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func doEdit(_ sender: Any) {
        btnEdit.isHidden = true
        formEdit(true)
    }
    
    @IBAction func doAvatar(_ sender: Any) {
        self.showPhotoAndLibrary()
    }
    @IBAction func doSubmit(_ sender: Any) {
        let firstName = txfFirstName.text!.trimText()
        let lastName = txfLastName.text!.trimText()
        let phone = txfPhone.text!.trimText()
    
        let state =  txfState.text!.trimText()
        let country =  txfCountry.text!.trimText()
        let city =  txfCity.text!.trimText()
        let password =  txfPassword.text!
      
        if firstName.isEmpty{
            self.showAlertMessage(message: "First Name is required")
            return
        }
//        if lastName.isEmpty{
//            self.showAlertMessage(message: "Last Name is required")
//            return
//        }
       
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
        if img != nil{
            self.showBusy()
            let param: Parameters = ["fname": firstName, "lname": lastName , "phone": phone, "id": UserDefaults.standard.value(forKey: USER_ID_RR) as? String ?? "", "btype": "\(account)", "utype": "\(type)", "state": stateValue, "country": country, "city": city, "password": password, "email": txfEmail.text!.trimText()]
            APIRoomrentlyHelper.shared.updateProfileAvatar(param, img!) { success, errer in
                self.hideBusy()
                if success!{
                    SDImageCache.shared.clearMemory()
                    SDImageCache.shared.clearDisk()
                    self.showAlertMessage(message: "Your profile has been updated.")
                    self.formEdit(false)
                }
                else{
                    if let errer = errer{
                        self.showAlertMessage(message: errer)
                    }
                }
            }
        }
        else{
            self.showBusy()
            let param: Parameters = ["fname": firstName, "lname": lastName, "phone": phone, "id": UserDefaults.standard.value(forKey: USER_ID_RR) as? String ?? "", "btype": "\(account)", "state": stateValue, "country": country, "city": city, "password": password, "email": txfEmail.text!.trimText()]
            APIRoomrentlyHelper.shared.updateProfile(param) { success, erro in
                self.hideBusy()
                if success!{
                    self.showAlertMessage(message: "Your profile has been updated.")
                    self.formEdit(false)
                }
                else{
                    if let erro = erro{
                        self.showAlertMessage(message: erro)
                    }
                }
            }
        }
        
    }
    
    private func getMyprofile(){
        self.scrollPage.isHidden = true
        self.showBusy()
        APIRoomrentlyHelper.shared.getMyProfile { success, erro in
          
            self.hideBusy()
            if let erro = erro{
                self.updateUI(erro)
            }
        }
    }
    
    private func formEdit(_ isEdit: Bool){
        if !isEdit{
            for sub in self.arrForms{
                sub.backgroundColor = .init(hex: "e9ecef")
            }
            self.txfFirstName.isEnabled = false
            self.txfLastName.isEnabled = false
            self.txfEmail.isEnabled = false
            self.txfPhone.isEnabled = false
            self.txfCity.isEnabled = false
            self.txfState.isEnabled = false
            self.txfCountry.isEnabled = false
            self.view.endEditing(true)
            btnUpdate.isHidden = true
            self.txfPassword.isEnabled = false
        }
        else{
            for sub in self.arrForms{
                sub.backgroundColor = .white
            }
           
            self.txfFirstName.isEnabled = true
            self.txfLastName.isEnabled = true
            self.txfEmail.isEnabled = false
            self.txfPhone.isEnabled = true
            self.txfCity.isEnabled = false
            self.txfState.isEnabled = false
            self.txfCountry.isEnabled = true
            self.txfPassword.isEnabled = true
            btnUpdate.isHidden = false
            txfFirstName.becomeFirstResponder()
        }
    }
    
    private func getState()
    {
        APIRoomrentlyHelper.shared.getStates { success, arrs in
            self.arrStates.removeAll()
            if let arrs = arrs{
                self.arrStates = arrs
            }
        }
    }
}
extension MyProfileRRViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfFirstName{
            txfLastName.becomeFirstResponder()
        }
       
        else if textField == txfLastName{
            txfEmail.becomeFirstResponder()
        }
        else if textField == txfEmail{
            txfCity.becomeFirstResponder()
        }
        else if textField == txfCity{
            txfState.becomeFirstResponder()
        }
        else if textField == txfState{
            txfCountry.becomeFirstResponder()
        }
        else if textField == txfCountry{
            txfPassword.becomeFirstResponder()
        }
        else if textField == txfPassword{
            txfPhone.becomeFirstResponder()
        }
       
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       return true
        
    }
}
extension MyProfileRRViewController{
    private func updateUI(_ dict: NSDictionary){
        self.txfFirstName.text = dict.object(forKey: "fname") as? String
        self.txfLastName.text = dict.object(forKey: "lname") as? String
        self.txfEmail.text = dict.object(forKey: "email") as? String
        self.txfPhone.text = dict.object(forKey: "phone") as? String
        if let img = dict.object(forKey: "img") as? String{
            imgAvatar.sd_setImage(with: URL.init(string: img))
        }
        if let phone_status = dict.object(forKey: "phone_status") as? String{
            if phone_status == "1"
            {
                
                isHidden = true
            }
            else{
                
                isHidden = false
            }
        }
        self.txfCity.text = dict.object(forKey: "city") as? String
        self.txfState.text = dict.object(forKey: "state") as? String
        self.txfCountry.text = dict.object(forKey: "country") as? String
       
        self.txfPassword.text = dict.object(forKey: "password") as? String
        
        
        if let btype = dict.object(forKey: "btype") as? String{
            account = Int(btype) ?? 1
            if account == 1{
                btnPersonal.setImage(UIImage.init(named: "radio_selected"), for: .normal)
                btnBusiness.setImage(UIImage.init(named: "radio"), for: .normal)
                btnBoth.setImage(UIImage.init(named: "radio"), for: .normal)
            }
            else if account == 2{
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
        self.scrollPage.isHidden = false
    }
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

extension MyProfileRRViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
   
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            
            return
        }
        img = image
        imgAvatar.image = image
        self.dismiss(animated: true)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
            
        }
    }
}
