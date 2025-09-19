//
//  ListViewController.swift
//  Roomrently
//
//  Created by QTS Coder on 16/08/2023.
//

import UIKit
import Alamofire
import SDWebImage
import LGSideMenuController
class ListViewController: BaseRRViewController {
    @IBOutlet weak var lblPlaceAddress: UILabel!
    @IBOutlet weak var tvAddress: UITextView!
    @IBOutlet weak var txfCity: UITextField!
    @IBOutlet weak var txfState: UITextField!
    @IBOutlet weak var txfZip: UITextField!
    @IBOutlet weak var lblPlaceDesc: UILabel!
    @IBOutlet weak var tvDesc: UITextView!
    @IBOutlet weak var txfPrice: UITextField!
    @IBOutlet weak var lblPlaceRemark: UILabel!
    @IBOutlet weak var tvRemark: UITextView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var txfRent: UITextField!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var heightTop: NSLayoutConstraint!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var lblNavi: UILabel!
    @IBOutlet weak var subRent: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txfSelectType: UITextField!
    var indexImage = 0
    var arrStates = [NSDictionary]()
    var imagePicker: UIImagePickerController!
    var dictEdit: NSDictionary?
    var dictState: NSDictionary?
    var countPhoto = 0
    var selectType: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        btnMenu.setImage(UIImage.init(named: "btn_backrr"), for: .normal)
        if  dictEdit != nil{
            
            updateUI()
            btnSubmit.setTitle("Update", for: .normal)
        }
        getState()
        // Do any additional setup after loading the view.
    }
    @IBAction func doChooseFile(_ sender: Any) {
        if let btn = sender as? UIButton{
            indexImage = btn.tag
        }
        showPhotoAndLibrary()
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
    
    @IBAction func doSelectType(_ sender: Any) {
        let arrs = ["Rent", "Sell"]
       
        DPPickerManager.shared.showPicker(title: "Select type", sender, selected: txfSelectType.text, strings: arrs) { value, index, cancel in
            if !cancel{
                self.txfSelectType.text = value
                self.selectType  = value ?? ""
                self.checkSelecType()
                if self.selectType == "Sell"{
                    self.lblPlaceDesc.text = "Brief description of the property"
                }
                else{
                    self.lblPlaceDesc.text = "Brief description of the accomodation"
                }
            }
        }
    }
    @IBAction func doMenuApp(_ sender: Any) {
        //if  dictEdit != nil{
            self.navigationController?.popViewController(animated: true)
        //}
        //else{
         //   self.sideMenuController?.showLeftView(animated: true)
        //}
    }
    
    func checkSelecType(){
        if selectType.isEmpty{
            subRent.isHidden = false
        }
        else{
            if selectType == "Sell"{
                subRent.isHidden = true
            }
            else{
                subRent.isHidden = false
            }
        }
    }
    private func updateUI(){
        if let dictEdit = dictEdit, let property = dictEdit.object(forKey: "property") as? NSDictionary{
            lblNavi.text = "Edit: " + (property.object(forKey: "pid") as? String ?? "")
            tvAddress.text = property.object(forKey: "address") as? String
            txfCity.text = property.object(forKey: "city") as? String
            txfState.text = property.object(forKey: "state") as? String
            txfZip.text = property.object(forKey: "country") as? String
            tvDesc.text = property.object(forKey: "discription") as? String
            txfPrice.text = property.object(forKey: "rent") as? String
            txfRent.text = property.object(forKey: "rtype") as? String
            txfSelectType.text = property.object(forKey: "type") as? String
            selectType = property.object(forKey: "type") as? String ?? ""
            tvRemark.text = property.object(forKey: "remark") as? String
            if let imgPicture1 = property.object(forKey: "img1") as? String{
                countPhoto = countPhoto + 1
                img1.sd_setImage(with: URL.init(string: LINK_URL.URL_PHOTO + imgPicture1))
            }
            if let imgPicture2 = property.object(forKey: "img2") as? String{
                countPhoto = countPhoto + 1
                img2.sd_setImage(with: URL.init(string: LINK_URL.URL_PHOTO + imgPicture2))
            }
            if let imgPicture3 = property.object(forKey: "img3") as? String{
                countPhoto = countPhoto + 1
                img3.sd_setImage(with: URL.init(string: LINK_URL.URL_PHOTO + imgPicture3))
            }
            if let imgPicture4 = property.object(forKey: "img4") as? String{
                countPhoto = countPhoto + 1
                img4.sd_setImage(with: URL.init(string: LINK_URL.URL_PHOTO + imgPicture4))
            }
            lblPlaceDesc.isHidden = true
            lblPlaceRemark.isHidden = tvRemark.text!.trimText().isEmpty ? false : true
            lblPlaceAddress.isHidden = true
            heightTop.constant = 0
            viewTop.isHidden = true
            checkSelecType()
            if selectType == "Sell"{
                lblPlaceDesc.text = "Brief description of the property"
            }
            else{
                lblPlaceDesc.text = "Brief description of the accomodation"
            }
        }
        else{
            if selectType == "Sell"{
                lblPlaceDesc.text = "Brief description of the property"
            }
            else{
                lblPlaceDesc.text = "Brief description of the accomodation"
            }
        }
    }
    @IBAction func doSubmit(_ sender: Any) {
        if  dictEdit != nil{
            if let dictEdit = dictEdit, let property = dictEdit.object(forKey: "property") as? NSDictionary, let id = property.object(forKey: "id") as? String{
                let address = tvAddress.text!.trimText()
                let city = txfCity.text!.trimText()
                let state = txfState.text!.trimText()
                let zip = txfZip.text!.trimText()
                let brief = tvDesc.text!.trimText()
                let price = txfPrice.text!.trimText()
                let recent = txfRent.text!.trimText()
                let remark = tvRemark.text!.trimText()
               
                if address.isEmpty{
                    self.showAlertMessage(message: "Street address is required")
                    return
                }
                if selectType.isEmpty{
                    self.showAlertMessage(message: "Please select type")
                    return
                }
                
                if city.isEmpty{
                    self.showAlertMessage(message: "City is required")
                    return
                }
                if state.isEmpty{
                    self.showAlertMessage(message: "State is required")
                    return
                }
                if zip.isEmpty{
                    self.showAlertMessage(message: "Zip is required")
                    return
                }
                if brief.isEmpty{
                    self.showAlertMessage(message: "Brief description is required")
                    return
                }
                if price.isEmpty{
                    self.showAlertMessage(message: "Price is required")
                    return
                }
              
                if recent.isEmpty && selectType == "Rent"{
                    self.showAlertMessage(message: "Please select rent type")
                    return
                }
             
//                if remark.isEmpty{
//                    self.showAlertMessage(message: "Special remarks is required")
//                    return
//                }
             
                if countPhoto < 2{
                    self.showAlertMessage(message: "Please select at least 2 photos")
                    return
                }
                var code = txfState.text!.trimText()
                if let dictState = dictState{
                    code = dictState.object(forKey: "code") as? String ?? ""
                }
                var param : Parameters = [:]
                if selectType == "Rent"
                {
                    if remark.isEmpty{
                        param = [ "phone": "", "type": selectType, "discription": brief, "address": address, "city": city, "zip": zip, "state": code, "country": "United States", "rent": price, "rtype": recent, "id": id] as [String : Any]
                    }
                    else{
                        param = ["remark": remark, "phone": "", "type": selectType, "discription": brief, "address": address, "city": city, "zip": zip, "state": code, "country": "United States", "rent": price, "rtype": recent, "id": id] as [String : Any]
                    }
                    
                }
                else{
                    if remark.isEmpty{
                        param = ["phone": "", "discription": brief, "address": address, "city": city, "zip": zip, "state": code, "country": "United States", "rent": price, "type": selectType, "id": id] as [String : Any]
                    }
                    else{
                        param = ["remark": remark, "phone": "", "discription": brief, "address": address, "city": city, "zip": zip, "state": code, "country": "United States", "rent": price, "type": selectType, "id": id] as [String : Any]
                    }
                   
                }
                print(param)
                print("Url api --->", API_URL.URL_SERVER + "edit_property.php")
                self.showBusy()
                APIRoomrentlyHelper.shared.editlistApi(param, img1.image, img2.image!, img3.image, img4.image) { success, errer in
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
        else{
            let address = tvAddress.text!.trimText()
            let city = txfCity.text!.trimText()
            let state = txfState.text!.trimText()
            let zip = txfZip.text!.trimText()
            let brief = tvDesc.text!.trimText()
            let price = txfPrice.text!.trimText()
            let recent = txfRent.text!.trimText()
            let remark = tvRemark.text!.trimText()
            if address.isEmpty{
                self.showAlertMessage(message: "Street address is required")
                return
            }
            if selectType.isEmpty{
                self.showAlertMessage(message: "Please select type")
                return
            }
            if city.isEmpty{
                self.showAlertMessage(message: "City is required")
                return
            }
            if state.isEmpty{
                self.showAlertMessage(message: "State is required")
                return
            }
            if zip.isEmpty{
                self.showAlertMessage(message: "Zip is required")
                return
            }
            if brief.isEmpty{
                self.showAlertMessage(message: "Brief description is required")
                return
            }
            if price.isEmpty{
                self.showAlertMessage(message: "Price is required")
                return
            }
           
            if recent.isEmpty && selectType == "Rent"{
                self.showAlertMessage(message: "Please select rent type")
                return
            }
            
         
//            if remark.isEmpty{
//                self.showAlertMessage(message: "Special remarks is required")
//                return
//            }
//
            if countPhoto < 2{
                self.showAlertMessage(message: "Please select at least 2 photos")
                return
            }
            var code = txfState.text!.trimText()
            if let dictState = dictState{
                code = dictState.object(forKey: "code") as? String ?? ""
            }
            var param : Parameters = [:]
            if selectType == "Rent"
            {
                if remark.isEmpty{
                    param = ["phone": "", "discription": brief, "address": address, "city": city, "zip": zip, "state": code, "country": "United States", "rent": price,"type": selectType, "rtype": recent, "uid": UserDefaults.standard.value(forKey: USER_ID_RR) as? String ?? ""]
                }
                else{
                    param = ["remark": remark, "phone": "", "discription": brief, "address": address, "city": city, "zip": zip, "state": code, "country": "United States", "rent": price,"type": selectType, "rtype": recent, "uid": UserDefaults.standard.value(forKey: USER_ID_RR) as? String ?? ""]
                }
               
            }
            else{
                if remark.isEmpty{
                    param = ["phone": "", "discription": brief, "address": address, "city": city, "zip": zip, "state": code, "country": "United States","type": selectType, "rent": price, "uid": UserDefaults.standard.value(forKey: USER_ID_RR) as? String ?? ""]
                }
                else{
                    param = ["remark": remark, "phone": "", "discription": brief, "address": address, "city": city, "zip": zip, "state": code, "country": "United States","type": selectType, "rent": price, "uid": UserDefaults.standard.value(forKey: USER_ID_RR) as? String ?? ""]
                }
               
            }
            print(param)
            self.showBusy()
            APIRoomrentlyHelper.shared.AddlistApi(param, img1.image, img2.image, img3.image, img4.image) { success, errer in
                self.hideBusy()
                if success!{
                    let alert = UIAlertController(title: APP_NAME,
                                                  message: "Thank you for listing your property. Please check your email if it has not gone to the spam/junk folder. Also, remember to keep your profile and listing updated or list more properties.",
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
        
        
    }
    @IBAction func doRent(_ sender: Any) {
        let datas = ["Monthly", "Weekly", "Nightly"]
        DPPickerManager.shared.showPicker(title: "Select Rent Type", sender, selected: txfRent.text, strings: datas) { value, index, cancel in
            if !cancel{
                self.txfRent.text  = value
            }
        }
    }
    
    private func showPhotoAndLibrary()
    {
        var stype = UIAlertController.Style.actionSheet
        if DEVICE_IPAD{
            stype = UIAlertController.Style.alert
        }
        
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: stype)
        let camera = UIAlertAction.init(title: "Take a photo", style: .default) { (action) in
            //self.showCamera()
            self.showCamera()
        }
        alert.addAction(camera)
        
        let library = UIAlertAction.init(title: "Choose from library", style: .default) { (action) in
            self.showLibrary()
        }
        alert.addAction(library)
        
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(cancel)
        self.present(alert, animated: true) {
            
        }
    }
    
    private func showCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = ["public.image"]
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
    private func showLibrary()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = ["public.image"]
            
            present(imagePicker, animated: true, completion: nil)
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
extension ListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
   
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            
            return
        }
       
        if indexImage == 0{
            if img1.image == nil{
                countPhoto = countPhoto + 1
            }
            img1.image = image
        } else if indexImage == 1{
            if img2.image == nil{
                countPhoto = countPhoto + 1
            }
            img2.image = image
        }else if indexImage == 2{
            if img3.image == nil{
                countPhoto = countPhoto + 1
            }
            img3.image = image
        }
        else if indexImage == 3{
            if img4.image == nil{
                countPhoto = countPhoto + 1
            }
            img4.image = image
        }
        self.dismiss(animated: true)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
            
        }
    }
}

extension ListViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}


extension ListViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if textView == tvAddress{
            if textView.text!.trimText().isEmpty{
                lblPlaceAddress.isHidden = false
            }
            else {
                lblPlaceAddress.isHidden = true
            }
        }
        else if textView == tvDesc{
            if textView.text!.trimText().isEmpty{
                lblPlaceDesc.isHidden = false
            }
            else {
                lblPlaceDesc.isHidden = true
            }
        }
        else if textView == tvRemark{
            if textView.text!.trimText().isEmpty{
                lblPlaceRemark.isHidden = false
            }
            else {
                lblPlaceRemark.isHidden = true
            }
        }
    }
}
