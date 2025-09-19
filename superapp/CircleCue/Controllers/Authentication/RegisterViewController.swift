//
//  RegisterViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/3/20.
//

import UIKit
import AuthenticationServices
import Alamofire
import FBSDKLoginKit

protocol RegisterViewControllerDelegate: AnyObject {
    func update(_ socialMedia: SocialMediaObj?)
    func socialLogin(_ socialMedia: SocialMediaObj)
}

enum PaymentType {
    case free
    case premium
}

enum UserType: Int {
    case personal = 0
    case business = 1
    
    var phoneNumberPlaceholder: String {
        switch self {
        case .personal:
            return "Mobile"
        case .business:
            return "Business Telephone"
        }
    }
    
    var uploadText: String {
        switch self {
        case .personal:
            return "Upload Photo"
        case .business:
            return "Upload Biz Logo / Images"
        }
    }
    
    var uploadPlaceholderText: String {
        switch self {
        case .personal:
            return "Choose a Photo"
        case .business:
            return "Choose a Logo"
        }
    }
    
    var zipcodePlaceholder: String {
        switch self {
        case .personal:
            return "City"
        case .business:
            return "City"
        }
    }
    
    var placeholderImage: UIImage? {
        switch self {
        case .personal:
            return UIImage(named: "new_avatar")
        case .business:
            return UIImage(named: "new_circle_logo")
        }
    }
    
    var titleName: String {
        switch self {
        case .personal:
            return "Occupation/Title"
        case .business:
            return "Industry/Title"
        }
    }
    
    var userNamePlaceHolder: String {
        return "Username (Min 3 Letters)"
    }
    var emailPlaceHolder: String {
        return "Email Address"
    }
    
    var requiredLabelPlaceHolder: String {
        return "*Required Fields"
    }
    
    var passwordPlaceHolder: String {
        return "Password"
    }
    
    var firstNamePlaceHolder: String {
        return "First Name"
    }
    
    var lastNamePlaceHolder: String {
        return "Last Name"
    }
    
    var businessNamePlaceHolder: String {
        return "Business Name"
    }
}

class RegisterViewController: AuthenticationViewController {
    
    
    @IBOutlet weak var personalButton: UIButton!
    @IBOutlet weak var businessButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var phoneNumberErrorLabel: UILabel!
    @IBOutlet weak var cityTextField: CustomTextField!
    @IBOutlet weak var cityErrorLabel: UILabel!
    @IBOutlet weak var titleErrorLabel: UILabel!
    @IBOutlet weak var bioErrorLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var travelSwitch: UISwitch!
    @IBOutlet weak var dineoutSwitch: UISwitch!
    @IBOutlet weak var datingSwitch: UISwitch!
    
    @IBOutlet weak var titleTextField: CustomTextField!
    @IBOutlet weak var bioTextView: GrowingTextView!
    
    @IBOutlet weak var stackPrivate: UIStackView!
    
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var passwordTextFiled: CustomTextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    var socialMedias: [SocialMediaObj] = []
    
   
    
    @IBOutlet weak var switchPrivate: UISwitch!
    @IBOutlet weak var stackNamePersonal: UIStackView!
    @IBOutlet weak var stackNameBusiness: UIStackView!
    @IBOutlet weak var txfFirstName: CustomTextField!
    @IBOutlet weak var lblErrorFirstName: UILabel!
    @IBOutlet weak var txfLastName: CustomTextField!
    @IBOutlet weak var lblErrorLastName: UILabel!
    @IBOutlet weak var txfBussinessName: CustomTextField!
    @IBOutlet weak var lblErorBusinessName: UILabel!
    @IBOutlet weak var btnClassFree: UIButton!
    @IBOutlet weak var btnVipCircle: UIButton!
    @IBOutlet weak var stackUrlBusiness: UIStackView!
    @IBOutlet weak var txfUrlBusiness: CustomTextField!
    @IBOutlet weak var errorLabelUrlBusiness: UILabel!
    @IBOutlet weak var viewPhotos: UIView!
    @IBOutlet weak var lblErrorPhoto: UILabel!
    @IBOutlet weak var btnPhoto1: UIButton!
    @IBOutlet weak var btnPhoto2: UIButton!
    @IBOutlet weak var btnPhoto3: UIButton!
    
    @IBOutlet weak var stackTravelDinnerPersonal: UIStackView!
    @IBOutlet weak var txfUrlPersonal: CustomTextField!
    @IBOutlet weak var errorUrlPersonal: UILabel!
    @IBOutlet weak var lblUploadPhhoto: UILabel!
    
    private var indexPhoto = 0
    var urlAvatar2: String?
    var urlAvatar3: String?
    private  var businessPricePerMonth = true
    private  var personalPricePerMonth = true
    @IBOutlet weak var step1: UIView!
    @IBOutlet weak var step2: UIView!
    @IBOutlet weak var btnJoinCircle: UIButton!
    @IBOutlet weak var viewSocial: UIView!
    @IBOutlet weak var btnSocialMedia: UIButton!
    @IBOutlet weak var txfCountry: CustomTextField!
    @IBOutlet weak var errorCountryLabel: UILabel!
    @IBOutlet weak var txfState: CustomTextField!
    @IBOutlet weak var errorStateLabel: UILabel!
    @IBOutlet weak var viewState: UIView!
    @IBOutlet weak var stackCard: UIStackView!
    @IBOutlet weak var txfCardNumber: CustomTextField!
    @IBOutlet weak var txfMonth: CustomTextField!
    @IBOutlet weak var txfYear: CustomTextField!
    @IBOutlet weak var txfCVV: CustomTextField!
    @IBOutlet weak var txfNameCard: CustomTextField!
    @IBOutlet weak var errorCardNumberLabel: UILabel!
    @IBOutlet weak var errorMonthLabel: UILabel!
    @IBOutlet weak var errorYearLabel: UILabel!
    @IBOutlet weak var errorCardNameLabel: UILabel!
    @IBOutlet weak var errorCVVLabel: UILabel!
    @IBOutlet weak var yearView: UIView!
    @IBOutlet weak var monthView: UIView!
    var countryId = ""
    var stateId = ""
    var arrStates = [NSDictionary]()
    private var stateDropDown = DropDown()
    private var stateDatasources: [String] = []
    private var monthDropDown = DropDown()
    private var yearDropDown = DropDown()
    @IBOutlet weak var scrollPage: UIScrollView!
    @IBOutlet weak var accountTypeView: UIStackView!
    @IBOutlet weak var btnMonth: UIButton!
    @IBOutlet weak var btnAnanul: UIButton!
    @IBOutlet weak var stackPricePackage: UIStackView!
    
