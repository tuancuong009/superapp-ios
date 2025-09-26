//
//  ForgotSuperViewController.swift
//  SuperApp
//
//  Created by QTS Coder on 14/5/25.
//

import UIKit
import FirebaseAuth
import FirebaseCore
class ForgotSuperViewController: BaseVC {

    @IBOutlet weak var txfEmail: CustomTextField!
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
    @IBAction func doSubmit(_ sender: Any) {
        let email = txfEmail.text!.trimmed
      
        if email.isEmpty{
            self.showAlert(title: APP_NAME, message: "Email is required")
            return
        }
        if !email.isValidEmail(){
            self.showAlert(title: APP_NAME, message: "Invalid email")
            return
        }
        self.view.endEditing(true)
        self.showBusy()
        if AppSettings.shared.isUseFirebase{
            resetPassword(email: email)
        }
        else{
            ManageAPI.shared.forgotpasswordSuper(email) { error in
                self.hideBusy()
                if let error = error{
                    self.txfEmail.text = nil
                    self.showAlertMessage(message: error)
                }
            }
        }
       
        
    }
    
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            DispatchQueue.main.async {
                self.hideBusy()
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    self.showAlert(title: "Success", message: "A password reset email has been sent to \(email).")
                }
            }
        }
    }
}
