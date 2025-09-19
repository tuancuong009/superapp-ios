//
//  MyProductViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 5/8/24.
//

import UIKit
import Alamofire
class MyProductViewController: BaseViewController {
    var tapSuccess: (() ->())?
    @IBOutlet weak var lblNoResult: UILabel!
    @IBOutlet weak var tblProducts: UITableView!
    var arrProducts = [NSDictionary]()
    var categoryStrs = [String]()
    var alltype = [String]()
    var states = [String]()
    var categories = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblProducts.registerNibCell(identifier: "MyProductCell")
        self.lblNoResult.isHidden = true
        callApiSearch()
        // Do any additional setup after loading the view.
    }

    override func addNote() {
        let vc = AddNewShopViewController.init()
        vc.categories = self.categories
        vc.categoryStrs = self.categoryStrs
        vc.alltype = self.alltype
        vc.states = self.states
        vc.tapSuccess = { [] in
            self.tapSuccess?()
            self.callApiSearch()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private func callApiSearch(){
        self.showSimpleHUD()
        var params: Parameters = [:]
        params["uid"] = AppSettings.shared.currentUser?.userId ?? ""
        ManageAPI.shared.myproducts(params: params) { arrs, error in
            self.hideLoading()
            self.arrProducts.removeAll()
            if let arrs = arrs{
                self.arrProducts = arrs
            }
            self.tblProducts.reloadData()
            self.lblNoResult.isHidden = self.arrProducts.count == 0 ? false : true
        }
    }
}



extension MyProductViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblProducts.dequeueReusableCell(withIdentifier: "MyProductCell") as! MyProductCell
        self.configCell(cell, arrProducts[indexPath.row])
        cell.tapDelete = { [self] in
            let dict = self.arrProducts[indexPath.row]
            self.showAlert(title: "CircleCue", message: "You have want to delete?", buttonTitles: ["Yes", "No"], highlightedButtonIndex: 1) { (index) in
                if index == 0 {
                    self.showSimpleHUD()
                    let param = ["id": dict.object(forKey: "id") as? String ?? ""]
                    ManageAPI.shared.deleteProduct(params: param) { success, error in
                        self.hideLoading()
                        if success{
                            self.tapSuccess?()
                            self.arrProducts.remove(at: indexPath.row)
                            self.tblProducts.reloadData()
                            self.lblNoResult.isHidden = self.arrProducts.count == 0 ? false : true
                        }
                        else{
                            if let error = error{
                                self.showErrorAlert(message: error)
                            }
                        }
                    }
                } else {
                    
                }
            }
                                        
        }
        
        cell.tapEdit = { [] in
            let vc = AddNewShopViewController.init()
            vc.categories = self.categories
            vc.categoryStrs = self.categoryStrs
            vc.alltype = self.alltype
            vc.states = self.states
            vc.dictProduct = self.arrProducts[indexPath.row]
            vc.tapSuccess = { [] in
                self.tapSuccess?()
                self.callApiSearch()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.tapMakeAsSold = { [] in
            let dict = self.arrProducts[indexPath.row]
            var  soldInt = 0
            if let sold = dict.object(forKey: "sold") as? String{
                soldInt = Int(sold) ?? 0
            }
            else if let sold = dict.object(forKey: "sold") as? Int{
                soldInt = sold
            }
            self.showSimpleHUD()
            let param = ["id": dict.object(forKey: "id") as? String ?? "", "status": soldInt == 1 ? "0" : "1"]
            ManageAPI.shared.updatesoldstatus(params: param) { success, error in
                self.hideLoading()
                if success{
                    self.tapSuccess?()
                    self.callApiSearch()
                }
                else{
                    if let error = error{
                        self.showErrorAlert(message: error)
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblProducts.deselectRow(at: indexPath, animated: true)
        let vc = DetailProductViewController.init()
        vc.dictProduct = arrProducts[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configCell(_ cell: MyProductCell, _ dict: NSDictionary){
        if let img1 = dict.object(forKey: "img1") as? String{
            let join = "https://www.circlecue.com/assets/images/product-img/" + img1
            cell.imgCell.setImage(with: join, placeholderImage: .photo)
        }
        else{
            cell.imgCell.image = nil
        }
        cell.lblCondition.text = dict.object(forKey: "condition") as? String
        cell.lblName.text = dict.object(forKey: "itemname") as? String
        cell.lblCategory.text = dict.object(forKey: "category") as? String
        cell.lblCountry.text = dict.object(forKey: "country") as? String
        cell.lblState.text = dict.object(forKey: "state") as? String
        cell.lblPrice.text = "$" + (dict.object(forKey: "price") as? String ?? "")
        if let sold = dict.object(forKey: "sold") as? String{
            cell.btnMakeAsSold.setTitle((sold == "1" ? "Mark as Available" : "Mark as Sold"), for: .normal)
            cell.btnMakeAsSold.backgroundColor = sold == "1" ? UIColor.red : UIColor.systemGreen
        }
        else if let sold = dict.object(forKey: "sold") as? Int{
            cell.btnMakeAsSold.setTitle((sold == 1 ? "Mark as Available" : "Mark as Sold"), for: .normal)
            cell.btnMakeAsSold.backgroundColor = sold == 1 ? UIColor.red : UIColor.systemGreen
        }
    }
}
