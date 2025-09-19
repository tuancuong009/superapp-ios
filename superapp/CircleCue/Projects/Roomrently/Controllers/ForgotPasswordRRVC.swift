//
//  ForgotPasswordVC.swift
//  Roomrently
//
//  Created by QTS Coder on 06/10/2023.
//

import UIKit
import Alamofire
class ForgotPasswordRRVC: BaseRRViewController {
    var tapSuccess: (() ->())?
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doSubmit(_ sender: Any) {
        let email = txfEmail.text!.trimText()
        if email.isEmpty{
            self.showAlertMessage(message: "Email is required")
            return
        }
        if !email.isValidEmail(){
            self.showAlertMessage(message: "Email is invalid")
            return
        }
        
        self.showBusy()
        let param: Parameters = ["email": email]
        APIRoomrentlyHelper.shared.resetPassword(param) { success, erro in
            self.hideBusy()
            if let erro = erro{
                if success!{
                    self.navigationController?.popViewController(animated: true)
                    self.tapSuccess?()
                }
                else{
                    self.showAlertMessage(message: erro)
                }
            }
        }
    }
}
