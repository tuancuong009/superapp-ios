//
//  RegisterVC.swift
//  Matcheron
//
//  Created by QTS Coder on 6/9/24.
//

import UIKit
import Alamofire
class RegisterVC: AllViewController {

    @IBOutlet weak var socialLoginView: UIView!
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
    @IBOutlet weak var imgPicture1: UIImageView!
    @IBOutlet weak var btnDelete1: UIButton!
    @IBOutlet weak var step1: UIStackView!
    @IBOutlet weak var step2: UIStackView!
    @IBOutlet weak var scrollPage: UIScrollView!
    @IBOutlet weak var cltGoals: UICollectionView!
    
    @IBOutlet weak var imgPicture2: UIImageView!
    @IBOutlet weak var btnDelete2: UIButton!
    @IBOutlet weak var imgPicture3: UIImageView!
    @IBOutlet weak var btnDelete3: UIButton!
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var txfCountry: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var subPicture1: UIStackView!
    @IBOutlet weak var subPicture2: UIStackView!
    @IBOutlet weak var txfAge: UITextField!
    @IBOutlet weak var txfHeight: UITextField!
    @IBOutlet weak var txfWeight: UITextField!
    @IBOutlet weak var txfProsonal: UITextField!
    @IBOutlet weak var lblPlaceHolder: UILabel!
    @IBOutlet weak var tvMessage: UITextView!
    @IBOutlet weak var btnShowHidePassword: UIButton!
    @IBOutlet weak var txfCoutryOrgin: UITextField!
    @IBOutlet weak var currentCountryButton: UIButton!
    @IBOutlet weak var btnPhoneVisible: UIButton!
    @IBOutlet weak var btnPhoneHidden: UIButton!
    
    
    var indexPicture = 0
    var  gender = "Male"
    var seeking = "Female"
    var goal = ""
    var pairing = ""
    var countryId = "231"
    var countryOrigin = "United States"
    var arrCountries = [NSDictionary]()
    var arrStates = [NSDictionary]()
    var arrRegions = [NSDictionary]()
    var arrGoals = [NSDictionary]()
    var stateId = ""
    var RegionId = ""
    
    var indexRegion = -1
    var indexCountry = -1
    var indexState = -1
    var indexStatus = -1
    
