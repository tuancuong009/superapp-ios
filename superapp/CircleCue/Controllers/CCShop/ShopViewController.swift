//
//  ShopViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 25/7/24.
//

import UIKit
import Alamofire
import JGProgressHUD
class ShopViewController: UIViewController, TopbarViewDelegate, UIAdaptivePresentationControllerDelegate {
    private let simpleHUD: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.vibrancyEnabled = true
        hud.textLabel.font = UIFont.myriadProRegular(ofSize: 16)
        hud.detailTextLabel.font = UIFont.myriadProRegular(ofSize: 14)
        hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.2)
        hud.contentInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
        return hud
    }()
    @IBOutlet weak var lblNoResult: UILabel!
    @IBOutlet weak var txfPriceTo: CustomTextField!
    @IBOutlet weak var txfAllCategory: UITextField!
    @IBOutlet weak var txfAllType: UITextField!
    @IBOutlet weak var txfAllState: UITextField!
    
    @IBOutlet weak var txfPricefrom: CustomTextField!
    @IBOutlet weak var cltProducts: UICollectionView!
    @IBOutlet weak var btnOption: UIButton!
    var categories = [NSDictionary]()
    @IBOutlet weak var topView: TopbarView!
    var categorySelect: NSDictionary?
    private var categoryDropDown = DropDown()
    private var typeDropdown = DropDown()
    private var stateDropdown = DropDown()
    var categoryStrs = [String]()
    var alltype = [String]()
    var states = [String]()
    var arrProducts = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.delegate = self
        cltProducts.registerNibCell(identifier: "ShopCollectionViewCell")
        self.getCategoryList()
       
        lblNoResult.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.callApiSearch()
    }
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    func editProfile() {
        
    }
    @IBAction func doMyProduct(_ sender: Any) {
      let vc = MenuShopViewController.init()
        vc.preferredContentSize = CGSize(width: 200, height: 200)
        
       vc.modalPresentationStyle = .popover
        vc.tapMyProducts = { [] in
            let vc = MyProductViewController.init()
            vc.categories = self.categories
            vc.categoryStrs = self.categoryStrs
            vc.alltype = self.alltype
            vc.states = self.states
            vc.tapSuccess = { [] in
                self.callApiSearch()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        vc.tapAddProduct = { [] in
            let vc = AddNewShopViewController.init()
            vc.categories = self.categories
            vc.categoryStrs = self.categoryStrs
            vc.alltype = self.alltype
            vc.states = self.states
            vc.tapSuccess = { [] in
                self.callApiSearch()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        vc.tapMyReceived = { [] in
            let vc = InquiryReceivedViewController.init()
            vc.tapSuccess = { [] in
                self.callApiSearch()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
       if let pres = vc.presentationController {
           pres.delegate = self
       }
       self.present(vc, animated: true)
       if let pop = vc.popoverPresentationController {
           pop.sourceView = self.btnOption
           pop.sourceRect = self.btnOption.bounds
       }
        
       
    }
    
    func addNote() {
        
        
    }
    func showSimpleHUD(text: String? = nil, fromView: UIView? = nil) {
        if let text = text {
            simpleHUD.textLabel.text = text
            simpleHUD.contentInsets = UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40)
        } else {
            simpleHUD.textLabel.text = nil
            simpleHUD.contentInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
        }
        
        if let fromView = fromView {
            simpleHUD.show(in: fromView)
        } else {
            simpleHUD.show(in: UIApplication.shared.keyWindow?.rootViewController?.view ?? self.view)
        }
    }
    
    func hideLoading(delay: TimeInterval = 0) {
        simpleHUD.dismiss(afterDelay: delay)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doAllType(_ sender: Any) {
        typeDropdown.show()
    }
    
    @IBAction func doAllCategory(_ sender: Any) {
        categoryDropDown.show()
    }
    @IBAction func doState(_ sender: Any) {
        stateDropdown.show()
    }
    @IBAction func doSearch(_ sender: Any) {
        self.callApiSearch()
    }
}

extension ShopViewController{
    private func setupUI() {
        categoryStrs.removeAll()
        categoryStrs.append("All Category")
        for category in categories{
            if let name = category.object(forKey: "name") as? String{
                categoryStrs.append(name)
            }
        }
        
        alltype.removeAll()
        alltype = ["All Type", "New", "Used"]
        states = ["All State" ,"Alaska", "Alabama", "Arkansas", "American Samoa", "Arizona", "California", "Colorado", "Connecticut", "District of Columbia", "Delaware", "Florida", "Georgia", "Guam", "Hawaii", "Iowa", "Idaho", "Illinois", "Indiana", "Kansas", "Kentucky", "Louisiana", "Massachusetts", "Maryland", "Maine", "Michigan", "Minnesota", "Missouri", "Mississippi", "Montana", "North Carolina", "North Dakota", "Nebraska", "New Hampshire", "New Jersey", "New Mexico", "Nevada", "New York", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Virginia", "Virgin Islands", "Vermont", "Washington", "Wisconsin", "West Virginia", "Wyoming"]
        
    }
    
    private func setupDropdown() {
        categoryDropDown.anchorView = txfAllCategory
        categoryDropDown.dataSource = categoryStrs
        categoryDropDown.bottomOffset = CGPoint(x: 0, y: txfAllCategory.frame.height + 2)
        categoryDropDown.direction = .bottom
        categoryDropDown.textFont = UIFont.myriadProRegular(ofSize: 16)
        categoryDropDown.cellHeight = 40
        categoryDropDown.animationduration = 0.2
        categoryDropDown.backgroundColor = UIColor.white
        categoryDropDown.selectionBackgroundColor = UIColor.yellow.withAlphaComponent(0.3)
        categoryDropDown.dimmedBackgroundColor = UIColor.black.withAlphaComponent(0.3)
        categoryDropDown.selectionAction = {[weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.txfAllCategory.text = item
            if index == 0 {
                self.categorySelect = nil
            }
            else{
                self.categorySelect = self.categories[index - 1]
            }
            
        }
        
        typeDropdown.anchorView = txfAllType
        typeDropdown.dataSource = alltype
        typeDropdown.bottomOffset = CGPoint(x: 0, y: txfAllType.frame.height + 2)
        typeDropdown.direction = .bottom
        typeDropdown.textFont = UIFont.myriadProRegular(ofSize: 16)
        typeDropdown.cellHeight = 40
        typeDropdown.animationduration = 0.2
        typeDropdown.backgroundColor = UIColor.white
        typeDropdown.selectionBackgroundColor = UIColor.yellow.withAlphaComponent(0.3)
        typeDropdown.dimmedBackgroundColor = UIColor.black.withAlphaComponent(0.3)
        typeDropdown.selectionAction = {[weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.txfAllType.text = item
        }
        
        stateDropdown.anchorView = txfAllState
        stateDropdown.dataSource = states
        stateDropdown.bottomOffset = CGPoint(x: 0, y: txfAllState.frame.height + 2)
        stateDropdown.direction = .bottom
        stateDropdown.textFont = UIFont.myriadProRegular(ofSize: 16)
        stateDropdown.cellHeight = 40
        stateDropdown.animationduration = 0.2
        stateDropdown.backgroundColor = UIColor.white
        stateDropdown.selectionBackgroundColor = UIColor.yellow.withAlphaComponent(0.3)
        stateDropdown.dimmedBackgroundColor = UIColor.black.withAlphaComponent(0.3)
        stateDropdown.selectionAction = {[weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.txfAllState.text = item
        }
    }
    
    private func getCategoryList(){
        ManageAPI.shared.categoryList { arrs, error in
            if let arrs = arrs{
                self.categories = arrs
            }
            self.setupUI()
            self.setupDropdown()
        }
    }
    
    private func callApiSearch(){
        self.view.endEditing(true)
        self.showSimpleHUD()
        var params: Parameters = [:]
        if let categorySelect = categorySelect{
            params["cat"] = categorySelect.object(forKey: "id") as? String ?? ""
        }
        if txfAllType.text!.trimmed != "All Type"{
            params["type"] = txfAllType.text!
        }
        if txfAllState.text!.trimmed != "All State"{
            params["state"] = txfAllState.text!
        }
        if !txfPricefrom.text!.trimmed.isEmpty{
            params["pricefrom"] = txfPricefrom.text!
        }
        if !txfPriceTo.text!.trimmed.isEmpty{
            params["priceto"] = txfPriceTo.text!
        }
        ManageAPI.shared.product_listing(params: params) { arrs, error in
            self.hideLoading()
            self.arrProducts.removeAll()
            if let arrs = arrs{
                self.arrProducts = arrs
            }
            self.cltProducts.reloadData()
            self.lblNoResult.isHidden = self.arrProducts.count == 0 ? false : true
        }
    }

}

extension ShopViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cltProducts.dequeueReusableCell(withReuseIdentifier: "ShopCollectionViewCell", for: indexPath) as! ShopCollectionViewCell
        self.configCell(cell, arrProducts[indexPath.row])
        cell.tapBuyNow = { [self] in
            let dict = arrProducts[indexPath.row]
            var  soldInt = 0
            if let sold = dict.object(forKey: "sold") as? String{
                soldInt = Int(sold) ?? 0
            }
            else if let sold = dict.object(forKey: "sold") as? Int{
                soldInt = sold
            }
            if soldInt == 1{
                let vc = DetailProductViewController.init()
                vc.dictProduct = dict
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                let vc = BuyNowViewController.init()
                vc.dictProduct = dict
                self.navigationController?.pushViewController(vc, animated: true)
            }
           
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (cltProducts.frame.size.width - 10)/2, height: 310)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailProductViewController.init()
        vc.dictProduct = arrProducts[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configCell(_ cell: ShopCollectionViewCell, _ dict: NSDictionary){
        if let img1 = dict.object(forKey: "img1") as? String{
            let join = "https://www.circlecue.com/assets/images/product-img/" + img1
            cell.imgCell.setImage(with: join, placeholderImage: .photo)
        }
        else{
            cell.imgCell.image = nil
        }
        cell.lblCondition.text = dict.object(forKey: "condition") as? String
        cell.lblName.text = dict.object(forKey: "itemname") as? String
        cell.lblBadge.text = dict.object(forKey: "category") as? String
        cell.lblCountry.text = dict.object(forKey: "country") as? String
        cell.lblState.text = dict.object(forKey: "state") as? String
        cell.lblPrice.text = "$" + (dict.object(forKey: "price") as? String ?? "")
        if let sold = dict.object(forKey: "sold") as? String{
            cell.lblSold.isHidden = (sold == "1" ? false : true)
            cell.btnInquire.setTitle((sold == "1" ? "View" : "Inquire"), for: .normal)
        }
        else if let sold = dict.object(forKey: "sold") as? Int{
            cell.lblSold.isHidden = (sold == 1 ? false : true)
            cell.btnInquire.setTitle((sold == 1 ? "View" : "Inquire"), for: .normal)
        }
        else{
            cell.lblSold.isHidden = true
        }
    }
}
extension ShopViewController : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
