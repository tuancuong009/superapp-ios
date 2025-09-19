//
//  LoginVC.swift
//  Matcheron
//
//  Created by QTS Coder on 6/9/24.
//

import UIKit
import Alamofire
import SafariServices
import FBSDKLoginKit
import GoogleSignIn
class LoginMatcheronVC: BaseMatcheronViewController {

    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var btnShowHidePasswprd: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doPrivacy(_ sender: Any) {
        let vc = PrivacyViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doTerm(_ sender: Any) {
        let vc = HelpMatcheronViewController()
        vc.isHelp = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doShowHidePassword(_ sender: Any) {
        btnShowHidePasswprd.isSelected = !btnShowHidePasswprd.isSelected
        if btnShowHidePasswprd.isSelected{
            txfPassword.isSecureTextEntry = false
        }
        else{
            txfPassword.isSecureTextEntry = true
        }
    }
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func doApple(_ sender: Any) {
        self.performSignInWithApple()
    }
    
    @IBAction func doFacebook(_ sender: Any) {
        self.signInWithFacebook()
    }
    @IBAction func doGoogle(_ sender: Any) {
        self.signInWithGoogle()
    }
    @IBAction func doLogin(_ sender: Any) {
        let email = txfEmail.text!.trimText()
        let password = txfPassword.text!
        if self.validateForm().isEmpty{
            self.showBusy()
            let param = ["email": email, "password": password]
            APIHelper.shared.loginUser(param: param) { success, erro in
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
        else{
            self.showAlertMessage(message: self.validateForm())
        }
       
    }
    
    func validateForm()-> String{
        let email = txfEmail.text!.trimText()
        let password = txfPassword.text!
        if email.isEmpty{
            return "Email is required"
        }
        if !email.isValidEmail(){
            return "Email is invalid"
        }
        if password.isEmpty{
            return "Password is required"
        }
        return ""
    }
    @IBAction func doForgot(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doSignUp(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginMatcheronVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfEmail{
            txfPassword.becomeFirstResponder()
        }
        else if textField == txfPassword{
            txfPassword.resignFirstResponder()
        }
        return true
    }
}