    // Handle user has current country or not then disable select country button
    private var hasCurrentCountry: Bool = false {
        didSet {
            currentCountryButton.isEnabled = !hasCurrentCountry
            currentCountryButton.setImage(hasCurrentCountry ? nil : UIImage(named: "down"), for: .normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        updateSizeFonts()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func doShowHidePassword(_ sender: Any) {
        btnShowHidePassword.isSelected = !btnShowHidePassword.isSelected
        if btnShowHidePassword.isSelected{
            txfPassword.isSecureTextEntry = false
        }
        else{
            txfPassword.isSecureTextEntry = true
        }
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
    @IBAction func doDeletePicture(_ sender: Any) {
        imgPicture1.image = nil
        imgPicture1.isHidden = true
        btnDelete1.isHidden = true
    }
    @IBAction func doDelete2(_ sender: Any) {
        imgPicture2.image = nil
        imgPicture2.isHidden = true
        btnDelete2.isHidden = true
        subPicture1.isHidden = true
    }
    @IBAction func doDelete3(_ sender: Any) {
        imgPicture3.image = nil
        imgPicture3.isHidden = true
        btnDelete3.isHidden = true
        subPicture2.isHidden = true
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
    
    @IBAction func doGoogle(_ sender: Any) {
        self.signInWithGoogle()
    }
    @IBAction func doApple(_ sender: Any) {
        self.performSignInWithApple()
    }
    @IBAction func doFacebook(_ sender: Any) {
        self.signInWithFacebook()
    }
    @IBAction func doCountryOfOrigin(_ sender: Any) {
        let vc = OrginCountryViewController.init()
        vc.isSearch = false
        vc.tapCountry = { [self] in
            if !vc.country.isEmpty{
                txfCoutryOrgin.text = vc.country
                countryOrigin = vc.country
            }
           
        }
        present(vc, animated: true)
    }
    @IBAction func doGenderMale(_ sender: Any) {
        btnGenderMale.isSelected = true
        btnGenderFemale.isSelected = false
        gender = "Male"
        seeking = "Female"
        btnSeekingMale.isHidden = true
        btnSeekingFemale.isHidden = false
    }
    @IBAction func doGenderFemale(_ sender: Any) {
        btnGenderMale.isSelected = false
        btnGenderFemale.isSelected = true
        gender = "Female"
        
        seeking = "Male"
        btnSeekingMale.isHidden = false
        btnSeekingFemale.isHidden = true
    }
    
    @IBAction func doSeekingMale(_ sender: Any) {
//        btnSeekingMale.isSelected = true
//        btnSeekingFemale.isSelected = false
//        btnSeekingBoth.isSelected = false
//        seeking = "Male"
    }
    @IBAction func doSeekingFemale(_ sender: Any) {
//        btnSeekingMale.isSelected = false
//        btnSeekingFemale.isSelected = true
//        btnSeekingBoth.isSelected = false
//        seeking = "Female"
    }
    @IBAction func doSeekingBoth(_ sender: Any) {
//        btnSeekingMale.isSelected = false
//        btnSeekingFemale.isSelected = false
//        btnSeekingBoth.isSelected = true
//        seeking = "Both"
    }
    @IBAction func doLogin(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func doPhoneVisible(_ sender: Any) {
        btnPhoneVisible.isSelected = true
        btnPhoneHidden.isSelected = false
    }
    @IBAction func doPhoneHide(_ sender: Any) {
        btnPhoneVisible.isSelected = false
        btnPhoneHidden.isSelected = true
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
    @IBAction func doSignUp(_ sender: Any) {
        if step2.isHidden{
            let error = self.validateFormStep1()
            if error.isEmpty{
                step1.isHidden = true
                socialLoginView.isHidden = true
                step2.isHidden = false
                btnSignUp.setTitle("Sign Up", for: .normal)
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
    @IBAction func doAvatar(_ sender: Any) {
        if let btn = sender as? UIButton{
            indexPicture = btn.tag
        }
        showPhotoAndLibrary()
    }
    @IBAction func doback(_ sender: Any) {
        if step1.isHidden {
            step1.isHidden = false
            socialLoginView.isHidden = false
            step2.isHidden = true
            btnSignUp.setTitle("NEXT", for: .normal)
            scrollPage.setContentOffset(.zero, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
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
        
        if imgPicture1.image == nil && imgPicture2.image == nil && imgPicture2.image == nil{
            return "Photo is required"
        }
        return ""
    }
    
    func callApi(){
        let firstName = txfFirstName.text!.trimText()
        let lastName = txfLastName.text!.trimText()
        let age = txfAge.text!.trimText()
        let height = txfHeight.text!.trimText()
        let weight = txfWeight.text!.trimText()
        let email = txfEmailAddress.text!.trimText()
        let password = txfPassword.text!
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
        param["country"] = countryId
        param["state"] = stateId
        param["phone"] = phone
        param["email"] = email
        param["religion"] = RegionId
        param["goal"] = goal
        param["pairing"] = pairing
        param["password"] = password
        param["profession"] = profession
        param["src"] = "iOS"
        param["src2"] = "email"
        param["phonestatus"] = btnPhoneVisible.isSelected ? "1" : "0"
        if !countryOrigin.isEmpty{
            param["origin_country"] = countryOrigin
        }
        
        self.showBusy()
        param["bio"] = bio
        APIHelper.shared.registerUserAvatar(image1: imgPicture1.image, image2: imgPicture2.image, image3: imgPicture3.image, param: param) { success, errer in
            self.hideBusy()
            if success!{
                APP_DELEGATE.initTabbar()
            }
            else{
                if let erro = errer{
                    self.showAlertMessage(message: erro)
                }
            }
        }
    }
}

extension RegisterVC{
    private func updateUI(){
        cltGoals.register(UINib(nibName: "GoalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GoalCollectionViewCell")
        step1.isHidden = false
        step2.isHidden = true
        imgPicture1.isHidden = true
        btnDelete1.isHidden = true
        
        imgPicture2.isHidden = true
        btnDelete2.isHidden = true
        
        imgPicture3.isHidden = true
        btnDelete3.isHidden = true
        
        btnSignUp.setTitle("Next Final Step", for: .normal)
        
        subPicture1.isHidden = true
        subPicture2.isHidden = true
        
        btnGenderMale.isSelected = true
        btnGenderFemale.isSelected = false
        
        btnSeekingMale.isSelected = true
        btnSeekingFemale.isSelected = true
        btnSeekingMale.isHidden = true
        APIHelper.shared.currentcountry { success, currentcountry in
            if let currentcountry {
                self.hasCurrentCountry = true
                self.txfCountry.text = currentcountry.0
                if !currentcountry.1.isEmpty {
                    self.countryId = currentcountry.1
                    APIHelper.shared.getStates(countryId: self.countryId) { success, dict in
                        self.arrStates.removeAll()
                        if let dict = dict {
                            self.arrStates = dict
                        }
                    }
                }
            } else {
                APIHelper.shared.getCountries { success, dict in
                    if let dict = dict{
                        self.arrCountries = dict
                    }
                }
            }
        }
        
        
        APIHelper.shared.getReligions { success, dict in
            if let dict = dict{
                self.arrRegions = dict
            }
        }
        
        APIHelper.shared.getGoals { success, dict in
            
            DispatchQueue.main.async {
                if let dict = dict{
                    self.arrGoals = dict
                }
                self.cltGoals.reloadData()
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
extension RegisterVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
   
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            
            return
        }
//        self.btnAvatar.setTitle("", for: .normal)
//        self.btnAvatar.setImage(image, for: .normal)
//        self.btnAvatar.layer.cornerRadius = self.btnAvatar.frame.size.width/2
//        self.btnAvatar.layer.masksToBounds = true
        if indexPicture == 0 {
            imgPicture1.image = image
            btnDelete1.isHidden = false
            imgPicture1.isHidden = false
            subPicture1.isHidden = false
        }
        else if indexPicture == 1 {
            imgPicture2.image = image
            btnDelete2.isHidden = false
            imgPicture2.isHidden = false
            subPicture2.isHidden = false
        }
        else{
            imgPicture3.image = image
            btnDelete3.isHidden = false
            imgPicture3.isHidden = false
        }
        self.dismiss(animated: true)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
            
        }
    }
}

extension  RegisterVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("self.arrGoals.count--->",self.arrGoals.count)
        return self.arrGoals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cltGoals.dequeueReusableCell(withReuseIdentifier: "GoalCollectionViewCell", for: indexPath) as! GoalCollectionViewCell
        let dict = self.arrGoals[indexPath.row]
        cell.lblName.text = dict.object(forKey: "name") as? String
        if let id = dict.object(forKey: "id") as? String, id == goal{
            cell.icSelect.image = UIImage(named: "radio2")
        }
        else{
            cell.icSelect.image = UIImage(named: "radio")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict = self.arrGoals[indexPath.row]
        self.goal = dict.object(forKey: "id") as? String ?? ""
        cltGoals.reloadData()
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 1, height: 1)
    }
}

extension RegisterVC: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        self.lblPlaceHolder.isHidden = textView.text!.count == 0 ? false : true
    }
}
