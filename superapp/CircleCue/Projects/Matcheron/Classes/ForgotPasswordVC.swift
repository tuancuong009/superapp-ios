//
//  ForgotPasswordVC.swift
//  Matcheron
//
//  Created by QTS Coder on 6/9/24.
//

import UIKit

class ForgotPasswordVC: BaseMatcheronViewController {
    @IBOutlet weak var txfEmail: UITextField!
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

    @IBAction func doBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doSend(_ sender: Any) {
        let msg = self.validateForm()
        if msg.isEmpty{
            self.view.endEditing(true)
            self.showBusy()
            let email = txfEmail.text!.trimText()
            let param = ["email": email] as [String : Any]
            APIHelper.shared.forgotpassword(param) { success, erro in
                self.hideBusy()
                if success!{
                    let alert = UIAlertController(title: APP_NAME,
                                                  message: erro ?? "",
                                                  preferredStyle: UIAlertController.Style.alert)
                    let cancelAction = UIAlertAction.init(title: "OK", style: .cancel) { action in
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else{
                    self.showAlertMessage(message: erro ?? "")
                }
            }
        }
        else{
            self.showAlertMessage(message: msg)
        }
    }
    
    func validateForm()-> String{
        let email = txfEmail.text!.trimText()
        if email.isEmpty{
            return "Email is required"
        }
        if !email.isValidEmail(){
            return "Email is invalid"
        }
       
        return ""
    }
}
