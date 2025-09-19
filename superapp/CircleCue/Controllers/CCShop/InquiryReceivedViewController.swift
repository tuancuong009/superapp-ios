//
//  InquiryReceived ViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 6/8/24.
//

import UIKit

import Alamofire
class InquiryReceivedViewController: BaseViewController {
    var tapSuccess: (() ->())?
    @IBOutlet weak var lblNoResult: UILabel!
    @IBOutlet weak var tblProducts: UITableView!
    var arrProducts = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblProducts.registerNibCell(identifier: "InquiryReceivedCell")
        self.lblNoResult.isHidden = true
        callApiSearch()
        // Do any additional setup after loading the view.
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
        ManageAPI.shared.InquiryReceived(params: params) { arrs, error in
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



extension InquiryReceivedViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblProducts.dequeueReusableCell(withIdentifier: "InquiryReceivedCell") as! InquiryReceivedCell
        self.configCell(cell, arrProducts[indexPath.row])
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblProducts.deselectRow(at: indexPath, animated: true)
        let dict = arrProducts[indexPath.row]
        let controller = FriendProfileViewController.instantiate()
        controller.basicInfo = UniversalUser(id: dict.object(forKey: "uid") as? String ?? "", username: dict.object(forKey: "username") as? String ?? "", country: "", pic: "")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func configCell(_ cell: InquiryReceivedCell, _ dict: NSDictionary){
        if let img1 = dict.object(forKey: "img1") as? String{
           
            cell.imgCell.setImage(with: img1, placeholderImage: .photo)
        }
        else{
            cell.imgCell.image = nil
        }
        cell.lblName.text = dict.object(forKey: "name") as? String
        cell.lblShipTo.text = dict.object(forKey: "phone") as? String
        cell.lblAddress.text = dict.object(forKey: "address") as? String
        cell.lblApartment.text = dict.object(forKey: "apartment") as? String
        cell.lblBuyerName.text = dict.object(forKey: "username") as? String
    }
}
