//
//  AddNewShopViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 5/8/24.
//

import UIKit
import Alamofire
class AddNewShopViewController: BaseViewController {

    @IBOutlet weak var txfCondiition: UITextField!
    @IBOutlet weak var lblErrorCondition: UILabel!
    @IBOutlet weak var txfName: UITextField!
    @IBOutlet weak var lblErrorName: UILabel!
    @IBOutlet weak var txfCategory: UITextField!
    @IBOutlet weak var lblErrorCategory: UILabel!
    @IBOutlet weak var txfPrice: UITextField!
    @IBOutlet weak var lblErrorPrice: UILabel!
    @IBOutlet weak var txfState: UITextField!
    @IBOutlet weak var lblErrorState: UILabel!
    @IBOutlet weak var txfCity: UITextField!
    @IBOutlet weak var lblErrorCity: UILabel!
    @IBOutlet weak var txfZipCode: UITextField!
    @IBOutlet weak var lblErrorZipCode: UILabel!
    @IBOutlet weak var lblPlaceHolderDetail: UILabel!
    @IBOutlet weak var tvDetail: UITextView!
    @IBOutlet weak var lblErrorDetail: UILabel!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var btnDeleteImg1: UIButton!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var btnDeleteImg2: UIButton!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var btnDeleteImg3: UIButton!
    @IBOutlet weak var lblErrorPhot: UILabel!
    @IBOutlet weak var viewShipping: UIView!
    @IBOutlet weak var txfShippng: UITextField!
    @IBOutlet weak var lblErrorShipping: UILabel!
    @IBOutlet weak var btnShippingFree: UIButton!
    @IBOutlet weak var btnDola: UIButton!
    var tapSuccess: (() ->())?
    var categories = [NSDictionary]()
    var categorySelect: NSDictionary?
    private var categoryDropDown = DropDown()
    private var typeDropdown = DropDown()
    private var stateDropdown = DropDown()
    var categoryStrs = [String]()
    var alltype = [String]()
    var states = [String]()
    private var imagePicker: ImagePicker?
    var indexChoosePhoto = 0
    var dictProduct: NSDictionary?
    var image1: UIImage?
    var image2: UIImage?
    var image3: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUIChoosePhoto()
        hideAllError()
        setupDropdown()
        imagePicker = ImagePicker(presentationController: self, delegate: self, mediaTypes: [.image], allowsEditing: true, iCloud: true)
        updateUIEdit()
        
