//
//  RegisterSuperAppViewController.swift
//  SuperApp
//
//  Created by QTS Coder on 9/5/25.
//

import UIKit
import Alamofire
class RegisterSuperAppViewController: BaseViewController {

    @IBOutlet weak var txfName: CustomTextField!
    @IBOutlet weak var txfEmail: CustomTextField!
    @IBOutlet weak var txfPassword: CustomTextField!
    @IBOutlet weak var txfPhone: CustomTextField!
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
    @IBAction func doPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            txfPassword.isSecureTextEntry = false
        }
        else{
            txfPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func doClose(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func doSubmit(_ sender: Any) {
        let name = txfName.text!.trimmed
        let email = txfEmail.text!.trimmed
        let password = txfPassword.text!
        let phone = txfPhone.text!.trimmed
        if name.isEmpty{
            self.showAlert(title: APP_NAME, message: "Full Name is required")
            return
        }
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
        if phone.isEmpty{
            self.showAlert(title: APP_NAME, message: "Phone is required")
            return
        }
        let param = ["name": name, "email": email, "password": password, "phone": phone]
        self.view.endEditing(true)
        self.showBusy()
        ManageAPI.shared.resgiterAccountSupperApp(param) { user, error in
            self.hideBusy()
            if let user = user{
                if let Status = user.value(forKey: "Status") as? Bool , !Status{
                    self.showAlert(title: APP_NAME, message: user.value(forKey: "Message") as? String)
                }
                else{
                    if let Data = user.value(forKey: "Data") as? Int{
                        UserDefaults.standard.set("\(Data)", forKey: USER_ID_SUPER_APP)
                        UserDefaults.standard.synchronize()
                    }
                    else if let Data = user.value(forKey: "Data") as? String{
                        UserDefaults.standard.set("\(Data)", forKey: USER_ID_SUPER_APP)
                        UserDefaults.standard.synchronize()
                    }
                    APP_DELEGATE.initSuperApp()
                }
            }
            else{
                self.showAlert(title: APP_NAME, message: error?.msg)
            }
        }
    }
    @IBAction func doLogin(_ sender: Any) {
        let vc = LoginSuperAppViewController.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension RegisterSuperAppViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
