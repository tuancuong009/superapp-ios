//
//  BuyNowViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 5/8/24.
//

import UIKit
import Alamofire
class BuyNowViewController: BaseViewController {
    
    @IBOutlet weak var txfShipTo: UITextField!
    @IBOutlet weak var lblErrorShipto: UILabel!
    
    @IBOutlet weak var txfFullname: UITextField!
    @IBOutlet weak var lblErrorFullname: UILabel!
    
    @IBOutlet weak var txfAddress: UITextField!
    @IBOutlet weak var lblErrorAddress: UILabel!
    
    @IBOutlet weak var txfApartment: UITextField!
    @IBOutlet weak var lblErrorApartment: UILabel!
    
    @IBOutlet weak var txfcity: UITextField!
    @IBOutlet weak var lblErrorCity: UILabel!
    
    @IBOutlet weak var txfState: UITextField!
    @IBOutlet weak var lblErrorState: UILabel!
    
    @IBOutlet weak var txfZipCode: UITextField!
    @IBOutlet weak var lblErrorZipCode: UILabel!
    
    @IBOutlet weak var cltPhotos: UICollectionView!
    
    @IBOutlet weak var txfTelePhone: UITextField!
    @IBOutlet weak var lblErrorTelephone: UILabel!
    private var stateDropdown = DropDown()
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lblID: UILabel!
    var arrPhotos = [String]()
    var states = [String]()
    var dictProduct: NSDictionary?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideAllError()
        setupDropdown()
        cltPhotos.registerNibCell(identifier: "PhotoProductCollect")
        if let dictProduct = dictProduct{
            configCel(dictProduct)
        }
        // Do any additional setup after loading the view.
    }

    private func setupDropdown(){
        states = ["Alaska", "Alabama", "Arkansas", "American Samoa", "Arizona", "California", "Colorado", "Connecticut", "District of Columbia", "Delaware", "Florida", "Georgia", "Guam", "Hawaii", "Iowa", "Idaho", "Illinois", "Indiana", "Kansas", "Kentucky", "Louisiana", "Massachusetts", "Maryland", "Maine", "Michigan", "Minnesota", "Missouri", "Mississippi", "Montana", "North Carolina", "North Dakota", "Nebraska", "New Hampshire", "New Jersey", "New Mexico", "Nevada", "New York", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Virginia", "Virgin Islands", "Vermont", "Washington", "Wisconsin", "West Virginia", "Wyoming"]
        
        stateDropdown.dataSource = states
        stateDropdown.anchorView = txfState
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
    
    private func configCel( _ dict: NSDictionary){
        self.arrPhotos.removeAll()
        if let img1 = dict.object(forKey: "img1") as? String{
            let join = "https://www.circlecue.com/assets/images/product-img/" + img1
            self.arrPhotos.append(join)
        }
        if let img2 = dict.object(forKey: "img2") as? String{
            let join = "https://www.circlecue.com/assets/images/product-img/" + img2
            self.arrPhotos.append(join)
        }
        if let img3 = dict.object(forKey: "img3") as? String{
            let join = "https://www.circlecue.com/assets/images/product-img/" + img3
            self.arrPhotos.append(join)
        }
        pageControl.numberOfPages = self.arrPhotos.count
        
        cltPhotos.reloadData()
        lblID.text = "ID:  #" + (dict.object(forKey: "id") as? String ?? "")
    }
    
    @IBAction func doState(_ sender: Any) {
        stateDropdown.show()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    private func hideAllError(){
        lblErrorCity.isHidden = true
        lblErrorState.isHidden = true
        lblErrorShipto.isHidden = true
        lblErrorAddress.isHidden = true
        lblErrorFullname.isHidden = true
        lblErrorApartment.isHidden = true
        lblErrorTelephone.isHidden = true
        lblErrorZipCode.isHidden = true
    }
    @IBAction func doOrder(_ sender: Any) {
        guard let dictProduct = dictProduct else{
            return
        }
        self.hideAllError()
        if self.validateForm(){
            self.showSimpleHUD()
            var params: Parameters = [:]
            params["uid"] = AppSettings.shared.currentUser?.userId ?? ""
            params["pid"] = dictProduct.object(forKey: "id") as? String ?? ""
            params["shipto"] = txfShipTo.text!.trimmed
            params["name"] = txfFullname.text!.trimmed
            params["address"] = txfAddress.text!.trimmed
            params["apartment"] = txfApartment.text!.trimmed
            params["state"] = txfState.text!.trimmed
            params["city"] = txfcity.text!.trimmed
            params["zip"] = txfZipCode.text!.trimmed
            params["phone"] = txfTelePhone.text!.trimmed
            ManageAPI.shared.buyProduct(params: params) { success, error in
                self.hideLoading()
                if success{
                    self.showAlert(title: nil, message: "Your Query has been submitted to seller. He will respond you ASAP")
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
    
    private func validateForm()-> Bool{
        var isValid = true
//        if txfcity.text!.trimmed.isEmpty{
//            isValid = false
//            lblErrorCity.isHidden = false
//        }
        if txfState.text!.trimmed.isEmpty{
            isValid = false
            lblErrorState.isHidden = false
        }
//        if txfShipTo.text!.trimmed.isEmpty{
//            isValid = false
//            lblErrorShipto.isHidden = false
//        }
        if txfAddress.text!.trimmed.isEmpty{
            isValid = false
            lblErrorAddress.isHidden = false
        }
        if txfFullname.text!.trimmed.isEmpty{
            isValid = false
            lblErrorFullname.isHidden = false
        }
        if !txfApartment.text!.trimmed.isValidEmail(){
            isValid = false
            lblErrorApartment.isHidden = false
        }
        if txfTelePhone.text!.trimmed.isEmpty{
            isValid = false
            lblErrorTelephone.isHidden = false
        }
        if txfZipCode.text!.trimmed.isEmpty{
            isValid = false
            lblErrorZipCode.isHidden = false
        }
        return isValid
    }
}

extension BuyNowViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.hideAllError()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfShipTo{
            txfFullname.becomeFirstResponder()
        }
        else  if textField == txfFullname{
            txfAddress.becomeFirstResponder()
        }
        else  if textField == txfAddress{
            txfApartment.becomeFirstResponder()
        }
        else  if textField == txfApartment{
            txfState.becomeFirstResponder()
        }
        else  if textField == txfState{
            txfcity.becomeFirstResponder()
        }
        else  if textField == txfcity{
            txfZipCode.becomeFirstResponder()
        }
        else  if textField == txfZipCode{
            txfTelePhone.becomeFirstResponder()
        }
        else{
            txfTelePhone.resignFirstResponder()
        }
        return true
    }
}
extension BuyNowViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  cltPhotos.dequeueReusableCell(withReuseIdentifier: "PhotoProductCollect", for: indexPath) as! PhotoProductCollect
        cell.imgPhoto.setImage(with: arrPhotos[indexPath.row], placeholderImage: .photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cltPhotos.frame.size.width, height: self.cltPhotos.frame.size.height)
    }
    
}

extension BuyNowViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        let page = Int(round(scrollView.contentOffset.x/width))
        self.pageControl.currentPage = page
    }
}
