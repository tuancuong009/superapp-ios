//
//  AddWantedVC.swift
//  Roomrently
//
//  Created by QTS Coder on 05/04/2024.
//

import UIKit
import Alamofire
class AddWantedVC: BaseRRViewController {

    @IBOutlet weak var txfCity: UITextField!
    @IBOutlet weak var txfZipCode: UITextField!
    @IBOutlet weak var txfState: UITextField!
    @IBOutlet weak var btnBuyer: UIButton!
    @IBOutlet weak var btnSeller: UIButton!
    @IBOutlet weak var btnBoth: UIButton!
    @IBOutlet weak var lblPriceRange: UILabel!
    @IBOutlet weak var txfPriceRange: UITextField!
    @IBOutlet weak var txfPriceToRent: UITextField!
    @IBOutlet weak var lblPlaceHolder: UILabel!
    @IBOutlet weak var tvBrief: UITextView!
    @IBOutlet weak var viewPriceBuy: UIStackView!
    @IBOutlet weak var viewPriceRent: UIStackView!
    @IBOutlet weak var lblNavi: UILabel!
    var type = 1
    var arrStates = [NSDictionary]()
    var dictState: NSDictionary?
    var dictDetail: NSDictionary?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPriceRent.isHidden = true
        getState()
        updateUI()
        // Do any additional setup after loading the view.
    }
    

    private func updateUI(){
        if let dictDetail = dictDetail, let wanted = dictDetail.object(forKey: "wanted") as? NSDictionary{
            lblNavi.text = "Edit Wanted"
            lblPlaceHolder.isHidden = true
            txfState.text = wanted.object(forKey: "state") as? String
            txfCity.text = wanted.object(forKey: "city") as? String
            txfZipCode.text = wanted.object(forKey: "zip") as? String
            let  price_buy = wanted.object(forKey: "price_buy") as? String ?? ""
            let  price_rent = wanted.object(forKey: "price_rent") as? String ?? ""
            txfPriceRange.text = price_buy
            txfPriceToRent.text = price_rent
            tvBrief.text = wanted.object(forKey: "discription") as? String
            if let seeking = wanted.object(forKey: "seeking") as? String{
                type = Int(seeking) ?? 1
                if type == 1{
                    btnBuyer.setImage(UIImage.init(named: "radio_selected"), for: .normal)
                    btnSeller.setImage(UIImage.init(named: "radio"), for: .normal)
                    btnBoth.setImage(UIImage.init(named: "radio"), for: .normal)
                    viewPriceBuy.isHidden = false
                    viewPriceRent.isHidden = true
                     
                } else if type == 2{
                    btnSeller.setImage(UIImage.init(named: "radio_selected"), for: .normal)
                    btnBuyer.setImage(UIImage.init(named: "radio"), for: .normal)
                    btnBoth.setImage(UIImage.init(named: "radio"), for: .normal)
                    viewPriceBuy.isHidden = true
                    viewPriceRent.isHidden = false
                }
                else{
                    btnBoth.setImage(UIImage.init(named: "radio_selected"), for: .normal)
                    btnSeller.setImage(UIImage.init(named: "radio"), for: .normal)
                    btnBuyer.setImage(UIImage.init(named: "radio"), for: .normal)
                    viewPriceBuy.isHidden = false
                    viewPriceRent.isHidden = false
                }
            }
        }
    }
    @IBAction func doState(_ sender: Any) {
        
        var arrs = [String]()
        for arrState in arrStates {
            arrs.append(arrState.object(forKey: "name") as? String ?? "")
        }
        DPPickerManager.shared.showPicker(title: "State", sender, selected: txfState.text, strings: arrs) { value, index, cancel in
            if !cancel{
                self.dictState = self.arrStates[index]
                self.txfState.text  = value
            }
        }
    }
    
    @IBAction func doType(_ sender: Any) {
        guard let btn = sender as? UIButton else {
            return
        }
        type = btn.tag + 1
        if btn.tag == 0{
            btnBuyer.setImage(UIImage.init(named: "radio_selected"), for: .normal)
            btnSeller.setImage(UIImage.init(named: "radio"), for: .normal)
            btnBoth.setImage(UIImage.init(named: "radio"), for: .normal)
            viewPriceBuy.isHidden = false
            viewPriceRent.isHidden = true
             
        } else if btn.tag == 1{
            btnSeller.setImage(UIImage.init(named: "radio_selected"), for: .normal)
            btnBuyer.setImage(UIImage.init(named: "radio"), for: .normal)
            btnBoth.setImage(UIImage.init(named: "radio"), for: .normal)
            viewPriceBuy.isHidden = true
            viewPriceRent.isHidden = false
        }
        else{
            btnBoth.setImage(UIImage.init(named: "radio_selected"), for: .normal)
            btnSeller.setImage(UIImage.init(named: "radio"), for: .normal)
            btnBuyer.setImage(UIImage.init(named: "radio"), for: .normal)
            viewPriceBuy.isHidden = false
            viewPriceRent.isHidden = false
        }
    }
    @IBAction func doBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func doSubmit(_ sender: Any) {
        let state = txfState.text!.trimText()
        let city = txfCity.text!.trimText()
        let zip = txfZipCode.text!.trimText()
        let priceBuy = txfPriceRange.text!.trimText()
        let priceRent = txfPriceToRent.text!.trimText()
        let desc = tvBrief.text!.trimText()
        if state.isEmpty{
            self.showAlertMessage(message: "State is required")
            return
        }
        if city.isEmpty{
            self.showAlertMessage(message: "City is required")
            return
        }
        if zip.isEmpty{
            self.showAlertMessage(message: "Zip Code is required")
            return
        }
        if type == 1{
            if priceBuy.isEmpty{
                self.showAlertMessage(message: "Price Range to Buy is required")
                return
            }
        }
        else if type == 2{
            if priceRent.isEmpty{
                self.showAlertMessage(message: "Price Range to Rent is required")
                return
            }
        }
        else{
            if priceBuy.isEmpty{
                self.showAlertMessage(message: "Price Range to Buy is required")
                return
            }
            if priceRent.isEmpty{
                self.showAlertMessage(message: "Price Range to Rent is required")
                return
            }
        }
        if zip.isEmpty{
            self.showAlertMessage(message: "Brief description of the Accomodation is required")
            return
        }
        view.endEditing(true)
        var paraam: Parameters = [:]
        paraam["uid"] = UserDefaults.standard.value(forKey: USER_ID_RR) as? String ?? ""
        paraam["country"] = "United States"
        if let dictState = dictState{
            let code = dictState.object(forKey: "code") as? String ?? ""
            paraam["state"] = code
        }
        else{
            paraam["state"] = state
        }
        
        paraam["zip"] = zip
        paraam["city"] = city
        paraam["seeking"] = "\(type)"
        if type == 1{
            paraam["price_buy"] = priceBuy
            paraam["price_rent"] = ""
        }
        else if type == 2{
            paraam["price_buy"] = ""
            paraam["price_rent"] = priceRent
        }
        else{
            paraam["price_buy"] = priceBuy
            paraam["price_rent"] = priceRent
        }
        paraam["discription"] = desc
        if let dictDetail = dictDetail, let wanted = dictDetail.object(forKey: "wanted") as? NSDictionary{
            paraam["id"] = wanted.object(forKey: "id") as? String ?? ""
        }
        self.showBusy()
        if dictDetail == nil{
            APIRoomrentlyHelper.shared.addWant(paraam) { success, errer in
                self.hideBusy()
                if success!{
                    let alert = UIAlertController(title: APP_NAME,
                                                  message: "Thank you for listing your requirnment. Please check your email if it has not gone to the spam/junk folder. Also, remember to keep your profile and listing updated or list more properties.",
                                                  preferredStyle: UIAlertController.Style.alert)
                    let cancelAction = UIAlertAction(title: "Ok",
                                                     style: .default) { action in
                        
                        self.navigationController?.popViewController(animated: true)
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
        else{
            APIRoomrentlyHelper.shared.editWanted(paraam) { success, errer in
                self.hideBusy()
                if success!{
                    self.navigationController?.popViewController(animated: true)
                }
                else{
                    if let errer = errer{
                        self.showAlertMessage(message: errer)
                    }
                }
            }
        }
       
    }
    
    private func getState()
    {
        APIRoomrentlyHelper.shared.getStates { success, arrs in
            self.arrStates.removeAll()
            if let arrs = arrs{
                self.arrStates = arrs
            }
        }
    }
}
extension AddWantedVC: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if textView == tvBrief{
            if textView.text!.trimText().isEmpty{
                lblPlaceHolder.isHidden = false
            }
            else {
                lblPlaceHolder.isHidden = true
            }
        }
    }
}
