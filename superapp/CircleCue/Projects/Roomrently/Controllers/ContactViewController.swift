//
//  ContactViewController.swift
//  Roomrently
//
//  Created by QTS Coder on 16/08/2023.
//

import UIKit
import Alamofire
class ContactViewController: BaseRRViewController {

    @IBOutlet weak var txfFullName: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfMobile: UITextField!
    @IBOutlet weak var lblPlaceMessage: UILabel!
    @IBOutlet weak var tvMessage: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isCheckLogin(){
            getMyprofile()
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func doSubmit(_ sender: Any) {
        //You have successfully submitted your request.
        let fullname = txfFullName.text!.trimText()
        let email = txfEmail.text!.trimText()
        let phone = txfMobile.text!.trimText()
        let message = tvMessage.text!.trimText()
        if fullname.isEmpty{
            self.showAlertMessage(message: "Full Name is required")
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
        if phone.isEmpty{
            self.showAlertMessage(message: "Phone is required")
            return
        }
        if message.isEmpty{
            self.showAlertMessage(message: "Message is required")
            return
        }
        let param : Parameters = ["name": fullname ,"email": email, "msg": message, "phone": phone]
        self.showBusy()
        APIRoomrentlyHelper.shared.addContact(param) { success, erro in
            self.hideBusy()
            if success!{
                let alert = UIAlertController(title: APP_NAME,
                                              message: "You have successfully submitted your request.",
                                              preferredStyle: UIAlertController.Style.alert)
                let cancelAction = UIAlertAction(title: "Ok",
                                                 style: .default) { action in
                    APP_DELEGATE.initHome()
                }
                
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                if let erro = erro{
                    self.showAlertMessage(message: erro)
                }
            }
        }
    }
    
    @IBAction func doPhone(_ sender: Any) {
        if let url = URL(string: "tel://1833-773-6859"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    private func getMyprofile(){
        self.showBusy()
        APIRoomrentlyHelper.shared.getMyProfile { success, erro in
            self.hideBusy()
            if let erro = erro{
                self.updateUI(erro)
            }
        }
    }
    private func updateUI(_ dict: NSDictionary){
        self.txfFullName.text = (dict.object(forKey: "fname") as? String ?? "") + " " + (dict.object(forKey: "lname") as? String ?? "")
        self.txfEmail.text = dict.object(forKey: "email") as? String
        self.txfMobile.text = dict.object(forKey: "phone") as? String
    }
}
extension ContactViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       if textField == txfFullName{
            txfEmail.becomeFirstResponder()
        }
        else if textField == txfEmail{
            txfMobile.becomeFirstResponder()
        }
       
        return true
    }
}

extension ContactViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if textView == tvMessage{
            if textView.text!.trimText().isEmpty{
                lblPlaceMessage.isHidden = false
            }
            else {
                lblPlaceMessage.isHidden = true
            }
        }
    }
}