    private var monthDataSource: [Int] = []
    private var yearDataSource: [Int] = []
    var isShowingPassword: Bool = false {
        didSet {
            passwordTextFiled.isSecureTextEntry = !isShowingPassword
            passwordTextFiled.text = passwordTextFiled.text
            showPasswordButton.setImage(isShowingPassword ? UIImage(named: "ic_visibility_off") : UIImage(named: "ic_visibility"), for: .normal)
        }
    }
    private var imageUploaded: Bool = false
    private var isNexStep: Bool = false
    private var socialExpanding: Bool = false {
        didSet {
            btnSocialMedia.isSelected = socialExpanding
            tableViewHeight.constant = socialExpanding ? (AddSocialTableViewCell.cellHeight * (socialMedias.count).cgFloat) : 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private let selectedIconImage = #imageLiteral(resourceName: "ic_selected_payment_16")
    private let unselectedIconImage = #imageLiteral(resourceName: "ic_unselected_payment_16")
    private var paymentType: PaymentType = .free{
        didSet {
            btnClassFree.isSelected = paymentType == .free ? true : false
            btnVipCircle.isSelected = paymentType == .free ? false : true
        }
    }
    private var plan: Int {
        if userType == .business {
            return businessPricePerMonth ? 2 : 1
        } else {
            return personalPricePerMonth ? 4 : 3
        }
    }
    @IBAction func showPasswordAction(_ sender: Any) {
        isShowingPassword.toggle()
    }
    
    @IBAction func didTapMonth(_ sender: Any) {
        errorMonthLabel.showError(false)
        monthDropDown.show()
    }
    @IBAction func didTapYear(_ sender: Any) {
        errorMonthLabel.showError(false)
        yearDropDown.show()
    }
    @IBAction func doBenefits(_ sender: Any) {
        let vc = SubscrViewController.init()
        vc.delegate = self
        self.present(vc, animated: true)
    }
    @IBAction func doPriceMonth(_ sender: Any) {
        btnMonth.isSelected = true
        btnAnanul.isSelected = false
        if userType == .personal{
            personalPricePerMonth =  true
        }
        else{
            businessPricePerMonth = true
        }
    }
    
    @IBAction func doAnual(_ sender: Any) {
        btnMonth.isSelected = false
        btnAnanul.isSelected = true
        if userType == .personal{
            personalPricePerMonth =  false
        }
        else{
            businessPricePerMonth = false
        }
    }
    private func changeUser(){
        if userType == .personal{
            personalButton.backgroundColor = UIColor(hex: "25A8E0")
            personalButton.setTitleColor(.white, for: .normal)
            
            personalButton.layer.borderWidth = 1.0
            personalButton.layer.borderColor = UIColor(hex: "25A8E0").cgColor
            
            personalButton.layer.cornerRadius = personalButton.frame.size.height/2
            personalButton.layer.masksToBounds = true
            
            
            businessButton.backgroundColor = UIColor.clear
            businessButton.setTitleColor(.init(hex: "787878"), for: .normal)
            
            businessButton.layer.borderWidth = 1.0
            businessButton.layer.borderColor = UIColor(hex: "C3C3C3").cgColor
            
            businessButton.layer.cornerRadius = personalButton.frame.size.height/2
            businessButton.layer.masksToBounds = true
            stackCard.isHidden = true
        }
        
        else{
            businessButton.backgroundColor = UIColor(hex: "663190")
            businessButton.setTitleColor(.white, for: .normal)
            
            businessButton.layer.borderWidth = 1.0
            businessButton.layer.borderColor = UIColor(hex: "663190").cgColor
            
            businessButton.layer.cornerRadius = personalButton.frame.size.height/2
            businessButton.layer.masksToBounds = true
            
            
            personalButton.backgroundColor = UIColor.clear
            personalButton.setTitleColor(.init(hex: "787878"), for: .normal)
            
            personalButton.layer.borderWidth = 1.0
            personalButton.layer.borderColor = UIColor(hex: "C3C3C3").cgColor
            
            personalButton.layer.cornerRadius = personalButton.frame.size.height/2
            personalButton.layer.masksToBounds = true
        }
    }
   
    
    private var userType: UserType = .personal {
        didSet {
            switch userType {
            case .personal:
               
                //resetPaymentView()
                stackNamePersonal.isHidden = false
                stackNameBusiness.isHidden = true
                
                stackUrlBusiness.isHidden = true
                stackTravelDinnerPersonal.isHidden = false
                
                socialMedias = [SocialMediaObj.init(type: .facebook),
                                                      SocialMediaObj.init(type: .instagram),
                                                      SocialMediaObj.init(type: .linkedin),
                                                      SocialMediaObj.init(type: .twitter),
                                                      SocialMediaObj.init(type: .blog)]
                if picturePath == nil{
                    btnPhoto1.setImage(UIImage(named: "uploadphoto_personal"), for: .normal)
                }
                if urlAvatar2 == nil{
                    btnPhoto2.setImage(UIImage(named: "uploadphoto_personal"), for: .normal)
                }
                if urlAvatar3 == nil{
                    btnPhoto3.setImage(UIImage(named: "uploadphoto_personal"), for: .normal)
                }
                stackPrivate.isHidden = false
                btnJoinCircle.backgroundColor = UIColor(hex: "25A8E0")
               
                
            case .business:
                
                stackPrivate.isHidden = true
                tableView.reloadData()
                //paymentType = .free
                stackNamePersonal.isHidden = true
                stackNameBusiness.isHidden = false
                
                stackUrlBusiness.isHidden = true
                stackTravelDinnerPersonal.isHidden = true
                socialMedias = [SocialMediaObj.init(type: .linkedin),
                                SocialMediaObj.init(type: .twitter),
                                SocialMediaObj.init(type: .facebook),
                                SocialMediaObj.init(type: .instagram),
                                SocialMediaObj.init(type: .blog)]
                
                if picturePath == nil{
                    btnPhoto1.setImage(UIImage(named: "uploadphoto_business"), for: .normal)
                }
                if urlAvatar2 == nil{
                    btnPhoto2.setImage(UIImage(named: "uploadphoto_business"), for: .normal)
                }
                if urlAvatar3 == nil{
                    btnPhoto3.setImage(UIImage(named: "uploadphoto_business"), for: .normal)
                }
                if btnVipCircle.isSelected{
                    stackCard.isHidden = false
                }
                else{
                    stackCard.isHidden = true
                }
                tableView.reloadData()
                btnJoinCircle.backgroundColor = UIColor(hex: "663190")
            }
            changeUser()
            resetErrorMessage()
            phoneNumberTextField.placeholder = userType.phoneNumberPlaceholder
            cityTextField.placeholder = userType.zipcodePlaceholder
            titleTextField.placeholder = userType.titleName
            lblUploadPhhoto.text = userType.uploadText
        }
    }
    private func setupUIDropDownYearMonth() {
        for month in 1...12 {
            monthDataSource.append(month)
        }
        let currentYear = Calendar.current.component(.year, from: Date())
        for year in currentYear...currentYear+50 {
            yearDataSource.append(year)
        }
        
        monthDropDown.anchorView = monthView
        monthDropDown.dataSource = monthDataSource.map({ $0.string })
        monthDropDown.bottomOffset = CGPoint(x: 0, y: monthView.frame.height + 2)
        monthDropDown.direction = .bottom
        monthDropDown.textFont = UIFont.myriadProRegular(ofSize: 16)
        monthDropDown.cellHeight = 40
        monthDropDown.animationduration = 0.2
        monthDropDown.backgroundColor = UIColor.white
        monthDropDown.selectionBackgroundColor = UIColor.yellow.withAlphaComponent(0.3)
        monthDropDown.dimmedBackgroundColor = UIColor.black.withAlphaComponent(0.3)
        monthDropDown.selectionAction = {[weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.txfMonth.text = "\(self.monthDataSource[index])"
        }
        
        yearDropDown.anchorView = yearView
        yearDropDown.dataSource = yearDataSource.map({ $0.string })
        yearDropDown.bottomOffset = CGPoint(x: 0, y: yearView.frame.height + 2)
        yearDropDown.direction = .bottom
        yearDropDown.textFont = UIFont.myriadProRegular(ofSize: 16)
        yearDropDown.cellHeight = 40
        yearDropDown.animationduration = 0.2
        yearDropDown.backgroundColor = UIColor.white
        yearDropDown.selectionBackgroundColor = UIColor.yellow.withAlphaComponent(0.3)
        yearDropDown.dimmedBackgroundColor = UIColor.black.withAlphaComponent(0.3)
        yearDropDown.selectionAction = {[weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.txfYear.text = "\(self.yearDataSource[index])"
        }
    }
    
    
    func createAttributedString(fullString: String, fullStringColor: UIColor, subString: String, subStringColor: UIColor) -> NSMutableAttributedString
    {
        let range = (fullString as NSString).range(of: subString)
        let attributedString = NSMutableAttributedString(string:fullString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: fullStringColor, range: NSRange(location: 0, length: fullString.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: subStringColor, range: range)
        return attributedString
    }
   
    
    var picturePath: String?
    weak var delegate: LoginDelegate?
    var pickerController: ImagePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTabelView()
    }
    
    @IBAction func faceboolLoginAction(_ sender: Any) {
        LoginManager().logOut()
        self.signInWithFacebook()
    }
    
    @IBAction func didTapGoogleSignInButton(_ sender: Any) {
        self.signInWithGoogle()
    }
    
    @IBAction func didTapAppleSignInButton(_ sender: Any) {
        self.performSignInWithApple()
    }
    
    @IBAction func selectTypeAction(_ sender: UIButton) {
        guard let type = UserType(rawValue: sender.tag), type != self.userType else { return }
        self.userType =  type
    }
    
    @IBAction func uploadPictureAction(_ sender: Any) {
        view.endEditing(true)
        guard let btn = sender as? UIButton else {
            return
        }
        indexPhoto = btn.tag
        pickerController?.present(title: userType.uploadPlaceholderText, message: nil, from: self.view)
    }
    
    @IBAction func socialMediaAccountAction(_ sender: Any) {
        view.endEditing(true)
        socialExpanding.toggle()
    }
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
  
    @IBAction func signUpAction(_ sender: Any) {
        var para: Parameters = ["ibusiness": userType.rawValue, "app_src": "iOS"]
        var userName: String = ""
        if let pic = picturePath {
            para.updateValue(pic, forKey: "pic")
        }
        
        var error: [Bool] = []
        if userType == .personal{
            if let firstName = txfFirstName.text?.trimmed, !firstName.isEmpty {
                lblErrorFirstName.showError(false)
                para.updateValue(firstName, forKey: "fname")
            } else {
                lblErrorFirstName.showError(true, ErrorMessage.firstNameIsEmpty.rawValue)
                error.append(true)
            }
            
            if let lastName = txfLastName.text?.trimmed, !lastName.isEmpty {
                lblErrorLastName.showError(false)
                para.updateValue(lastName, forKey: "lname")
            } else {
                lblErrorLastName.showError(true, ErrorMessage.lastNameIsEmpty.rawValue)
                error.append(true)
            }
        }
        else{
            if let businessName = txfBussinessName.text?.trimmed, !businessName.isEmpty {
                lblErorBusinessName.showError(false)
                para.updateValue(businessName, forKey: "fname")
            } else {
                lblErorBusinessName.showError(true, ErrorMessage.businessNameEmpty.rawValue)
                error.append(true)
            }
        }
        if let username = usernameTextField.text?.trimmed, !username.isEmpty {
            usernameErrorLabel.showError(false)
            para.updateValue(username, forKey: "username")
            userName = username
        } else {
            usernameErrorLabel.showError(true, ErrorMessage.usernameIsEmpty.rawValue)
            error.append(true)
        }
        
        if let email = emailTextField.text?.trimmed, !email.isEmpty {
            if email.isValidEmail() {
                emailErrorLabel.showError(false)
                para.updateValue(email, forKey: "email")
            } else {
                emailErrorLabel.showError(true, ErrorMessage.emailInvalid.rawValue)
                error.append(true)
            }
        } else {
            emailErrorLabel.showError(true, ErrorMessage.emailIsEmpty.rawValue)
            error.append(true)
        }
        
        if let password = passwordTextFiled.text, !password.isEmpty {
            if password.count < 4{
                error.append(true)
                passwordErrorLabel.showError(true, "Password must be at least 4 characters.")
            }
            else{
                
                para.updateValue(password, forKey: "password")
            }
        } else {
            error.append(true)
            passwordErrorLabel.showError(true, "Password is required.")
        }
        
        if let phoneNumber = phoneNumberTextField.trimmedText, !phoneNumber.isEmpty {
            phoneNumberErrorLabel.showError(false)
            para.updateValue(phoneNumber, forKey: "whatsapp")
            para.updateValue(0, forKey: "whatsapp_status")
        }
        
        if let city = cityTextField.trimmedText, !city.isEmpty {
            para.updateValue(city, forKey: "city")
        }
        if let state = txfState.trimmedText, !state.isEmpty {
            para.updateValue(state, forKey: "state")
        } else {
            
            errorStateLabel.showError(true, "State is required.")
        }
        if let title = titleTextField.trimmedText, !title.isEmpty {
            para.updateValue(title, forKey: "title")
        } else {
            
            if userType == .business {
                error.append(true)
                titleErrorLabel.showError(true, "Industry/Title is required.")
            } else {
                //titleErrorLabel.showError(true, "Occupation/Title is required.")
            }
        }
        if userType == .personal{
            if let url = txfUrlPersonal.trimmedText, !url.isEmpty {
                if !url.invalidUrl(){
                    error.append(true)
                    errorUrlPersonal.showError(true, "URL is invalid.")
                }
                else{
                    para.updateValue(url, forKey: "blog")
                }
            }
        }
        else{
            if let url = txfUrlBusiness.trimmedText, !url.isEmpty {
                if !url.invalidUrl(){
                    error.append(true)
                    errorLabelUrlBusiness.showError(true, "URL is invalid.")
                }
                else{
                    para.updateValue(url, forKey: "blog")
                }
            }
        }
//        
        
        if !bioTextView.text.trimmed.isEmpty {
            para.updateValue(bioTextView.text.trimmed, forKey: "bio")
        }
        
        if userType == .personal {
            para.updateValue(travelSwitch.isOn ? 1 : 0, forKey: "travel_status")
            para.updateValue(dineoutSwitch.isOn ? 1 : 0, forKey: "dinner_status")
            para.updateValue(datingSwitch.isOn ? 1 : 0, forKey: "dating_status")
        }
        
        if imageUploaded {
            lblErrorPhoto.showError(false)
        } else {
            lblErrorPhoto.showError(true, ErrorMessage.pictureMissing.rawValue)
            error.append(true)
        }
        
        para.updateValue(self.plan, forKey: "plan")
        if userType == .personal{
            if let pic2 = urlAvatar2 {
                para.updateValue(pic2, forKey: "pic2")
            }
            if let pic3 = urlAvatar3 {
                para.updateValue(pic3, forKey: "pic3")
            }
        }
        if userType == .business && paymentType != .free{
            para.updateValue(txfCardNumber.text!.trimmed, forKey: "card_number")
           
            para.updateValue("\(txfMonth.text!)/\(txfYear.text!)", forKey: "expiry_date")
           
            para.updateValue(txfCVV.text!.trimmed, forKey: "cvc")
            para.updateValue(txfNameCard.text!.trimmed, forKey: "name_on_card")
          
          
       }
        
        para.updateValue(userType == .personal ? switchPrivate.isOn : true, forKey: "is_private")
        guard error.isEmpty else { return }
        
        let items = socialMedias.filter({$0.username?.isEmpty == false || $0.username != nil})
        print(items)
        if !items.isEmpty {
            for item in items {
                switch item.type {
                case .facebook:
                    para.updateValue(item.username ?? "", forKey: "facebook")
                    para.updateValue(item.isPrivateValue, forKey: "facebook_status")
                case .instagram:
                    para.updateValue(item.username ?? "", forKey: "insta")
                    para.updateValue(item.isPrivateValue, forKey: "insta_status")
                case .linkedin:
                    para.updateValue(item.username ?? "", forKey: "link")
                    para.updateValue(item.isPrivateValue, forKey: "link_status")
                case .twitter:
                    para.updateValue(item.username ?? "", forKey: "tw")
                    para.updateValue(item.isPrivateValue, forKey: "tw_statusm")
                case .website:
                    para.updateValue(item.username ?? "", forKey: "website")
                    para.updateValue(item.isPrivateValue, forKey: "website_status")
                default:
                    break
                }
            }
        }
      
        print(para)
        
        showSimpleHUD()
        if userType == .business{
            //registerBusiness
            if paymentType == .free{
                ManageAPI.shared.register(para) {[weak self] (uid, error) in
                    guard let self = self else { return }
                    self.hideLoading()
                    DispatchQueue.main.async {
                        guard let uid = uid else {
                            self.showErrorAlert(message: error)
                            return
                        }
                        self.delegate?.update(self.usernameTextField.text?.trimmed)
                        if self.paymentType == .free {
                            self.fetchUserInfo(userId: uid.string, username: userName, password: "")
                        } else {
                            let controller = CardInfomationViewController.instantiate(from: StoryboardName.authentication.rawValue)
                            controller.modalTransitionStyle = .crossDissolve
                            controller.modalPresentationStyle = .overFullScreen
                            controller.plan = self.plan
                            controller.uid = uid.string
                            controller.delegate = self
                            self.present(controller, animated: true, completion: nil)
                        }
                    }
                }
            }
            else{
                ManageAPI.shared.registerBusiness(para) {[weak self] (uid, error) in
                    guard let self = self else { return }
                    self.hideLoading()
                    DispatchQueue.main.async {
                        guard let uid = uid else {
                            self.showErrorAlert(message: error)
                            return
                        }
                        self.delegate?.update(self.usernameTextField.text?.trimmed)
                        self.fetchUserInfo(userId: uid.string, username: userName, password: "")
                        
                    }
                }
            }
           
        }
        else{
            ManageAPI.shared.register(para) {[weak self] (uid, error) in
                guard let self = self else { return }
                self.hideLoading()
                DispatchQueue.main.async {
                    guard let uid = uid else {
                        self.showErrorAlert(message: error)
                        return
                    }
                    self.delegate?.update(self.usernameTextField.text?.trimmed)
                    if self.paymentType == .free {
                        self.fetchUserInfo(userId: uid.string, username: userName, password: "")
                    } else {
                        let controller = CardInfomationViewController.instantiate(from: StoryboardName.authentication.rawValue)
                        controller.modalTransitionStyle = .crossDissolve
                        controller.modalPresentationStyle = .overFullScreen
                        controller.plan = self.plan
                        controller.uid = uid.string
                        controller.delegate = self
                        self.present(controller, animated: true, completion: nil)
                    }
                }
            }
        }
       
    }
    @IBAction func doLogin(_ sender: Any) {
        popToLoginPage()
    }
    
    @IBAction func loginAction(_ sender: Any) {
        //popToLoginPage()
        if isNexStep{
            isNexStep = false
            step1.isHidden = false
            step2.isHidden = true
            scrollPage.setContentOffset(.zero, animated: true)
        }
        else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func doState(_ sender: Any) {
        errorStateLabel.showError(false)
        stateDropDown.show()
    }
    
    @IBAction func didSelectPaymentTypeButton(_ sender: UIButton) {
        //paymentType = sender.tag == 0 ? .free : .premium
//        if paymentType == .free{
//            signupButton.setTitle("JOIN CIRCLECUE", for: .normal)
//        }
//        else{
//            signupButton.setTitle("JOIN VIP CIRCLECUE", for: .normal)
//        }
        
        if sender.tag == 0{
            paymentType = .free
            stackCard.isHidden = true
            stackPricePackage.isHidden = true
        }
        else{
            paymentType = .premium
            stackPricePackage.isHidden = false
            if userType == .business{
                stackCard.isHidden = false
            }
            else{
                stackCard.isHidden = true
            }
        }
    }
    
    @IBAction func didSelectPersionalPrice(_ sender: UIButton) {
        //personalPricePerMonth = sender.tag == 0 ? true : false
       
    }
    
    @IBAction func didSelectBusinessPrice(_ sender: UIButton) {
       // businessPricePerMonth = sender.tag == 0 ? true : false
    }
    @IBAction func doCheckBenefit(_ sender: Any) {
        //paymentType = .premium
    }
   
    @IBAction func doNextStep2(_ sender: Any) {
        var isValid = true
        if userType == .business && paymentType != .free{
            if txfCardNumber.text!.trimmed.isEmpty{
                errorCardNumberLabel.showError(true, "Card Number is required.")
                isValid = false
            }
            else{
                errorCardNumberLabel.showError(false)
            }
            
            if txfMonth.text!.trimmed.isEmpty && txfYear.text!.trimmed.isEmpty{
                errorMonthLabel.showError(true, "Expiry Card is required.")
            }
            else{
                errorMonthLabel.showError(false)
            }
            
            if txfCVV.text!.trimmed.isEmpty{
                errorCVVLabel.showError(true, "CVV is required.")
            }
            else{
                errorCVVLabel.showError(false)
            }
            
            if txfNameCard.text!.trimmed.isEmpty{
                errorCardNameLabel.showError(true, "Card Name is required.")
            }

            else{
                errorCardNameLabel.showError(false)
            }
            
           
        }
        
        if userType == .personal{
            if let firstName = txfFirstName.text?.trimmed, !firstName.isEmpty {
                lblErrorFirstName.showError(false)
                
            } else {
                lblErrorFirstName.showError(true, ErrorMessage.firstNameIsEmpty.rawValue)
                isValid = false
            }
            
            if let lastName = txfLastName.text?.trimmed, !lastName.isEmpty {
                lblErrorLastName.showError(false)
            } else {
                lblErrorLastName.showError(true, ErrorMessage.lastNameIsEmpty.rawValue)
                isValid = false
            }
        }
        else{
            if let businessName = txfBussinessName.text?.trimmed, !businessName.isEmpty {
                lblErorBusinessName.showError(false)
             
            } else {
                lblErorBusinessName.showError(true, ErrorMessage.businessNameEmpty.rawValue)
                isValid = false
            }
        }
        if let username = usernameTextField.text?.trimmed, !username.isEmpty {
            usernameErrorLabel.showError(false)
        } else {
            usernameErrorLabel.showError(true, ErrorMessage.usernameIsEmpty.rawValue)
            isValid = false
        }
        
        if let email = emailTextField.text?.trimmed, !email.isEmpty {
            if email.isValidEmail() {
                emailErrorLabel.showError(false)
            } else {
                emailErrorLabel.showError(true, ErrorMessage.emailInvalid.rawValue)
                isValid = false
            }
        } else {
            emailErrorLabel.showError(true, ErrorMessage.emailIsEmpty.rawValue)
            isValid = false
        }
        
        if let password = passwordTextFiled.text, !password.isEmpty {
            if password.count < 4{
                passwordErrorLabel.showError(true, "Password must be at least 4 characters.")
                isValid = false
            }
            else{
            }
        } else {
            isValid = false
            passwordErrorLabel.showError(true, "Password is required.")
        }
        
        if let phoneNumber = phoneNumberTextField.trimmedText, !phoneNumber.isEmpty {
            phoneNumberErrorLabel.showError(false)
        }
        if isValid{
            self.view.endEditing(true)
            isNexStep = true
            scrollPage.setContentOffset(.zero, animated: true)
            step1.isHidden = true
            step2.isHidden = false
            
        }
    }
}
extension RegisterViewController: SubscrViewControllerDelegate{
    func didTapSelectPayment(month: Bool) {
        if userType == .personal{
            personalPricePerMonth = month
            stackCard.isHidden = true
        }
        else{
            businessPricePerMonth = month
            stackCard.isHidden = false
            
        }
        paymentType = .premium
        
    }
}
extension RegisterViewController {
    
    private func showSuccessAlert(title: String? = "Successful!", message: String?){
        let newMessage = message?.replacingOccurrences(of: "<br>", with: "\n").trimmed
        let titleAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.myriadProSemiBold(ofSize: 17), .foregroundColor: UIColor.black]
        let messageAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.myriadProRegular(ofSize: 14), .foregroundColor: UIColor.black]
        
        let titleString = NSAttributedString(string: title ?? "", attributes: titleAttribute)
        let messageString = NSAttributedString(string: newMessage ?? "", attributes: messageAttribute)
        
        let alertController = UIAlertController(title: title, message: newMessage, preferredStyle: .alert)
        alertController.setValue(titleString, forKey: "attributedTitle")
        alertController.setValue(messageString, forKey: "attributedMessage")
        
        let closeAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.popToLoginPage()
        }
        alertController.addAction(closeAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func popToLoginPage() {
        if let loginVC = navigationController?.viewControllers.first(where: {$0 is LoginVC}) {
            navigationController?.popToViewController(loginVC, animated: true)
        } else {
            if var viewControllers = self.navigationController?.viewControllers {
                viewControllers.insert(LoginVC.instantiate(from: StoryboardName.authentication.rawValue), at: 1)
                self.navigationController?.viewControllers = viewControllers
                self.navigationController?.popViewController(animated: true)
                return
            }
            self.navigationController?.setViewControllers([LoginVC.instantiate(from: StoryboardName.authentication.rawValue)], animated: true)
        }
    }
    
    private func resetErrorMessage() {
        usernameErrorLabel.text = nil
        emailErrorLabel.text = nil
        phoneNumberErrorLabel.text = nil
        cityErrorLabel.text = nil
        titleErrorLabel.text = nil
        bioErrorLabel.text = nil
        passwordErrorLabel.text = nil
        errorLabelUrlBusiness.text = nil
        errorUrlPersonal.text = nil
        lblErrorPhoto.text = nil
        errorYearLabel.text = nil
        errorMonthLabel.text = nil
        errorCardNameLabel.text = nil
        errorCardNumberLabel.text = nil
        errorCVVLabel.text = nil
    }
    
    private func setupUI() {
        btnMonth.isSelected = true
        btnAnanul.isSelected = false
        accountTypeView.isHidden = !AppSettings.shared.showPurchaseView
        stackCard.isHidden = true
        stackPricePackage.isHidden = true
        lblErrorPhoto.numberOfLines = 0
        bioTextView.text = nil
        userType = .personal
        usernameErrorLabel.text = nil
        emailErrorLabel.text = nil
        phoneNumberErrorLabel.text = nil
        cityErrorLabel.text = nil
        titleErrorLabel.text = nil
        bioErrorLabel.text = nil
        passwordErrorLabel.text = nil
        lblErrorLastName.text = nil
        lblErrorFirstName.text = nil
        lblErorBusinessName.text = nil
        errorLabelUrlBusiness.text = nil
        errorUrlPersonal.text = nil
        errorCountryLabel.text = nil
        errorStateLabel.text = nil
        errorYearLabel.text = nil
        errorMonthLabel.text = nil
        errorCardNameLabel.text = nil
        errorCardNumberLabel.text = nil
        errorCVVLabel.text = nil
        
        usernameTextField.tintColor = UIColor.black
        emailTextField.tintColor = UIColor.black
        phoneNumberTextField.tintColor = UIColor.black
        cityTextField.tintColor = UIColor.black
        titleTextField.tintColor = UIColor.black
        bioTextView.tintColor = UIColor.black
        passwordTextFiled.tintColor = UIColor.black
        bioTextView.delegate = self
        txfFirstName.tintColor = UIColor.black
        txfLastName.tintColor = UIColor.black
        txfBussinessName.tintColor = UIColor.black
        usernameTextField.delegate = self
        emailTextField.delegate = self
        
        txfUrlBusiness.tintColor = UIColor.black
        txfUrlBusiness.delegate = self
        
        txfUrlPersonal.tintColor = UIColor.black
        txfUrlPersonal.delegate = self
        
        txfCardNumber.tintColor = UIColor.black
        txfNameCard.tintColor = UIColor.black
        txfCVV.tintColor = UIColor.black
        usernameTextField.addTarget(self, action: #selector(observerInformation(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(observerInformation(_:)), for: .editingChanged)
        phoneNumberTextField.addTarget(self, action: #selector(observerInformation(_:)), for: .editingChanged)
        cityTextField.addTarget(self, action: #selector(observerInformation(_:)), for: .editingChanged)
        titleTextField.addTarget(self, action: #selector(observerInformation(_:)), for: .editingChanged)
        passwordTextFiled.addTarget(self, action: #selector(observerInformation(_:)), for: .editingChanged)
        
        usernameTextField.addTarget(self, action: #selector(verify(_:)), for: .editingDidEnd)
        emailTextField.addTarget(self, action: #selector(verify(_:)), for: .editingDidEnd)
        passwordTextFiled.addTarget(self, action: #selector(verify(_:)), for: .editingDidEnd)
        txfFirstName.addTarget(self, action: #selector(observerInformation(_:)), for: .editingChanged)
        txfLastName.addTarget(self, action: #selector(observerInformation(_:)), for: .editingChanged)
        txfBussinessName.addTarget(self, action: #selector(observerInformation(_:)), for: .editingChanged)
        txfUrlPersonal.addTarget(self, action: #selector(observerInformation(_:)), for: .editingChanged)
        txfUrlBusiness.addTarget(self, action: #selector(observerInformation(_:)), for: .editingChanged)
        
        txfCardNumber.addTarget(self, action: #selector(observerInformation(_:)), for: .editingChanged)
        txfNameCard.addTarget(self, action: #selector(observerInformation(_:)), for: .editingChanged)
        txfCVV.addTarget(self, action: #selector(observerInformation(_:)), for: .editingChanged)
        
        pickerController = ImagePicker(presentationController: self, delegate: self, mediaTypes: [.image], allowsEditing: true, iCloud: true)
        
        
        viewPhotos.layer.cornerRadius = 10
        viewPhotos.layer.borderWidth = 1.0
        viewPhotos.layer.borderColor = UIColor(hex: "D3D3D3").cgColor
        
        viewSocial.layer.cornerRadius = 10
        viewSocial.layer.borderWidth = 1.0
        viewSocial.layer.borderColor = UIColor(hex: "D3D3D3").cgColor
        lblErrorPhoto.text = nil
        
        step1.isHidden = false
        step2.isHidden = true
        ManageAPI.shared.currentcountry { success, currentcountry in
            if let currentcountry = currentcountry{
                self.txfCountry.text = currentcountry.0
                if !currentcountry.1.isEmpty {
                    self.countryId = currentcountry.1
                    ManageAPI.shared.getStates(countryId: self.countryId) { success, dict in
                        self.arrStates.removeAll()
                        if let dict = dict {
                            self.arrStates = dict
                            self.stateDatasources.removeAll()
                            for sta in self.arrStates{
                                self.stateDatasources.append(sta.object(forKey: "name") as? String ?? "")
                            }
                            
                            print("self.stateDatasources-->",self.stateDatasources.count)
                            self.setupDropdown()
                        }
                    }
                }
            }
            
        }
        setupUIDropDownYearMonth()
    }
    
    
    private func setupDropdown() {
        stateDropDown.anchorView = viewState
        stateDropDown.dataSource = stateDatasources
        stateDropDown.bottomOffset = CGPoint(x: 0, y: viewState.frame.height + 2)
        stateDropDown.direction = .bottom
        stateDropDown.textFont = UIFont.myriadProRegular(ofSize: 16)
        stateDropDown.cellHeight = 40
        stateDropDown.animationduration = 0.2
        stateDropDown.backgroundColor = UIColor.white
        stateDropDown.selectionBackgroundColor = UIColor.yellow.withAlphaComponent(0.3)
        stateDropDown.dimmedBackgroundColor = UIColor.black.withAlphaComponent(0.3)
        stateDropDown.selectionAction = {[weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.txfState.text = self.stateDatasources[index]
            self.stateId = self.arrStates[index].object(forKey: "id") as? String ?? ""
        }
    }
    private func resetPaymentView() {
        paymentType = .free
    }
    
    @objc private func observerInformation(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            emailErrorLabel.showError(false)
        case passwordTextFiled:
            passwordErrorLabel.showError(false)
        case usernameTextField:
            usernameErrorLabel.showError(false)
        case phoneNumberTextField:
            phoneNumberErrorLabel.showError(false)
        case titleTextField:
            titleErrorLabel.showError(false)
       
        case txfFirstName:
            lblErrorFirstName.showError(false)
        case txfLastName:
            lblErrorLastName.showError(false)
        case txfBussinessName:
            lblErorBusinessName.showError(false)
        case txfUrlBusiness:
            errorLabelUrlBusiness.showError(false)
        case txfUrlPersonal:
            errorUrlPersonal.showError(false)
        case txfCardNumber:
            errorCardNumberLabel.showError(false)
        case txfNameCard:
            errorCardNameLabel.showError(false)
        case txfCVV:
            errorCVVLabel.showError(false)
        default:
            break
        }
    }
    
    @objc private func verify(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            guard let email = emailTextField.text?.trimmed, !email.isEmpty else { return }
            if !email.isValidEmail() {
                self.showAlert(title: "CircleCue", message: "Invalid email format.", buttonTitles: ["OK"], highlightedButtonIndex: nil) { _ in
                    self.emailTextField.becomeFirstResponder()
                }
            } else {
                verifyEmail(email: email)
            }
        case passwordTextFiled:
            guard let password = passwordTextFiled.text, !password.isEmpty else { return }
            if password.count < 4 {
                self.showAlert(title: "CircleCue", message: "Password must be at least 4 characters.", buttonTitles: ["OK"], highlightedButtonIndex: nil) { _ in
                    self.passwordTextFiled.becomeFirstResponder()
                }
            } else {
            }
            
        case usernameTextField:
            guard let username = usernameTextField.text?.trimmed, !username.isEmpty else { return }
            if username.count < 3 {
                self.showAlert(title: "CircleCue", message: "Username must at least 3 letters.", buttonTitles: ["OK"], highlightedButtonIndex: nil) { _ in
                    self.usernameTextField.becomeFirstResponder()
                }
            } else {
                verifyUserName(username: username)
            }
            
        default:
            break
        }
    }
    
    private func verifyEmail(email: String) {
        showSimpleHUD(text: "Verify Email...")
        ManageAPI.shared.verifyEmail(email: email) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let err = error {
                    self.emailErrorLabel.text = err.replacingOccurrences(of: "<br>", with: "\n").replacingOccurrences(of: "<BR>", with: "\n").trimmed
                    self.showErrorAlert(message: err)
                    return
                }
            }
        }
    }
    
    private func verifyUserName(username: String) {
        showSimpleHUD(text: "Verify Username...")
        ManageAPI.shared.verifyUsername(username: username) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let err = error {
                    self.usernameErrorLabel.text = err.replacingOccurrences(of: "<br>", with: "\n").replacingOccurrences(of: "<BR>", with: "\n").trimmed
                    self.showErrorAlert(message: err)
                    return
                }
            }
        }
    }
    
    private func fetchUserInfo(userId: String, username: String, password: String) {
        ManageAPI.shared.fetchUserInfo(userId) {[weak self] (user, error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let user = user {
                    ManageAPI.shared.updateUserLoginStatus(userId)
                    AppSettings.shared.currentUser = user
                    let user = UserLogin(userId: userId)
                    AppSettings.shared.userLogin = user
                    AppSettings.shared.saveLoginInfo(userId: userId, username: username, password: password)
                    self.wellComeNotification()
                    self.handleRegisterSuccess(userId: userId)
                    
                    return
                }
                self.showAlert(title: "Opps!", message: error)
            }
        }
    }
    
    private func setupTabelView() {
        tableView.register(UINib(nibName: "AddSocialTableViewCell", bundle: nil), forCellReuseIdentifier: "AddSocialTableViewCell")
        tableView.register(UINib(nibName: "WebsiteTableViewCell", bundle: nil), forCellReuseIdentifier: "WebsiteTableViewCell")
        tableView.register(UINib(nibName: "AddMoreLinkInformTableViewCell", bundle: nil), forCellReuseIdentifier: "AddMoreLinkInformTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableViewHeight.constant = 0.0
    }
    
    private func showUploadPicture(_ image: UIImage?) {
        guard let image = image else { return }
        self.uploadImage(image: image)
    }
    
    private func wellComeNotification(){
        ManageAPI.shared.welcomeNotification { error in
            LOG("\(String(describing: error))")
        }
    }
    private func handleRegisterSuccess(userId: String) {
        let controller = CircleFeedNewViewController.instantiate()
        //        controller.newUserRegister = true
        self.switchRootViewController(BaseNavigationController(rootViewController: controller))
        AppSettings.shared.updateToken {
            ManageAPI.shared.sendSignUpNotification(id: userId) { error in
                LOG("\(String(describing: error))")
            }
        }
    }
}

extension RegisterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return socialMedias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let social = socialMedias[indexPath.row]
        switch social.type {
        case .website:
//            let cell = tableView.dequeueReusableCell(withIdentifier: WebsiteTableViewCell.identifier, for: indexPath) as! WebsiteTableViewCell
//            cell.setup(socialMedia: socialMedias[indexPath.row])
//            cell.delegate = self
//            return cell
            let cell = tableView.dequeueReusableCell(withIdentifier: AddSocialTableViewCell.identifier, for: indexPath) as! AddSocialTableViewCell
            cell.setup(socialMedia: socialMedias[indexPath.row])
            cell.delegate = self
            return cell
        case.custom:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddMoreLinkInformTableViewCell.identifier, for: indexPath) as! AddMoreLinkInformTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddSocialTableViewCell.identifier, for: indexPath) as! AddSocialTableViewCell
            cell.setup(socialMedia: socialMedias[indexPath.row])
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row < socialMedias.count else {
            return 0
        }
        let social = socialMedias[indexPath.row]
        if social.type == .custom {
            return AddMoreLinkInformTableViewCell.cellHeight
        }
        
        return AddSocialTableViewCell.cellHeight
    }
}

// MARK: - UITextViewDelegate
extension RegisterViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if url.absoluteString == Authentication.term.urlString {
            showWebViewContent(urlString: Authentication.term.urlString)
        } else if url.absoluteString == Authentication.pp.urlString {
            showWebViewContent(urlString: Authentication.pp.urlString)
        }
        return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let maxLength = 300
        let maxReplacementLength = min(range.length, maxLength - range.location)
        let replacementRange = NSRange(location: range.location, length: maxReplacementLength)
        let result = NSString(string: (textView.text ?? "")).replacingCharacters(in: replacementRange, with: text)
        
        if result.count <= maxLength && range.length <= maxLength - range.location  {
            return true
        }
        textView.text = String(result[..<result.index(result.startIndex, offsetBy: min(result.count, maxLength))])
        
        return false
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension RegisterViewController: RegisterViewControllerDelegate {
    func update(_ socialMedia: SocialMediaObj?) {
        guard let social = socialMedia, let index = socialMedias.firstIndex(where: {$0.type.rawValue == social.type.rawValue}) else { return }
        socialMedias[index] = social
    }
    
    func socialLogin(_ socialMedia: SocialMediaObj) {
        switch socialMedia.type {
        case .facebook:
            LoginManager().logOut()
            getIdWithFacebook()
        case .instagram:
            signInWithInstagram()
        case .linkedin:
            signInWithLinkedIn()
        case .twitter:
            signInWithTwitter {[weak self] (username) in
                guard let self = self else { return}
                guard let username = username, let index = self.socialMedias.firstIndex(where: {$0.type == .twitter}) else { return }
                self.socialMedias[index].username = username
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
            }
        default:
            break
        }
    }
}

extension RegisterViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        print(image as Any)
        self.showUploadPicture(image)
    }
    
    func didSelect(videoURL: URL?) {
        print(videoURL as Any)
    }
    
    private func uploadImage(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        let fileName = "\(randomString()).jpg"
        showSimpleHUD(text: "Uploading...")
        ManageAPI.shared.uploadFile(file: data, fileName) {[weak self] (path, error) in
            guard let self = self else { return }
            if let path = path {
                switch indexPhoto {
                case 0:
                    
                    btnPhoto1.layer.cornerRadius = btnPhoto1.frame.size.height/2
                    btnPhoto1.layer.masksToBounds = true
                    btnPhoto1.setImage(image, for: .normal)
                    self.imageUploaded = true
                    self.lblErrorPhoto.showError(false)
                    self.picturePath = path
                    self.showSuccessHUD(text: "Your file has been uploaded.")
                    break
                case 1:
                    
                    btnPhoto2.layer.cornerRadius = btnPhoto2.frame.size.height/2
                    btnPhoto2.layer.masksToBounds = true
                    self.urlAvatar2 = path
                    self.lblErrorPhoto.showError(false)
                    btnPhoto2.setImage(image, for: .normal)
                    self.showSuccessHUD(text: "Your file has been uploaded.")
                    break
                case 2:
                    btnPhoto3.layer.cornerRadius = btnPhoto3.frame.size.height/2
                    btnPhoto3.layer.masksToBounds = true
                    self.urlAvatar3 = path
                    self.lblErrorPhoto.showError(false)
                    btnPhoto3.setImage(image, for: .normal)
                    self.showSuccessHUD(text: "Your file has been uploaded.")
                    break
                default:
                    break
                }
                
                return
            }
            self.showErrorHUD(text: error)
        }
    }
}

extension RegisterViewController {
    
    func getIdWithFacebook() {
        let loginManager = LoginManager()
        let permissions = ["public_profile", "email", "user_link"]
        loginManager.logIn(permissions: permissions, from: self) { (result: LoginManagerLoginResult?, error: Error?) in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(title: "Oops!", message: error.localizedDescription)
                    return
                }
            }
            
            guard let token = result?.token else {
                return
            }
            print(token.tokenString)
            self.getFacebookInfo(token: token.tokenString)
        }
    }
    
    private func getFacebookInfo(token: String?) {
        self.showSimpleHUD()
        let parameters = ["fields": "id, email, name, first_name, last_name, age_range, link, gender, locale, timezone, picture, updated_time, verified"]
        GraphRequest(graphPath: "me", parameters: parameters, tokenString: token, version: nil, httpMethod: .get).start { (connection, result, error) in
            if let error = error {
                self.hideLoading()
                self.showAlert(title: "Oops!", message: error.localizedDescription)
                return
            }
            self.hideLoading()
            if let info = result as? [String : AnyObject], let link = info["link"] as? String {
                print(result as Any)
                if let index = self.socialMedias.firstIndex(where: {$0.type == .facebook}) {
                    self.socialMedias[index].username = link.replacingOccurrences(of: SocialMedia.facebook.domain ?? "", with: "")
                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                    }
                }
            }
        }
    }
}

extension RegisterViewController: CardInfomationDelegate {
    func didCreateSubscribe(status: Bool, uid: String) {
        self.fetchUserInfo(userId: uid, username: "", password: "")
    }
}
extension String {
    func attributedStringWithColor(_ strings: [String], color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for string in strings {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
        
        guard let characterSpacing = characterSpacing else {return attributedString}
        
        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
}
