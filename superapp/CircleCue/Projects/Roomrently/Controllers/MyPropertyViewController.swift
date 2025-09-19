//
//  MyPropertyViewController.swift
//  Roomrently
//
//  Created by QTS Coder on 18/09/2023.
//

import UIKit
import Alamofire
import LGSideMenuController
class MyPropertyViewController: BaseRRViewController {

    @IBOutlet weak var tblDatas: UITableView!
    @IBOutlet weak var lblNoDatas: UILabel!
    @IBOutlet weak var btnListMenu: UIButton!
    @IBOutlet weak var btnList: UIButton!
    @IBOutlet weak var btnMenuApp: UIButton!
    var arrPropertys = [NSDictionary]()
    var isProfile = false
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNoDatas.isHidden = true
        btnList.isHidden = true
        btnListMenu.isHidden = true
        if isProfile{
            btnMenuApp.setImage(UIImage.init(named: "btn_backrr"), for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callApi()
    }
    private func callApi(){
        self.showBusy()
        let param: Parameters = ["uid": UserDefaults.standard.value(forKey: USER_ID_RR) as? String ?? ""]
        APIRoomrentlyHelper.shared.myProperty(param) { success, arrs in
            self.hideBusy()
            self.arrPropertys.removeAll()
            if let arrs = arrs{
                self.arrPropertys = arrs
            }
            self.showHideUI()
            self.tblDatas.reloadData()
        }
    }

    @IBAction func doList(_ sender: Any) {
        let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doMenuApp(_ sender: Any) {
        if !self.isProfile{
            self.sideMenuController?.showLeftView(animated: true)
        }
        else{
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func showHideUI(){
        if self.arrPropertys.count == 0{
            lblNoDatas.isHidden = false
            tblDatas.isHidden = true
            btnList.isHidden = false
            btnListMenu.isHidden = true
        }
        else{
            lblNoDatas.isHidden = true
            tblDatas.isHidden = false
            btnList.isHidden = true
            btnListMenu.isHidden = false
        }
    }
}

extension MyPropertyViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPropertys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDatas.dequeueReusableCell(withIdentifier: "PropertyCell") as! PropertyCell
        cell.updateCell(self.arrPropertys[indexPath.row])
        cell.tapOption = { [] in
            var stype = UIAlertController.Style.actionSheet
            if DEVICE_IPAD{
                stype = UIAlertController.Style.alert
            }
            let alert = UIAlertController(title: APP_NAME,
                                          message: nil,
                                          preferredStyle: stype)
            let edit = UIAlertAction(title: "Edit",
                                             style: .default) { action in
                let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
                vc.dictEdit = self.arrPropertys[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            alert.addAction(edit)
            
            let delete = UIAlertAction.init(title: "Delete", style: .destructive) { action in
                self.showAlertMessageAction("Are you sure you want to delete?") { success in
                    if success{
                        let dict = self.arrPropertys[indexPath.row]
                        if let  property = dict.object(forKey: "property") as? NSDictionary, let id = property.object(forKey: "id") as? String{
                            let param : Parameters = ["id": id]
                            self.showBusy()
                            APIRoomrentlyHelper.shared.deleteProperty(param) { success, erro in
                                self.hideBusy()
                                if success!{
                                    self.arrPropertys.remove(at: indexPath.row)
                                    self.tblDatas.reloadData()
                                    self.showHideUI()
                                }
                                else{
                                    if let erro = erro{
                                        self.showAlertMessage(message: erro)
                                    }
                                }
                            }
                        }
                    }
                }
               
            }
            alert.addAction(delete)
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel) { action in
                
            }
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "DetailPropertyViewController") as! DetailPropertyViewController
        vc.dictDetail = self.arrPropertys[indexPath.row]
        vc.indexPosition = indexPath.row
        vc.arrDatas = self.arrPropertys
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
