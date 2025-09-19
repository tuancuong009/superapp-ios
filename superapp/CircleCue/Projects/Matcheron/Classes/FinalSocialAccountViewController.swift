//
//  FinalSocialAccountViewController.swift
//  Matcheron
//
//  Created by QTS Coder on 29/11/24.
//

import UIKit

import Alamofire
import SDWebImage
class FinalSocialAccountViewController: BaseMatcheronViewController {
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var btnSeekingFemale: UIButton!
    @IBOutlet weak var btnSeekingMale: UIButton!
    @IBOutlet weak var btnGenderFemale: UIButton!
    @IBOutlet weak var btnGenderMale: UIButton!
    @IBOutlet weak var txfLastName: UITextField!
    @IBOutlet weak var txfFirstName: UITextField!
    @IBOutlet weak var btnSeekingBoth: UIButton!
    
    @IBOutlet weak var txfState: UITextField!
    @IBOutlet weak var txfPhoneNumber: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var txfEmailAddress: UITextField!
    @IBOutlet weak var txfRegion: UITextField!
    // @IBOutlet weak var btnAvatar: UIButton!
    @IBOutlet weak var btnParingEx: UIButton!
    @IBOutlet weak var btnParingOpen: UIButton!
    @IBOutlet weak var txfStatus: UITextField!
    @IBOutlet weak var step1: UIStackView!
    @IBOutlet weak var step2: UIStackView!
    @IBOutlet weak var scrollPage: UIScrollView!
    @IBOutlet weak var cltGoals: UICollectionView!
    
    @IBOutlet weak var txfCountry: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var txfAge: UITextField!
    @IBOutlet weak var txfHeight: UITextField!
    @IBOutlet weak var txfWeight: UITextField!
    @IBOutlet weak var txfProsonal: UITextField!
    @IBOutlet weak var lblPlaceHolder: UILabel!
    @IBOutlet weak var txfCountryOrigin: UITextField!
    @IBOutlet weak var tvMessage: UITextView!
    @IBOutlet weak var btnDeleteImage1: UIButton!
    @IBOutlet weak var btnDeleteImage2: UIButton!
    @IBOutlet weak var btnDeleteImage3: UIButton!
    @IBOutlet weak var viewFirstName: UIView!
    @IBOutlet weak var viewLastName: UIView!
    @IBOutlet weak var viewReliginOn: UIView!
    @IBOutlet weak var viewAge: UIView!
    @IBOutlet weak var viewHeight: UIView!
    @IBOutlet weak var viewWeight: UIView!
    @IBOutlet weak var viewContryOfOrigin: UIView!
    @IBOutlet weak var viewCurrentCountry: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnPhoneVisible: UIButton!
    @IBOutlet weak var btnPhoneHidden: UIButton!
    @IBOutlet weak var currentCountryButton: UIButton!
    
    var  gender = ""
    var seeking = ""
    var goal = ""
    var pairing = ""
    var countryId = ""
    var arrCountries = [NSDictionary]()
    var arrStates = [NSDictionary]()
    var arrRegions = [NSDictionary]()
    var arrGoals = [NSDictionary]()
    var stateId = ""
    var RegionId = ""
    var indexPicture = 0
    var dictUser: NSDictionary?
    var image1 = ""
    var image2 = ""
    var image3 = ""
    var countryOrigin = ""
    var imageEdit1: UIImage?
    var imageEdit2: UIImage?
    var imageEdit3: UIImage?
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    
    @IBOutlet weak var img3: UIImageView!
    var indexRegion = 0
    var indexState = 0
    var indexStatus = 0
    var indexCountry = 0
    
    // Handle user has current country or not then disable select country button
    private var hasCurrentCountry: Bool = false {
        didSet {
            currentCountryButton.isEnabled = !hasCurrentCountry
            currentCountryButton.setImage(hasCurrentCountry ? nil : UIImage(named: "down"), for: .normal)
        }
    }
    
