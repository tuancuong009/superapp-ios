//
//  LoginViewController.swift
//  Roomrently
//
//  Created by QTS Coder on 13/09/2023.
//

import UIKit
import Alamofire
import LGSideMenuController
class LoginViewController: BaseRRViewController {

    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var btnShowPassword: UIButton!
    @IBOutlet weak var txfEmailAndUserName: UITextField!
    var isLogin = false
    var isSecurePassword = true
    override func viewDidLoad() {
        super.viewDidLoad()
        if isLogin{
            btnMenu.setImage(UIImage.init(named: "btn_backrr"), for: .normal)
        }
        btnShowPassword.setImage(isSecurePassword ? UIImage.init(named: "eye_closed") : UIImage.init(named: "eye_opened"), for: .normal)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doForogt(_ sender: Any) {
        let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordRRVC") as! ForgotPasswordRRVC
        vc.tapSuccess = { [self] in
            showAlertMessage(message: "Your password has been reset, please check your email.")
        }
        self.navigationController?.pushViewController(vc, animated: true)
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
    @IBAction func doSubmit(_ sender: Any) {
        let emailOrUserName = txfEmailAndUserName.text!.trimText()
        let password = txfPassword.text!
        if emailOrUserName.isEmpty{
            self.showAlertMessage(message: "Email or Username is required")
            return
        }
        if password.isEmpty{
            self.showAlertMessage(message: "Password is required")
            return
        }
        self.showBusy()
        let param: Parameters = ["email": emailOrUserName, "password": password]
        APIRoomrentlyHelper.shared.loginUser(param) { success, erro in
            self.hideBusy()
            if success!{
                APP_DELEGATE.initHome()
            }
            else{
                if let erro = erro{
                    self.showAlertMessage(message: erro)
                }
            }
        }
    }
    @IBAction func doMenuApp(_ sender: Any) {
        if !self.isLogin{
            self.sideMenuController?.showLeftView(animated: true)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func doShowPassword(_ sender: Any) {
        isSecurePassword = !isSecurePassword
        if isSecurePassword{
            txfPassword.isSecureTextEntry = true
        }
        else{
            txfPassword.isSecureTextEntry = false
        }
        btnShowPassword.setImage(isSecurePassword ? UIImage.init(named: "eye_closed") : UIImage.init(named: "eye_opened"), for: .normal)
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfEmailAndUserName{
            txfPassword.becomeFirstResponder()
        }
        else{
            txfPassword.resignFirstResponder()
        }
        return true
    }
}
