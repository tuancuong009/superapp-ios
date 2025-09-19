//
//  PaymentSpin2WinVC.swift
//  CircleCue
//
//  Created by QTS Coder on 18/04/2023.
//

import UIKit
import Lottie
import Alamofire
struct PAYMENT_TYPE{
    static let CashID =  0
    static let Paypal =  1
    static let CompanyCheck =  2
}
class PaymentSpin2WinVC: BaseViewController {
    
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var txfMobile: UITextField!
    @IBOutlet weak var lblMobileError: UILabel!
    @IBOutlet weak var txfFullName: UITextField!
    @IBOutlet weak var lblFullNameError: UILabel!
    @IBOutlet weak var txfAddress: UITextField!
    @IBOutlet weak var lblAddressError: UILabel!
    @IBOutlet weak var txfCity: UITextField!
    @IBOutlet weak var lblCityError: UILabel!
    @IBOutlet weak var imgBG: UIImageView!
    var price = ""
    @IBOutlet weak var txfState: SearchTextField!
    @IBOutlet weak var lblStateError: UILabel!
    @IBOutlet weak var txfZip: UITextField!
    @IBOutlet weak var viewContent: UIScrollView!
    @IBOutlet weak var lblZipEror: UILabel!
    @IBOutlet weak var btnCashApp: UIButton!
    @IBOutlet weak var btnPaypal: UIButton!
    @IBOutlet weak var btnCompanyCheck: UIButton!
    @IBOutlet weak var txfPayPalCash: UITextField!
    @IBOutlet weak var lblPayPalCashError: UILabel!
    @IBOutlet weak var viewPaypalCash: UIView!
    @IBOutlet weak var heightPayPalCash: NSLayoutConstraint!
    @IBOutlet weak var spaceTopPayPalCash: NSLayoutConstraint!
    var indexSelect = -1
    var spin_id = ""
    let states = ["Alaska", "Alabama", "Arkansas", "American Samoa", "Arizona", "California", "Colorado", "Connecticut", "District of Columbia", "Delaware", "Florida", "Georgia", "Guam", "Hawaii", "Iowa", "Idaho", "Illinois", "Indiana", "Kansas", "Kentucky", "Louisiana", "Massachusetts", "Maryland", "Maine", "Michigan", "Minnesota", "Missouri", "Mississippi", "Montana", "North Carolina", "North Dakota", "Nebraska", "New Hampshire", "New Jersey", "New Mexico", "Nevada", "New York", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Virginia", "Virgin Islands", "Vermont", "Washington", "Wisconsin", "West Virginia", "Wyoming"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblWelcome.text = "Congratulations"
        self.lblPrice.text = "Yow won: \(price)"
        self.resetUI()
        selectRadio()
    }
    
    
    @IBAction func doClose(_ sender: Any) {
        self.showAlert(title: "CircleCue", message: "Do you want to close?", buttonTitles: ["Yes", "No"], highlightedButtonIndex: 1) { index in
            if index == 0 {
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBAction func doSelect(_ sender: Any) {
        if let btn = sender as? UIButton{
            indexSelect = btn.tag
            selectRadio()
        }
    }
    
    private func saveWinner(){
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        var param: Parameters = [:]
        param["user_id"] = userId
        param["mobile"] = txfMobile.text!.trimmed
        param["name"] = txfFullName.text!.trimmed
        param["address"] = txfAddress.text!.trimmed
        param["city"] = txfCity.text!.trimmed
        param["state"] = txfState.text!.trimmed
        param["zipcode"] = txfZip.text!.trimmed
        param["price"] = price.replacingOccurrences(of: "$", with: "")
        param["spin_id"] = spin_id
        if indexSelect == PAYMENT_TYPE.CashID{
            param["cash_appid"] = txfPayPalCash.text!.trimmed
        } else if indexSelect == PAYMENT_TYPE.Paypal{
            param["paypay_emailid"] = txfPayPalCash.text!.trimmed
        }else{
            //Company check
            param["com_check"] = "1"
        }
        
        self.view.isUserInteractionEnabled = false
        self.showSimpleHUD()
        ManageAPI.shared.addWinner(param) { error in
            self.view.isUserInteractionEnabled = true
            self.hideLoading()
         
            DispatchQueue.main.async {
                if let error = error {
                    self.hideLoading()
                    self.showErrorAlert(title: "Oops!", message: error)
                    return
                }
                self.showAlert(title: "Thanks for submitting.", message: "Payment will be sent immediatelly.", buttonTitles: ["OK"], highlightedButtonIndex: nil) { _ in
                    
                }
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBAction func doSelectState(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for item in states{
            let action = UIAlertAction(title: item, style: .default) { action in
                self.txfState.text = item
            }
            alert.addAction(action)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = []
        }
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    @IBAction func doSave(_ sender: Any) {
        var error = false
        if let mobile = txfMobile.text?.trimmed, !mobile.isEmpty {
            lblMobileError.showError(true, " ")
        } else {
            lblMobileError.showError(true, ErrorMessage.paymentMobilephoneEmpty.rawValue)
            error = true
        }
        
        if let fullName = txfFullName.text?.trimmed, !fullName.isEmpty {
            lblFullNameError.showError(true, " ")
        } else {
            lblFullNameError.showError(true, ErrorMessage.paymentFullNameEmpty.rawValue)
            error = true
        }
        
        if let address = txfAddress.text?.trimmed, !address.isEmpty {
            lblAddressError.showError(true, " ")
        } else {
            lblAddressError.showError(true, ErrorMessage.paymentAddressEmpty.rawValue)
            error = true
        }
        if let city = txfCity.text?.trimmed, !city.isEmpty {
            lblCityError.showError(true, " ")
        } else {
            lblCityError.showError(true, ErrorMessage.paymentCityEmpty.rawValue)
            error = true
        }
        if let state = txfState.text?.trimmed, !state.isEmpty {
            lblStateError.showError(true, " ")
        } else {
            lblStateError.showError(true, ErrorMessage.paymentStateEmpty.rawValue)
            error = true
        }
        if let zip = txfZip.text?.trimmed, !zip.isEmpty {
            lblZipEror.showError(true, " ")
        } else {
            lblZipEror.showError(true, ErrorMessage.paymentZipEmpty.rawValue)
            error = true
        }
        
        if indexSelect == -1{
            lblPayPalCashError.showError(true, ErrorMessage.selectPayPalSelect.rawValue)
            error = true
        }
        else if (indexSelect == 0 || indexSelect == 1){
            if indexSelect == 0{
                if let paypalCash = txfPayPalCash.text?.trimmed, !paypalCash.isEmpty {
                    lblPayPalCashError.showError(true, " ")
                } else {
                    lblPayPalCashError.showError(true, ErrorMessage.paymentCashAppIdEmpty.rawValue)
                    error = true
                }
            }
            else{
                if let paypalEmail = txfPayPalCash.text?.trimmed, !paypalEmail.isEmpty {
                    lblPayPalCashError.showError(true, " ")
                } else {
                    lblPayPalCashError.showError(true, ErrorMessage.paymentPaypalEmailEmpty.rawValue)
                    error = true
                }
                
                if let paypalEmail = txfPayPalCash.text?.trimmed, !paypalEmail.isEmpty, txfPayPalCash.hasValidEmail {
                    lblPayPalCashError.showError(true, " ")
                } else {
                    lblPayPalCashError.showError(true, ErrorMessage.paymentPaypalEmailInvalid.rawValue)
                    error = true
                }
            }
        }
        guard !error else { return }
        self.saveWinner()
    }
    
    private func resetUI(){
        lblMobileError.showError(true, " ")
        lblPayPalCashError.showError(true, " ")
        lblFullNameError.showError(true, " ")
        lblAddressError.showError(true, " ")
        lblCityError.showError(true, " ")
        lblStateError.showError(true, " ")
        lblZipEror.showError(true, " ")
        imgBG.layer.cornerRadius = 12
        imgBG.layer.masksToBounds = true
    }
    
    private func selectRadio(){
        if indexSelect == -1{
            btnPaypal.setImage(UIImage.init(named: "ic_radio_white"), for: .normal)
            btnCashApp.setImage(UIImage.init(named: "ic_radio_white"), for: .normal)
            btnCompanyCheck.setImage(UIImage.init(named: "ic_radio_white"), for: .normal)
            viewPaypalCash.isHidden = true
            heightPayPalCash.constant = 0
            spaceTopPayPalCash.constant = 0
            lblPayPalCashError.showError(true, " ")
        }
        else if indexSelect == 2{
            btnPaypal.setImage(UIImage.init(named: "ic_radio_white"), for: .normal)
            btnCashApp.setImage(UIImage.init(named: "ic_radio_white"), for: .normal)
            btnCompanyCheck.setImage(UIImage.init(named: "ic_radio_white_selected"), for: .normal)
            viewPaypalCash.isHidden = true
            heightPayPalCash.constant = 0
            spaceTopPayPalCash.constant = -10
            lblPayPalCashError.showError(true, " ")
        }
        else if indexSelect == 0{
            btnPaypal.setImage(UIImage.init(named: "ic_radio_white"), for: .normal)
            btnCashApp.setImage(UIImage.init(named: "ic_radio_white_selected"), for: .normal)
            btnCompanyCheck.setImage(UIImage.init(named: "ic_radio_white"), for: .normal)
            viewPaypalCash.isHidden = false
            heightPayPalCash.constant = 44
            spaceTopPayPalCash.constant = 10
            lblPayPalCashError.showError(true, " ")
            txfPayPalCash.text = ""
            txfPayPalCash.placeholder = "Cash App ID"
        }
        else{
            btnPaypal.setImage(UIImage.init(named: "ic_radio_white_selected"), for: .normal)
            btnCashApp.setImage(UIImage.init(named: "ic_radio_white"), for: .normal)
            btnCompanyCheck.setImage(UIImage.init(named: "ic_radio_white"), for: .normal)
            viewPaypalCash.isHidden = false
            heightPayPalCash.constant = 44
            spaceTopPayPalCash.constant = 10
            lblPayPalCashError.showError(true, " ")
            txfPayPalCash.placeholder = "Pay Pal Email ID"
        }
    }
}

extension PaymentSpin2WinVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txfMobile{
            lblMobileError.showError(true, " ")
        }
        else if textField == txfFullName{
            lblFullNameError.showError(true, " ")
        }
        else if textField == txfAddress{
            lblAddressError.showError(true, " ")
        }
        else if textField == txfCity{
            lblCityError.showError(true, " ")
        }
        else if textField == txfState{
            lblStateError.showError(true, " ")
        }
        else if textField == txfZip{
            lblZipEror.showError(true, " ")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfMobile{
            
        }
        else if textField == txfFullName{
            txfAddress.becomeFirstResponder()
        }
        else if textField == txfAddress{
            txfCity.becomeFirstResponder()
        }
        else if textField == txfCity{
            txfState.resignFirstResponder()
        }
        else if textField == txfState{
            txfZip.resignFirstResponder()
        }
        else if textField == txfZip{
            txfMobile.resignFirstResponder()
        }
        return true
    }
}
