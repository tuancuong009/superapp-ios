//
//  SendMessageViewController.swift
//  Matcheron
//
//  Created by QTS Coder on 9/10/24.
//

import UIKit

class SendMessageViewController: AllViewController {

    @IBOutlet weak var lblNavi: UILabel!
    @IBOutlet weak var lblPlaceHolder: UILabel!
    @IBOutlet weak var tvMessage: UITextView!
    var profileID = ""
    var profileName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let attrStri = NSMutableAttributedString.init(string: "✨ Send a Message to \(profileName) ✨")
        let nsRange = NSString(string: "✨ Send a Message to \(profileName) ✨")
                .range(of: "\(profileName)", options: String.CompareOptions.caseInsensitive)
        
        attrStri.addAttributes([
            NSAttributedString.Key.foregroundColor : UIColor.init(hex: "EF7380"),
            NSAttributedString.Key.font: UIFont.init(name: "Baloo2-SemiBold", size: lblNavi.font.pointSize) as Any
        ], range: nsRange)
        
      
        lblNavi.attributedText = attrStri
        // Do any additional setup after loading the view.
    }

    @IBAction func doClose(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.dismiss(animated: true) {
            
        }
    }
    @IBAction func doSend(_ sender: Any) {
        let msg = tvMessage.text!.trimText()
        if msg.isEmpty{
            self.showAlertMessage(message: "Message is required")
        }
        else{
            view.endEditing(true)
            self.showBusy()
            let userID = UserDefaults.standard.value(forKey: USER_ID) as? String ?? ""
            
            let param = ["sid": userID, "rid": profileID, "message": msg]
            APIHelper.shared.addMSG(param) { success, erro in
                self.hideBusy()
                if success!{
                    self.dismiss(animated: true) {
                        
                    }
                }
                else{
                    self.showAlertMessage(message: erro ?? "")
                }
                
            }
        }
    }
}

extension SendMessageViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        lblPlaceHolder.isHidden = textView.text!.isEmpty ? false : true
    }
}
