//
//  MyWantedVC.swift
//  Roomrently
//
//  Created by QTS Coder on 05/04/2024.
//

import UIKit
import Alamofire
class MyWantedVC: BaseRRViewController {

    @IBOutlet weak var lblNoDatas: UILabel!
    @IBOutlet weak var tblDatas: UITableView!
    var arrDatas = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNoDatas.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.callApi()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private func showHideUI(){
        if self.arrDatas.count == 0{
            lblNoDatas.isHidden = false
            tblDatas.isHidden = true
        }
        else{
            lblNoDatas.isHidden = true
            tblDatas.isHidden = false
        }
    }
    
    private func callApi(){
        self.showBusy()
        let param: Parameters = ["uid": UserDefaults.standard.value(forKey: USER_ID_RR) as? String ?? ""]
        APIRoomrentlyHelper.shared.myWanted(param) { success, arrs in
            self.hideBusy()
            self.arrDatas.removeAll()
            if let arrs = arrs{
                self.arrDatas = arrs
            }
            self.showHideUI()
            self.tblDatas.reloadData()
        }
    }
    @IBAction func doBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func doAdd(_ sender: Any) {
        let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "AddWantedVC") as! AddWantedVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MyWantedVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDatas.dequeueReusableCell(withIdentifier: "MyWantedCell") as! MyWantedCell
        configCell(cell: cell, data: arrDatas[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "AddWantedVC") as! AddWantedVC
        vc.dictDetail = arrDatas[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    public func configCell(cell: MyWantedCell, data: NSDictionary){
        if let property = data.object(forKey: "wanted") as? NSDictionary{
            cell.lblCoutry.text = property.object(forKey: "country") as? String
            cell.lblCity.text = property.object(forKey: "city") as? String
            if let seeking = property.object(forKey: "seeking") as? String{
                if seeking == "1"{
                    cell.lblPriceRent.text = ""
                    cell.lblPriceBuy.text = "Price Range to Buy: " + (property.object(forKey: "price_buy") as? String ?? "")
                }
                else if seeking == "2"{
                    cell.lblPriceBuy.text = ""
                    cell.lblPriceRent.text = "Price Range to Rent: " + (property.object(forKey: "price_rent") as? String ?? "")
                }
                else{
                    cell.lblPriceBuy.text = "Price Range to Buy: " + (property.object(forKey: "price_buy") as? String ?? "")
                    cell.lblPriceRent.text = "Price Range to Rent: " + (property.object(forKey: "price_rent") as? String ?? "")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            self.showAlertMessageAction("Do you want to delete?") { success in
                if success{
                    let object = self.arrDatas[indexPath.row]
                    if let property = object.object(forKey: "wanted") as? NSDictionary, let id = property.object(forKey: "id") as? String{
                        self.showBusy()
                        APIRoomrentlyHelper.shared.deleteWant(id) { success, erro in
                            self.hideBusy()
                            if success!{
                                self.callApi()
                            }
                            else{
                                if let er = erro{
                                    self.showAlertMessage(message: er)
                                    
                                }
                            }
                        }
                    }
                }
            }
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
}