    private func showWarning(){
        let attributedString = NSAttributedString(string: "WARNING", attributes: [
            NSAttributedString.Key.font : UIFont(name: "Baloo2-SemiBold", size: 28) ?? UIFont.systemFont(ofSize: 22), //your font here
            NSAttributedString.Key.foregroundColor : UIColor.red
        ])
        let attributedStringDesc = NSAttributedString(string: "\nComplete your Matcheron profile with a real photo and all details now, or it will be deleted, and you'll need to sign up again.", attributes: [
            NSAttributedString.Key.font : UIFont(name: "Baloo2-Medium", size: 20) ?? UIFont.systemFont(ofSize: 22), //your font here
            NSAttributedString.Key.foregroundColor : UIColor.black
        ])

        let alert = UIAlertController(title: "", message: "",  preferredStyle: .alert)

        alert.setValue(attributedString, forKey: "attributedTitle")
        alert.setValue(attributedStringDesc, forKey: "attributedMessage")
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (_) in
        }

        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        updateUI()
        showWarning()
        // Do any additional setup after loading the view.
    }
   

    @IBAction func doImage1(_ sender: Any) {
        indexPicture = 0
        showPhotoAndLibrary()
    }
    
    @IBAction func doImage2(_ sender: Any) {
        indexPicture = 1
        showPhotoAndLibrary()
    }
    @IBAction func doImage3(_ sender: Any) {
        indexPicture = 2
        showPhotoAndLibrary()
    }
    @IBAction func doParingOpen(_ sender: Any) {
     
        btnParingEx.isSelected = false
        btnParingOpen.isSelected = true
        pairing = "Open"
    }
    
    @IBAction func doParingEx(_ sender: Any) {
     
        btnParingEx.isSelected = true
        btnParingOpen.isSelected = false
        pairing = "Exclusive"
    }
    
    @IBAction func doStatus(_ sender: Any) {
        let values = ["Single", "Divorced", "Married", "Widowed ", "Separated", "Other"]
        
        let vc = PickerViewController()
        vc.arrDatas = values
        vc.titleNavi = "Status"
        vc.indexSelect = indexStatus
        vc.isRequiredSlect = true
        vc.tapDone = { [self] in
            indexStatus = vc.indexSelect
            self.txfStatus.text = vc.value
            
        }
        self.present(vc, animated: true)
        
    }
    @IBAction func doCountryOrgin(_ sender: Any) {

        let vc = OrginCountryViewController.init()
        vc.isSearch = false
        vc.tapCountry = { [self] in
            self.txfCountryOrigin.text = vc.country
            self.countryOrigin = vc.country
        }
        present(vc, animated: true)
        
    }
    @IBAction func doState(_ sender: Any) {
        var values = [String]()
        for arrState in arrStates {
            values.append(arrState.object(forKey: "name") as? String ?? "")
        }

        
        let vc = PickerViewController()
        vc.arrDatas = values
        vc.titleNavi = "State"
        vc.indexSelect = indexState
        vc.isRequiredSlect = true
        vc.tapDone = { [self] in
            indexState = vc.indexSelect
            self.txfState.text = vc.value
            self.stateId = self.arrStates[indexState].object(forKey: "id") as? String ?? ""
            
        }
        self.present(vc, animated: true)
    }
    @IBAction func doRegion(_ sender: Any) {
     
        var values = [String]()
        for arrRegion in arrRegions {
            values.append(arrRegion.object(forKey: "name") as? String ?? "")
        }
        let vc = PickerViewController()
        vc.arrDatas = values
        vc.titleNavi = "Religion"
        vc.indexSelect = indexRegion
        vc.isRequiredSlect = true
        vc.tapDone = { [self] in
            let seconds = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                let vcRegion = ReligionPopUpViewController.init()
                vcRegion.religion = vc.value
                vcRegion.modalTransitionStyle = .crossDissolve
                vcRegion.modalPresentationStyle = .overFullScreen
                vcRegion.tapYes = { [self] in
                    indexRegion = vc.indexSelect
                    self.txfRegion.text = vc.value
                    self.RegionId = self.arrRegions[indexRegion].object(forKey: "id") as? String ?? ""
                }
                self.present(vcRegion, animated: true)
            }
           
            
           
            
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func doCountry(_ sender: Any) {
        guard !hasCurrentCountry else { return }
     
        var values = [String]()
        for arrCountry in arrCountries {
            values.append(arrCountry.object(forKey: "country_name") as? String ?? "")
        }
        let vc = PickerViewController()
        vc.arrDatas = values
        vc.titleNavi = "Country"
        vc.indexSelect = indexCountry
        vc.isRequiredSlect = true
        vc.tapDone = { [self] in
            indexCountry = vc.indexSelect
            self.txfCountry.text = vc.value
            self.countryId = self.arrCountries[indexCountry].object(forKey: "id") as? String ?? ""
            self.txfState.text = nil
            self.stateId = ""
            self.showBusy()
            APIHelper.shared.getStates(countryId: self.countryId) { success, dict in
                self.hideBusy()
                self.arrStates.removeAll()
                if let dict = dict{
                    self.arrStates = dict
                }
            }
        }
        self.present(vc, animated: true)
    }
    @IBAction func doPhoneVisible(_ sender: Any) {
        btnPhoneVisible.isSelected = true
        btnPhoneHidden.isSelected = false
    }
    @IBAction func doPhoneHide(_ sender: Any) {
        btnPhoneVisible.isSelected = false
        btnPhoneHidden.isSelected = true
    }
    @IBAction func doGenderMale(_ sender: Any) {
      
        btnGenderMale.isSelected = true
        btnGenderFemale.isSelected = false
        gender = "Male"
        
        seeking = "FeMale"
        btnSeekingFemale.isHidden = false
        btnSeekingMale.isHidden = true
    }
    @IBAction func doGenderFemale(_ sender: Any) {
      
        btnGenderMale.isSelected = false
        btnGenderFemale.isSelected = true
        gender = "Female"
        
        seeking = "Male"
        btnSeekingFemale.isHidden = true
        btnSeekingMale.isHidden = false
    }
    
    @IBAction func doSeekingMale(_ sender: Any) {
     
    }
    @IBAction func doSeekingFemale(_ sender: Any) {
        
    }
    @IBAction func doSeekingBoth(_ sender: Any) {
       
    }
    @IBAction func doLogin(_ sender: Any) {
        dismiss(animated: true)
    }
    private func validateFormStep1()-> String{
        let firstName = txfFirstName.text!.trimText()
        let lastName = txfLastName.text!.trimText()
        let religion = txfRegion.text!.trimText()
        if firstName.isEmpty{
           return "First Name is required"
        }
        if lastName.isEmpty{
            return "Last Name is required"
        }
        if gender.isEmpty{
            return "Gender is required"
        }
        if seeking.isEmpty{
            return "Seeking is required"
        }
        if goal.isEmpty{
            return "Goal is required"
        }
        if pairing.isEmpty{
            return "Pairing is required"
        }
        if religion.isEmpty{
            return "Religion is required"
        }
        return ""
    }
    
    private func validateFormStep2()-> String{
        let age = txfAge.text!.trimText()
        let height = txfHeight.text!.trimText()
        let weight = txfWeight.text!.trimText()
        let email = txfEmailAddress.text!.trimText()
        let password = txfPassword.text!
        let phone = txfPhoneNumber.text!.trimText()
        let status = txfStatus.text!.trimText()
        let country = txfCountry.text!.trimText()
        let state = txfState.text!.trimText()
        let profession = txfProsonal.text!.trimText()
        let bio = tvMessage.text!.trimText()
        if age.isEmpty{
           return "Age is required"
        }
        if height.isEmpty{
            return "Height is required"
        }
        if weight.isEmpty{
            return "weight is required"
        }
        if email.isEmpty{
            return "Email is required"
        }
        if !email.isValidEmail(){
            return "Email is invalid"
        }
        if password.isEmpty{
            return "Password is required"
        }
        if phone.isEmpty{
            return "Mobile Number is required"
        }
        if status.isEmpty{
            return "Status is required"
        }
        if country.isEmpty{
            return "Country is required"
        }
        if state.isEmpty{
            return "State is required"
        }
     
        if status.isEmpty{
            return "Status is required"
        }
        if profession.isEmpty{
            return "Profession is required"
        }
        if bio.isEmpty{
            return "Comments is required"
        }
        
        return ""
    }
  
    @IBAction func doSignUp(_ sender: Any) {
        if step2.isHidden{
            let error = self.validateFormStep1()
            if error.isEmpty{
                step1.isHidden = true
                step2.isHidden = false
                btnSignUp.setTitle("Submit", for: .normal)
                scrollPage.setContentOffset(.zero, animated: true)
            }
            else{
                self.showAlertMessage(message: error)
            }
            
        }
        else{
            let error2 = self.validateFormStep2()
            if error2.isEmpty{
                self.callApi()
            }
            else{
                self.showAlertMessage(message: error2)
            }
            
        }
    }
    @IBAction func doDelImage1(_ sender: Any) {
        if imageEdit1 != nil{
            self.btnDeleteImage1.isHidden = true
            self.img1.image = nil
            self.imageEdit1 = nil
        }
        else{
            self.showAlertMessageAction("Do you want to delete?") { success in
                if success{
                    self.showBusy()
                    APIHelper.shared.deletePic("1") { success, error in
                        self.hideBusy()
                        self.btnDeleteImage1.isHidden = true
                        self.img1.image = nil
                    }
                }
            }
        }
        
    }
    @IBAction func doDelImage3(_ sender: Any) {
        if imageEdit3 != nil{
            self.btnDeleteImage3.isHidden = true
            self.img3.image = nil
            self.imageEdit3 = nil
        }
        else{
            self.showAlertMessageAction("Do you want to delete?") { success in
                if success{
                    self.showBusy()
                    APIHelper.shared.deletePic("3") { success, error in
                        self.hideBusy()
                        self.btnDeleteImage3.isHidden = true
                        self.img3.image = nil
                    }
                }
            }
        }
        
    }
    
    @IBAction func doDelImage2(_ sender: Any) {
        if imageEdit2 != nil{
            self.btnDeleteImage2.isHidden = true
            self.img2.image = nil
            self.imageEdit2 = nil
        }
        else{
            self.showAlertMessageAction("Do you want to delete?") { success in
                if success{
                    self.showBusy()
                    APIHelper.shared.deletePic("2") { success, error in
                        self.hideBusy()
                        self.btnDeleteImage2.isHidden = true
                        self.img2.image = nil
                    }
                }
            }
        }
        
    }
    
    @IBAction func doback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    
    func callApi(){
        let firstName = txfFirstName.text!.trimText()
        let lastName = txfLastName.text!.trimText()
        let age = txfAge.text!.trimText()
        let height = txfHeight.text!.trimText()
        let weight = txfWeight.text!.trimText()
        let email = txfEmailAddress.text!.trimText()
        let phone = txfPhoneNumber.text!.trimText()
        let status = txfStatus.text!.trimText()
        let profession = txfProsonal.text!.trimText()
        let bio = tvMessage.text!.trimText()
        var param: Parameters = [:]
        param["fname"] = firstName
        param["lname"] = lastName
        param["gender"] = gender
        param["seeking"] = seeking
        param["age"] = age
        param["height"] = height
        param["weight"] = weight
        param["status"] = status
        param["phone"] = phone
        param["email"] = email
        param["id"] = dictUser?.object(forKey: "id") as? String ?? ""
        if !RegionId.isEmpty{
            param["religion"] = RegionId
        }
        if !goal.isEmpty{
            param["goal"] = goal
        }
        if !stateId.isEmpty{
            param["state"] = stateId
        }
        if !countryOrigin.isEmpty{
            param["origin_country"] = countryOrigin
        }
        param["pairing"] = pairing
        param["profession"] = profession
        param["bio"] = bio
        param["country"] = countryId
        param["phonestatus"] = btnPhoneVisible.isSelected ? "1" : "0"
        self.showBusy()
        if imageEdit1 == nil && imageEdit2 == nil && imageEdit3 == nil{
            
            APIHelper.shared.profileUpdate(param) { success, erro in
                self.hideBusy()
                UserDefaults.standard.set(self.dictUser?.object(forKey: "id") as? String ?? "", forKey: USER_ID)
                if success!{
                    APP_DELEGATE.initTabbar()
                }
                else{
                    if let err = erro{
                        self.showAlertMessage(message: err)
                    }
                }
                
            }
            
        }
        else{
            SDImageCache.shared.clearMemory()
            SDImageCache.shared.clearDisk()
            APIHelper.shared.updatePhotosByComplete(id: self.dictUser?.object(forKey: "id") as? String ?? "", image1: imageEdit1, image2: imageEdit2, image3: imageEdit3) { success, errer in
                APIHelper.shared.profileUpdate(param) { success, erro in
                    UserDefaults.standard.set(self.dictUser?.object(forKey: "id") as? String ?? "", forKey: USER_ID)
                    self.hideBusy()
                    if success!{
                        APP_DELEGATE.initTabbar()
                    }
                    else{
                        if let err = erro{
                            self.showAlertMessage(message: err)
                        }
                    }
                }
            }
        }
        
    }
    
    private func showPhotoAndLibrary()
    {
        let style: UIAlertController.Style = .actionSheet
        
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
extension FinalSocialAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
   
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            
            return
        }
        if indexPicture == 0 {
            img1.image = image
            imageEdit1 = image
            btnDeleteImage1.isHidden = false
        }
        else if indexPicture == 1 {
            img2.image = image
            imageEdit2 = image
            btnDeleteImage1.isHidden = false
        }
        else{
            img3.image = image
            imageEdit3 = image
            btnDeleteImage3.isHidden = false
        }
        self.dismiss(animated: true)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
            
        }
    }
}
extension FinalSocialAccountViewController{
    private func updateUI(){
        step1.isHidden = false
        step2.isHidden = true
        cltGoals.register(UINib(nibName: "GoalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GoalCollectionViewCell")
        
        
        btnSignUp.setTitle("Next - Final Step", for: .normal)
        btnDeleteImage1.isHidden = true
        btnDeleteImage2.isHidden = true
        btnDeleteImage3.isHidden = true
        if let dictUser = dictUser{
            txfFirstName.text = dictUser.object(forKey: "fname") as? String
            
            txfLastName.text = dictUser.object(forKey: "lname") as? String
            
            txfRegion.text = dictUser.object(forKey: "religion") as? String
            
            txfAge.text  = dictUser.object(forKey: "age") as? String
            
            txfHeight.text = dictUser.object(forKey: "height") as? String
            
            txfWeight.text = dictUser.object(forKey: "weight") as? String
            
            txfEmailAddress.text = dictUser.object(forKey: "email") as? String
            txfPassword.text = dictUser.object(forKey: "password") as? String
            txfPhoneNumber.text = dictUser.object(forKey: "phone") as? String
            txfStatus.text = dictUser.object(forKey: "status") as? String
            txfProsonal.text = dictUser.object(forKey: "profession") as? String
            txfCountry.text = dictUser.object(forKey: "country") as? String
            tvMessage.text = dictUser.object(forKey: "bio") as? String
            image1 = dictUser.object(forKey: "img1") as? String ?? ""
            image2 = dictUser.object(forKey: "img2") as? String ?? ""
            image3 = dictUser.object(forKey: "img3") as? String ?? ""
            countryOrigin = dictUser.object(forKey: "origin_country") as? String ?? ""
            txfCountryOrigin.text = countryOrigin
            if !image1.isEmpty{
                self.img1.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.img1.sd_setImage(with: URL.init(string: image1)) { image1, errr, type, url in
                    
                }
                btnDeleteImage1.isHidden = false
            }
            if !image2.isEmpty{
                print("image2-->",image2)
                self.img2.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.img2.sd_setImage(with: URL.init(string: image2)) { image1, errr, type, url in
                    
                }
                btnDeleteImage2.isHidden = false
            }
            if !image3.isEmpty{
                self.img3.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.img3.sd_setImage(with: URL.init(string: image3)) { image1, errr, type, url in
                    
                }
                btnDeleteImage3.isHidden = false
            }
            if !tvMessage.text!.trimText().isEmpty{
                lblPlaceHolder.isHidden = true
            }
            let genderApi = dictUser.object(forKey: "gender") as? String ?? ""
            
            if genderApi.isEmpty{
                btnGenderMale.isHidden = false
                btnGenderFemale.isHidden = false
                btnGenderMale.isSelected = true
                btnGenderFemale.isSelected = false
                gender = "Male"
                seeking = "Female"
            }
            else{
                if genderApi.lowercased() == "Male".lowercased(){
                    btnGenderMale.isHidden = false
                    btnGenderFemale.isHidden = true
                    
                    btnGenderMale.isSelected = true
                    btnGenderFemale.isSelected = false
                    gender = "Male"
                    seeking = "Female"
                    btnGenderMale.setTitleColor(.gray, for: .normal)
                    
                }
                else {
                    btnGenderMale.isHidden = true
                    btnGenderFemale.isHidden = false
                    
                    btnGenderMale.isSelected = false
                    btnGenderFemale.isSelected = true
                    
                    btnGenderFemale.setTitleColor(.gray, for: .normal)
                    gender = "Female"
                    seeking = "Male"
                }
            }
            
            // let seekingApi = dictUser.object(forKey: "seeking") as? String ?? ""
            
            btnSeekingBoth.isSelected = true
            if genderApi.isEmpty{
                btnSeekingMale.isSelected = true
                btnSeekingFemale.isSelected = true
                btnSeekingMale.isHidden = true
                seeking = "Female"
            }
            else if genderApi.lowercased() == "Male".lowercased(){
                btnSeekingMale.isSelected = true
                btnSeekingFemale.isSelected = true
                btnSeekingMale.isHidden = true
                btnSeekingMale.setTitleColor(.gray, for: .normal)
                btnSeekingFemale.setTitleColor(.gray, for: .normal)
                seeking = "Female"
            }
            else if genderApi.lowercased() == "Female".lowercased(){
                btnSeekingMale.isSelected = true
                btnSeekingFemale.isSelected = true
                btnSeekingFemale.isHidden = true
                btnSeekingMale.setTitleColor(.gray, for: .normal)
                btnSeekingFemale.setTitleColor(.gray, for: .normal)
                seeking = "Male"
            }
            
            let pairingApi = dictUser.object(forKey: "pairing") as? String ?? ""
            if pairingApi == "Open"{
                btnParingEx.isSelected = false
                btnParingOpen.isSelected = true
                pairing = "Open"
                
                btnParingEx.setTitleColor(.gray, for: .normal)
                btnParingOpen.setTitleColor(.gray, for: .normal)
            }
            else  if pairingApi == "Exclusive"{
                btnParingEx.isSelected = true
                btnParingOpen.isSelected = false
                pairing = "Exclusive"
                
                btnParingEx.setTitleColor(.gray, for: .normal)
                btnParingOpen.setTitleColor(.gray, for: .normal)
            }
            else{
                btnParingEx.isSelected = false
                btnParingOpen.isSelected = false
                pairing = ""
            }
        }
        
        
        APIHelper.shared.getReligions { success, dict in
            if let dict = dict{
                self.arrRegions = dict
                for dictionary in dict {
                    if let name = dictionary.object(forKey: "name") as? String, name == self.txfRegion.text!.trimText(){
                        self.RegionId = dictionary.object(forKey: "id") as? String ?? ""
                    }
                }
            }
        }
        
        APIHelper.shared.getGoals { success, dict in
            DispatchQueue.main.async {
                if let dict = dict{
                    self.arrGoals = dict
                    for dictionary in dict {
                        if let name = dictionary.object(forKey: "name") as? String, name == (self.dictUser?.object(forKey: "goal") as? String  ?? ""){
                            self.goal = dictionary.object(forKey: "id") as? String ?? ""
                        }
                    }
                }
                self.cltGoals.reloadData()
            }
            
        }
        let country = dictUser?.object(forKey: "country") as? String ?? ""
        let state = dictUser?.object(forKey: "state") as? String ?? ""
        txfState.text = state
        print("origin_country--->",countryOrigin)
        
        if country.trimText().isEmpty {
            APIHelper.shared.currentcountry { success, currentCountry in
                if let currentCountry {
                    self.hasCurrentCountry = true
                    self.txfCountry.text = currentCountry.0
                    self.countryId = currentCountry.1
                }
                if !self.countryId.isEmpty {
                    APIHelper.shared.getStates(countryId: self.countryId) { success, dict in
                        self.hideBusy()
                        self.arrStates.removeAll()
                        if let dict = dict{
                            self.arrStates = dict
                            for dictionary in dict {
                                if let name = dictionary.object(forKey: "name") as? String, name == state{
                                    self.stateId = dictionary.object(forKey: "id") as? String ?? ""
                                    break
                                }
                            }
                        }
                    }
                }
            }
        } else {
            APIHelper.shared.getCountries { [self] success, dict in
                if let dict = dict{
                    self.arrCountries = dict
                    for dictionary in dict {
                        if let name = dictionary.object(forKey: "country_name") as? String, name == country{
                            self.countryId = dictionary.object(forKey: "id") as? String ?? ""
                            
                        }
                       
                    }
                    if self.countryId.isEmpty{
                        self.countryId = "231"
                    }
                    if !self.countryId.isEmpty {
                        APIHelper.shared.getStates(countryId: self.countryId) { success, dict in
                            self.hideBusy()
                            self.arrStates.removeAll()
                            if let dict = dict{
                                self.arrStates = dict
                                for dictionary in dict {
                                    if let name = dictionary.object(forKey: "name") as? String, name == state{
                                        self.stateId = dictionary.object(forKey: "id") as? String ?? ""
                                        break
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
}


extension  FinalSocialAccountViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("self.arrGoals.count--->",self.arrGoals.count)
        return self.arrGoals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cltGoals.dequeueReusableCell(withReuseIdentifier: "GoalCollectionViewCell", for: indexPath) as! GoalCollectionViewCell
        let dict = self.arrGoals[indexPath.row]
        cell.lblName.text = dict.object(forKey: "name") as? String
        cell.lblName.font = UIFont(name: cell.lblName.font.fontName, size: 20)
        if let dictUser = dictUser, let goal = dictUser.object(forKey: "goal") as? String, !goal.isEmpty{
            cell.lblName.textColor = .gray
        }
        else{
            cell.lblName.textColor = .black
        }
        
        
        if let id = dict.object(forKey: "id") as? String, id == goal{
            cell.icSelect.image = UIImage(named: "radio2")
        }
        else{
            cell.icSelect.image = UIImage(named: "radio")
        }
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let dictUser = dictUser, let goal = dictUser.object(forKey: "goal") as? String, !goal.isEmpty{
            return
        }
        let dict = self.arrGoals[indexPath.row]
        self.goal = dict.object(forKey: "id") as? String ?? ""
        cltGoals.reloadData()
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 1, height: 1)
    }
}

extension FinalSocialAccountViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        self.lblPlaceHolder.isHidden = textView.text!.count == 0 ? false : true
    }
}
