//
//  BuyInquiryViewController.swift
//  Roomrently
//
//  Created by QTS Coder on 14/11/2023.
//

import UIKit

import Alamofire
import LGSideMenuController
class BuyInquiryViewController: BaseRRViewController {
    
    @IBOutlet weak var txfID: UITextField!
    @IBOutlet weak var txfFrom: UITextField!
    @IBOutlet weak var txfTill: UITextField!
    @IBOutlet weak var lblPlaceRemark: UILabel!
    @IBOutlet weak var tvRemark: UITextView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var subFrom: UIView!
    @IBOutlet weak var subTill: UIView!
    @IBOutlet weak var lblPriceState: UILabel!
    @IBOutlet weak var lblState: UILabel!
    var idBook = ""
    var isFlex = false
    @IBOutlet weak var btnFlex: UIButton!
    var dictData: NSDictionary?
    var property: NSDictionary?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txfID.text = idBook
        self.btnMenu.setImage(UIImage.init(named: "btn_backrr"), for: .normal)
        if let dictData = dictData, let property = dictData.object(forKey: "property") as? NSDictionary{
            let rent = property.object(forKey: "rent") as? String ?? ""
           
            let city = property.object(forKey: "city") as? String ?? ""
            let state = property.object(forKey: "state") as? String ?? ""
            lblPriceState.text = "$" + rent
            lblState.text = city + ", " + state
            txfFrom.text  = "$" + rent
        } else if let property = property{
            let rent = property.object(forKey: "rent") as? String ?? ""
           
            let city = property.object(forKey: "city") as? String ?? ""
            let state = property.object(forKey: "state") as? String ?? ""
            lblPriceState.text = "$" + rent
            lblState.text = city + ", " + state
            txfFrom.text  = "$" + rent
        }
        subFrom.backgroundColor =  UIColor.lightGray.withAlphaComponent(0.6)
        txfFrom.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func doLeftMenu(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doFlex(_ sender: Any) {
        if isFlex{
            isFlex = false
            btnFlex.setImage(UIImage.init(named: "radio"), for: .normal)
            subFrom.backgroundColor =  UIColor.lightGray.withAlphaComponent(0.6)
            subTill.backgroundColor = UIColor.white
            txfFrom.isEnabled = false
            txfTill.isEnabled = true
        }
        else{
            isFlex = true
            btnFlex.setImage(UIImage.init(named: "radio_selected"), for: .normal)
            subFrom.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
            subTill.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
            txfFrom.isEnabled = false
            txfTill.isEnabled = false
        }
    }

    
    @IBAction func doSubmit(_ sender: Any) {
        let propertyID = txfID.text!.trimText()
        let from = txfFrom.text!.trimText()
        let to = txfTill.text!.trimText()
        let remark = tvRemark.text!.trimText()
        if propertyID.isEmpty{
            self.showAlertMessage(message: "Property ID is required")
            return
        }
        if !isFlex{
            if from.isEmpty{
                self.showAlertMessage(message: "Asking Sale Price is required")
                return
            }
        }
       
        self.showBusy()
        var paraam: Parameters = [:]
        paraam["uid"] = UserDefaults.standard.value(forKey: USER_ID_RR) as? String ?? ""
        paraam["pid"] = propertyID
        if isFlex{
            
        }
        else{
            paraam["sale_price"] = from
            if !to.isEmpty{
                paraam["offer_price"] = to
            }
        }
        if !remark.isEmpty{
            paraam["remark"] = remark
        }
       
        paraam["type"] = "Buy"
        paraam["flexible"] = isFlex
        APIRoomrentlyHelper.shared.addInquiryBuy(paraam) { success, errer in
            self.hideBusy()
            if success!{
                let alert = UIAlertController(title: APP_NAME,
                                              message: "Your inquiry has been submitted Expect a response soon. Follow up at 1-833-RRENTLY (1-833-773-6859)",
                                              preferredStyle: UIAlertController.Style.alert)
                let cancelAction = UIAlertAction(title: "Ok",
                                                 style: .default) { action in
                    APP_DELEGATE.initHome()
                }
                
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                if let errer = errer{
                    self.showAlertMessage(message: errer)
                }
            }
        }
        
    }
}



extension BuyInquiryViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfID{
            txfFrom.becomeFirstResponder()
        }
        else if textField == txfFrom{
            txfTill.becomeFirstResponder()
        }
        
        return true
    }
}

extension BuyInquiryViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if textView == tvRemark{
            if textView.text!.trimText().isEmpty{
                lblPlaceRemark.isHidden = false
            }
            else {
                lblPlaceRemark.isHidden = true
            }
        }
    }
}
