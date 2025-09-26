//
//  LoginSuperAppViewController.swift
//  SuperApp
//
//  Created by QTS Coder on 9/5/25.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import LGSideMenuController
class LoginSuperAppViewController: BaseVC {

    @IBOutlet weak var txfEmail: CustomTextField!
    @IBOutlet weak var txfPassword: CustomTextField!
    @IBOutlet weak var btnMenu: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnMenu.isHidden = AppSettings.shared.isUseFirebase
        // Do any additional setup after loading the view.
    }

    @IBAction func doMenu(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doForgotPassword(_ sender: Any) {
        let vc = ForgotSuperViewController.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            txfPassword.isSecureTextEntry = false
        }
        else{
            txfPassword.isSecureTextEntry = true
        }
    }
    @IBAction func doLogin(_ sender: Any) {
        let email = txfEmail.text!.trimmed
        let password = txfPassword.text!
      
        if email.isEmpty{
            self.showAlert(title: APP_NAME, message: "Email is required")
            return
        }
        if !email.isValidEmail(){
            self.showAlert(title: APP_NAME, message: "Invalid email")
            return
        }
        if password.isEmpty{
            self.showAlert(title: APP_NAME, message: "Password is required")
            return
        }
        
       
        self.view.endEditing(true)
        self.showBusy()
        if AppSettings.shared.isUseFirebase{
            loginUser(email: email, password: password)
        }
        else{
            let param = [ "email": email, "password": password]
            ManageAPI.shared.logInAccountSuperApp(param) { user, error in
                self.hideBusy()
                if let user = user{
                    if let Status = user.value(forKey: "Status") as? Bool , !Status{
                        self.showAlert(title: APP_NAME, message: user.value(forKey: "Message") as? String)
                    }
                    else{
                        if let data = user.object(forKey: "data") as? NSDictionary{
                            if let id = data.value(forKey: "id") as? Int{
                                UserDefaults.standard.set("\(id)", forKey: USER_ID_SUPER_APP)
                                UserDefaults.standard.synchronize()
                            }
                            else if let id = data.value(forKey: "id") as? String{
                                UserDefaults.standard.set("\(id)", forKey: USER_ID_SUPER_APP)
                                UserDefaults.standard.synchronize()
                            }
                            APP_DELEGATE.initSuperApp()
                        }
                        else{
                            self.showAlert(title: APP_NAME, message: user.value(forKey: "Message") as? String)
                        }
                       
                    }
                }
                else{
                    self.showAlert(title: APP_NAME, message: error?.msg)
                }
            }
        }
      
    }
    
    func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            self.hideBusy()
            if let error = error {
                self.showAlert(title: APP_NAME, message: error.localizedDescription)
                return
            }
            guard let user = result?.user else { return }
            UserDefaults.standard.set(user.uid, forKey: USER_ID_SUPER_APP)
            UserDefaults.standard.synchronize()
            APP_DELEGATE.initSuperApp()
        }
    }
    
    @IBAction func doSignUp(_ sender: Any) {
        let vc = RegisterSuperAppViewController.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func doPrivacy(_ sender: Any) {
    }
    @IBAction func doTerm(_ sender: Any) {
    }
}
extension LoginSuperAppViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
