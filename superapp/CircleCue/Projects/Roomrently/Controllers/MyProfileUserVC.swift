//
//  MyProfileUserVC.swift
//  Roomrently
//
//  Created by QTS Coder on 08/01/2024.
//

import UIKit
import Alamofire
import ImageViewer_swift
class MyProfileUserVC: BaseRRViewController {

    @IBOutlet weak var lblNavi: UILabel!
    @IBOutlet weak var tblDatas: UITableView!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var viewPhone: UIStackView!
    @IBOutlet var viewHeader: UIView!
    var arrPropertys = [NSDictionary]()
    var profileID = ""
    @IBOutlet weak var lblNoData: UILabel!
    var idBook = ""
    var dictProfile: NSDictionary?
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNoData.isHidden = true
        tblDatas.register(UINib.init(nibName: "PropertyCell", bundle: nil), forCellReuseIdentifier: "PropertyCell")
        lblNavi.text = ""
        getMyprofile()
        callApi()
        // Do any additional setup after loading the view.
    }

    @IBAction func doMessage(_ sender: Any) {
        guard let dictProfile = dictProfile else{
            return
        }
        let firstName = dictProfile.object(forKey: "fname") as? String ?? ""
        let lastName = dictProfile.object(forKey: "lname") as? String ?? ""
        if self.isCheckLogin(){
            let vc = SendMessageRRVC.init(nibName: "SendMessageRRVC", bundle: nil)
            vc.profileName = firstName + " " + lastName
            vc.profileID = self.profileID
            vc.idDetailSearch = true
            vc.messageDefault = self.idBook
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            vc.isLogin = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func doViewAvatar(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private func getMyprofile(){
        self.showBusy()
        tblDatas.isHidden = true
        APIRoomrentlyHelper.shared.getProfileUser(profileID) { success, erro in
            self.tblDatas.isHidden = false
            self.hideBusy()
            if let erro = erro{
                self.dictProfile = erro
                self.updateUI(erro)
            }
        }
    }
    private func callApi(){
        let param: Parameters = ["uid": profileID]
        APIRoomrentlyHelper.shared.myPropertyUser(param) { success, arrs in
            self.arrPropertys.removeAll()
            if let arrs = arrs{
                self.arrPropertys = arrs
            }
            self.lblNoData.isHidden = self.arrPropertys.count == 0 ? false : true
            self.tblDatas.isScrollEnabled = self.arrPropertys.count == 0 ? false : true
            self.tblDatas.reloadData()
        }
    }
    private func updateUI(_ dict: NSDictionary){
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.width/2
        imgAvatar.layer.masksToBounds = true
        imgAvatar.layer.borderWidth = 1.0
        imgAvatar.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        let firstName = dict.object(forKey: "fname") as? String ?? ""
        let lastName = dict.object(forKey: "lname") as? String ?? ""
        if lastName.count > 0{
            let l = lastName.prefix(1)
            self.lblNavi.text = firstName + " " + l
        }
        else{
            self.lblNavi.text = firstName
        }
        lblPhone.text = dict.object(forKey: "phone") as? String
        if let phone_status = dict.object(forKey: "phone_status") as? String{
            if phone_status == "1"
            {
                viewPhone.isHidden = true
            }
            else{
                
                viewPhone.isHidden = false
            }
        }
        if let img = dict.object(forKey: "img") as? String{
            imgAvatar.sd_setImage(with: URL.init(string: img))
            imgAvatar.setupImageViewer(
                urls: [URL.init(string: img)!],
                initialIndex: 0,
                options: [
                    
                ],
                from: self)
        }
        self.tblDatas.reloadData()
    }
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension MyProfileUserVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPropertys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDatas.dequeueReusableCell(withIdentifier: "PropertyCell") as! PropertyCell
        cell.updateCell(self.arrPropertys[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailPropertyViewController") as! DetailPropertyViewController
        vc.dictDetail = self.arrPropertys[indexPath.row]
        vc.indexPosition = indexPath.row
        vc.arrDatas = self.arrPropertys
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewPhone.isHidden{
            return 180
        }
        return 250
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
}