        // Do any additional setup after loading the view.
    }


    private func hideAllError(){
        lblErrorCondition.isHidden = true
        lblErrorName.isHidden = true
        lblErrorCategory.isHidden = true
        lblErrorPrice.isHidden = true
        lblErrorState.isHidden = true
        lblErrorCity.isHidden = true
        lblErrorZipCode.isHidden = true
        lblErrorDetail.isHidden = true
        lblErrorPhot.isHidden = true
        lblErrorShipping.isHidden = true
    }
    
    public func updateUIEdit(){
      
        if let dictProduct = dictProduct{
            print(dictProduct)
            txfCondiition.text = dictProduct.object(forKey: "condition") as? String
            txfName.text = dictProduct.object(forKey: "itemname") as? String
            txfCategory.text = dictProduct.object(forKey: "category") as? String
            txfCity.text = dictProduct.object(forKey: "city") as? String
            txfPrice.text = dictProduct.object(forKey: "price") as? String
            txfState.text = dictProduct.object(forKey: "state") as? String
            txfZipCode.text = dictProduct.object(forKey: "zip") as? String
            tvDetail.text = dictProduct.object(forKey: "brief") as? String
            lblPlaceHolderDetail.isHidden = tvDetail.text!.trimmed.isEmpty ? false : true
            if let photo1 = dictProduct.object(forKey: "img1") as? String{
                let join = "https://www.circlecue.com/assets/images/product-img/" + photo1
                print("join---->",join)
                img1.setImage(with: join, placeholderImage: .photo)
                btnDeleteImg1.isHidden = false
                img1.isHidden = false
            }
            else{
                btnDeleteImg1.isHidden = false
                img1.image = nil
                img1.isHidden = true
            }
            
            if let photo2 = dictProduct.object(forKey: "img2") as? String{
                let join = "https://www.circlecue.com/assets/images/product-img/" + photo2
                img2.setImage(with: join, placeholderImage: .photo)
                btnDeleteImg2.isHidden = false
                img2.isHidden = false
            }
            else{
                btnDeleteImg2.isHidden = false
                img2.image = nil
                img2.isHidden = true
            }
            
            if let photo3 = dictProduct.object(forKey: "img3") as? String{
                let join = "https://www.circlecue.com/assets/images/product-img/" + photo3
                img3.setImage(with: join, placeholderImage: .photo)
                btnDeleteImg3.isHidden = false
                img3.isHidden = false
            }
            else{
                btnDeleteImg3.isHidden = false
                img3.image = nil
                img3.isHidden = true
            }
            
            for category in categories {
               if  let name = category.object(forKey: "name") as? String{
                    if name == txfCategory.text!.trimmed{
                        self.categorySelect = category
                        break
                    }
                }
            }
            if let shipping_value = dictProduct.object(forKey: "shipping_value") as? String{
                if shipping_value == "1"{
                    btnShippingFree.isSelected = true
                    btnDola.isSelected = false
                    viewShipping.isHidden = false
                    viewShipping.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
                    lblErrorShipping.isHidden = true
                    txfShippng.isEnabled = false
                }
                else{
                    btnShippingFree.isSelected = false
                    btnDola.isSelected = true
                    viewShipping.isHidden = false
                    viewShipping.backgroundColor = UIColor.white
                    txfShippng.text = dictProduct.object(forKey: "shipping_charges") as? String
                    lblErrorShipping.isHidden = true
                    txfShippng.isEnabled = true
                }
            }
            else{
                viewShipping.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
                btnShippingFree.isSelected = true
                btnDola.isSelected = false
                viewShipping.isHidden = false
                lblErrorShipping.isHidden = true
                txfShippng.isEnabled = false
            }
        }
        else{
            viewShipping.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
            btnShippingFree.isSelected = true
            btnDola.isSelected = false
            viewShipping.isHidden = false
            lblErrorShipping.isHidden = true
            txfShippng.isEnabled = false
        }
    }
    private func updateUIChoosePhoto(){
        if img1.image == nil{
            btnDeleteImg1.isHidden = true
            img1.isHidden = true
        }
        else{
            btnDeleteImg1.isHidden = false
            img1.isHidden = false
        }
        
        if img2.image == nil{
            btnDeleteImg2.isHidden = true
            img2.isHidden = true
        }
        else{
            btnDeleteImg2.isHidden = false
            img2.isHidden = false
        }
        
        if img3.image == nil{
            btnDeleteImg3.isHidden = true
            img3.isHidden = true
        }
        else{
            btnDeleteImg3.isHidden = false
            img3.isHidden = false
        }
    }
    
    private func setupDropdown() {
        let cats = categoryStrs.filter { $0 != "All Category" }
        categoryDropDown.anchorView = txfCategory
        categoryDropDown.dataSource = cats
        categoryDropDown.bottomOffset = CGPoint(x: 0, y: txfCategory.frame.height + 2)
        categoryDropDown.direction = .bottom
        categoryDropDown.textFont = UIFont.myriadProRegular(ofSize: 16)
        categoryDropDown.cellHeight = 40
        categoryDropDown.animationduration = 0.2
        categoryDropDown.backgroundColor = UIColor.white
        categoryDropDown.selectionBackgroundColor = UIColor.yellow.withAlphaComponent(0.3)
        categoryDropDown.dimmedBackgroundColor = UIColor.black.withAlphaComponent(0.3)
        categoryDropDown.selectionAction = {[weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.txfCategory.text = item
            self.categorySelect = self.categories[index]
            
        }
        
        let types = alltype.filter { $0 != "All Type" }
        typeDropdown.anchorView = txfCondiition
        typeDropdown.dataSource = types
        typeDropdown.bottomOffset = CGPoint(x: 0, y: txfCondiition.frame.height + 2)
        typeDropdown.direction = .bottom
        typeDropdown.textFont = UIFont.myriadProRegular(ofSize: 16)
        typeDropdown.cellHeight = 40
        typeDropdown.animationduration = 0.2
        typeDropdown.backgroundColor = UIColor.white
        typeDropdown.selectionBackgroundColor = UIColor.yellow.withAlphaComponent(0.3)
        typeDropdown.dimmedBackgroundColor = UIColor.black.withAlphaComponent(0.3)
        typeDropdown.selectionAction = {[weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.txfCondiition.text = item
        }
        
        let statesArrs = states.filter { $0 != "All State" }
        stateDropdown.anchorView = txfState
        stateDropdown.dataSource = statesArrs
        stateDropdown.bottomOffset = CGPoint(x: 0, y: txfState.frame.height + 2)
        stateDropdown.direction = .bottom
        stateDropdown.textFont = UIFont.myriadProRegular(ofSize: 16)
        stateDropdown.cellHeight = 40
        stateDropdown.animationduration = 0.2
        stateDropdown.backgroundColor = UIColor.white
        stateDropdown.selectionBackgroundColor = UIColor.yellow.withAlphaComponent(0.3)
        stateDropdown.dimmedBackgroundColor = UIColor.black.withAlphaComponent(0.3)
        stateDropdown.selectionAction = {[weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.txfState.text = item
        }
    }
    @IBAction func doFree(_ sender: Any) {
        btnShippingFree.isSelected = true
        btnDola.isSelected = false
        viewShipping.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        lblErrorShipping.isHidden = true
        txfShippng.isEnabled = false
    }
    
    @IBAction func doDola(_ sender: Any) {
        btnShippingFree.isSelected = false
        btnDola.isSelected = true
        viewShipping.backgroundColor = UIColor.white
        txfShippng.isEnabled = true
        lblErrorShipping.isHidden = true
    }
    @IBAction func doCondition(_ sender: Any) {
        self.hideAllError()
        typeDropdown.show()
    }
    
    @IBAction func doCategory(_ sender: Any) {
        self.hideAllError()
        categoryDropDown.show()
    }
    @IBAction func doState(_ sender: Any) {
        self.hideAllError()
        stateDropdown.show()
    }
    @IBAction func chooseImage1(_ sender: Any) {
        self.hideAllError()
        indexChoosePhoto = 0
        imagePicker?.present(from: self.view)
    }
    @IBAction func doDeleteImage1(_ sender: Any) {
        img1.image = nil
        updateUIChoosePhoto()
    }
    
    @IBAction func chooseImage2(_ sender: Any) {
        indexChoosePhoto = 1
        imagePicker?.present(from: self.view)
    }
    @IBAction func doDeleteImage2(_ sender: Any) {
        img2.image = nil
        updateUIChoosePhoto()
    }
    
    @IBAction func chooseImage3(_ sender: Any) {
        indexChoosePhoto = 2
        imagePicker?.present(from: self.view)
    }
    @IBAction func doDeleteImage3(_ sender: Any) {
        img3.image = nil
        updateUIChoosePhoto()
    }
    @IBAction func doSubmit(_ sender: Any) {
        self.hideAllError()
        if self.validateForm(){
            if let dictProduct =  dictProduct{
                self.showSimpleHUD()
                var params: Parameters = [:]
                if let categorySelect = categorySelect{
                    params["category"] = categorySelect.object(forKey: "id") as? String ?? ""
                }
                params["condition"] = txfCondiition.text!
                params["itemname"] = txfName.text!.trimmed
                params["price"] = txfPrice.text!.trimmed
                params["country"] = "USA"
                params["state"] = txfState.text!.trimmed
                params["city"] = txfCity.text!.trimmed
                params["zip"] = txfZipCode.text!.trimmed
                params["brief"] = tvDetail.text!.trimmed
                params["id"] = dictProduct.object(forKey: "id") as? String ?? ""
                if btnShippingFree.isSelected{
                    params["shipping_charges"] = "1"
                }
                else if btnDola.isSelected{
                    params["shipping_charges"] = "2"
                    params["shipping_value"] = txfShippng.text!.trimmed
                }
                print("params--->",params)
                ManageAPI.shared.editProduct(params: params, img1: image1, img2: image2, img3: image3) { success, error in
                    self.hideLoading()
                    if success{
                        self.tapSuccess?()
                        self.navigationController?.popViewController(animated: true)
                    }
                    else{
                        if let error = error{
                            self.showErrorAlert(message: error)
                        }
                    }
                }
            }
            else{
                self.showSimpleHUD()
                var params: Parameters = [:]
                if let categorySelect = categorySelect{
                    params["category"] = categorySelect.object(forKey: "id") as? String ?? ""
                }
                params["condition"] = txfCondiition.text!
                params["itemname"] = txfName.text!.trimmed
                params["price"] = txfPrice.text!.trimmed
                params["country"] = "USA"
                params["state"] = txfState.text!.trimmed
                params["city"] = txfCity.text!.trimmed
                params["zip"] = txfZipCode.text!.trimmed
                params["brief"] = tvDetail.text!.trimmed
                params["uid"] = AppSettings.shared.currentUser?.userId ?? ""
                if btnShippingFree.isSelected{
                    params["shipping_charges"] = "1"
                }
                else if btnDola.isSelected{
                    params["shipping_charges"] = "2"
                    params["shipping_value"] = txfShippng.text!.trimmed
                }
                print("params--->",params)
                ManageAPI.shared.addProductShow(params: params, img1: img1.image, img2: img2.image, img3: img3.image) { success, error in
                    self.hideLoading()
                    if success{
                        self.tapSuccess?()
                        self.navigationController?.popViewController(animated: true)
                    }
                    else{
                        if let error = error{
                            self.showErrorAlert(message: error)
                        }
                    }
                }
            }
            
        }
    }
    
    private func validateForm()-> Bool{
        var isValid = true
        if txfCondiition.text!.trimmed.isEmpty{
            isValid = false
            lblErrorCondition.isHidden = false
        }
        
        if txfName.text!.trimmed.isEmpty{
            isValid = false
            lblErrorName.isHidden = false
        }
        
        if txfCategory.text!.trimmed.isEmpty{
            isValid = false
            lblErrorCategory.isHidden = false
        }
        
        if txfPrice.text!.trimmed.isEmpty{
            isValid = false
            lblErrorPrice.isHidden = false
        }
        
        if txfState.text!.trimmed.isEmpty{
            isValid = false
            lblErrorState.isHidden = false
        }
        
        if txfCity.text!.trimmed.isEmpty{
            isValid = false
            lblErrorCity.isHidden = false
        }
        
        if txfZipCode.text!.trimmed.isEmpty{
            isValid = false
            lblErrorZipCode.isHidden = false
        }
        
        if tvDetail.text!.trimmed.isEmpty{
            isValid = false
            lblErrorDetail.isHidden = false
        }
        if self.dictProduct != nil{
           
        }
        else{
            if img1.image == nil && img2.image == nil  && img3.image == nil {
                isValid = false
                lblErrorPhot.isHidden = false
            }
        }
        if btnDola.isSelected{
            if txfShippng.text!.trimmed.isEmpty{
                isValid = false
                lblErrorShipping.isHidden = false
            }
        }
        return isValid
    }
}
extension AddNewShopViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        lblPlaceHolderDetail.isHidden = textView.hasText
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.hideAllError()
    }
}

extension AddNewShopViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.hideAllError()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfName{
            txfPrice.becomeFirstResponder()
        }
        else if textField == txfPrice{
            txfCity.becomeFirstResponder()
        }
        else if textField == txfCity{
            txfZipCode.becomeFirstResponder()
        }
        else if textField == txfZipCode{
            tvDetail.becomeFirstResponder()
        }
        return true
    }
}
extension AddNewShopViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        if indexChoosePhoto == 0 {
            img1.image = image
            updateUIChoosePhoto()
            if dictProduct != nil{
                self.image1 = image
            }
        }
        else if indexChoosePhoto == 1 {
            img2.image = image
            updateUIChoosePhoto()
            if dictProduct != nil{
                self.image2 = image
            }
        }
        else{
            img3.image = image
            updateUIChoosePhoto()
            if dictProduct != nil{
                self.image3 = image
            }
        }
    }

}
