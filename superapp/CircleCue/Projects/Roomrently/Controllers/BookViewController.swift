//
//  BookViewController.swift
//  Roomrently
//
//  Created by QTS Coder on 16/08/2023.
//

import UIKit
import Alamofire
import LGSideMenuController
class BookViewController: BaseRRViewController {

    @IBOutlet weak var txfID: UITextField!
    @IBOutlet weak var txfFrom: UITextField!
    @IBOutlet weak var txfTill: UITextField!
    @IBOutlet weak var lblPlaceRemark: UILabel!
    @IBOutlet weak var tvRemark: UITextView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var subTill: UIView!
    @IBOutlet weak var subFrom: UIView!
    @IBOutlet weak var lblPriceState: UILabel!
    @IBOutlet weak var lblState: UILabel!
    var idBook = ""
    var dictData: NSDictionary?
    var property: NSDictionary?
    @IBOutlet weak var btnFlex: UIButton!
    var isFlex = false
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.txfID.text = idBook
        if !idBook.isEmpty{
            self.btnMenu.setImage(UIImage.init(named: "btn_backrr"), for: .normal)
        }
        if let dictData = dictData, let property = dictData.object(forKey: "property") as? NSDictionary{
            let rent = property.object(forKey: "rent") as? String ?? ""
            let rtype = property.object(forKey: "rtype") as? String ?? ""
           
            let city = property.object(forKey: "city") as? String ?? ""
            let state = property.object(forKey: "state") as? String ?? ""
            lblPriceState.text = "$" + rent + "/" + rtype
            lblState.text =  city + ", " + state
        }else  if let property = property{
            let rent = property.object(forKey: "rent") as? String ?? ""
            let rtype = property.object(forKey: "rtype") as? String ?? ""
           
            let city = property.object(forKey: "city") as? String ?? ""
            let state = property.object(forKey: "state") as? String ?? ""
            lblPriceState.text = "$" + rent + "/" + rtype
            lblState.text =  city + ", " + state
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doFlex(_ sender: Any) {
        if isFlex{
            isFlex = false
            btnFlex.setImage(UIImage.init(named: "radio"), for: .normal)
            subFrom.backgroundColor = UIColor.white
            subTill.backgroundColor = UIColor.white
        }
        else{
            isFlex = true
            btnFlex.setImage(UIImage.init(named: "radio_selected"), for: .normal)
            subFrom.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
            subTill.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        }
    }
    
    @IBAction func doLeftMenu(_ sender: Any) {
        if idBook.isEmpty{
            self.sideMenuController?.showLeftView(animated: true)
        }
        else{
            self.navigationController?.popViewController(animated: true)
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
                self.showAlertMessage(message: "From Date is required")
                return
            }
            if to.isEmpty{
                self.showAlertMessage(message: "Till is required")
                return
            }
        }
       
//        if remark.isEmpty{
//            self.showAlertMessage(message: "Special remarks is required")
//            return
//        }
//        
        

        self.showBusy()
        var paraam: Parameters = [:]
        paraam["uid"] = UserDefaults.standard.value(forKey: USER_ID_RR) as? String ?? ""
        paraam["pid"] = propertyID
        if isFlex{
            
        }
        else{
            paraam["date"] = from
            paraam["date2"] = to
        }
        if !remark.isEmpty{
            paraam["remark"] = remark
        }
       
        paraam["type"] = "Rent"
        paraam["flexible"] = isFlex
        
        APIRoomrentlyHelper.shared.addInquiry(paraam) { success, errer in
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
    
    @IBAction func doFrom(_ sender: Any) {
        if isFlex{
            return
        }
        DPPickerManager.shared.showPicker(title: "From", sender, selected: nil, min: Date(), max: nil) { date, cancel in
            if !cancel{
                let format = DateFormatter.init()
                format.dateFormat = "MM/dd/yyyy"
                self.txfFrom.text = format.string(from: date ?? Date())
            }
        }
    }
    
    @IBAction func doTill(_ sender: Any) {
        if isFlex{
            return
        }
        DPPickerManager.shared.showPicker(title: "Till", sender, selected: nil, min: Date(), max: nil) { date, cancel in
            if !cancel{
                let format = DateFormatter.init()
                format.dateFormat = "MM/dd/yyyy"
                self.txfTill.text = format.string(from: date ?? Date())
            }
        }
    }
    
}


extension BookViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        return true
    }
}

extension BookViewController: UITextViewDelegate{
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
