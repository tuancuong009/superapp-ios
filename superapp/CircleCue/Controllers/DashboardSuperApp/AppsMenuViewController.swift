//
//  AppsMenuViewController.swift
//  SuperApp
//
//  Created by QTS Coder on 11/4/25.
//

import UIKit
import LGSideMenuController
class AppsMenuViewController: BaseViewController {
    private var typeDropDown = DropDown()
    @IBOutlet weak var btnType: UIButton!
    @IBOutlet weak var lblTypeSearch: UITextField!
    @IBOutlet weak var txfSearch: CustomTextField!
    @IBOutlet weak var tblApps: UITableView!
    private let types = ["All", "App Name", "Category"]
    private var indexType = 0
    private var appMenus = [NSDictionary]()
    private var appSearchMenus = [NSDictionary]()
    private var arrSearchCateMenus = [NSDictionary]()
    @IBOutlet weak var viewNoData: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    @IBAction func doType(_ sender: Any) {
        typeDropDown.show()
    }
    
    @IBAction func doMenu(_ sender: Any) {
        self.sideMenuController?.showLeftView()
    }
    @IBAction func doSubmitApps(_ sender: Any) {
        self.showOutsideAppWebContent(urlString: "https://www.superapp.app/submitapp.php")
    }
}


extension AppsMenuViewController{
    private func searchCategoryByCategory(_ name: String){
        self.arrSearchCateMenus.removeAll()
        for item in appSearchMenus{
            let cate = item.object(forKey: "category") as? String ?? ""
            if cate.lowercased().contains(name.lowercased()){
                self.arrSearchCateMenus.append(item)
            }
        }
        self.appMenus = arrSearchCateMenus
        self.tblApps.reloadData()
        self.viewNoData.isHidden = self.appMenus.count == 0 ? false : true
    }
    
    private func setupUI(){
        viewNoData.isHidden = true
        txfSearch.tintColor = .blue
        tblApps.registerNibCell(identifier: "AppsMenuTableViewCell")
        typeDropDown.anchorView = btnType
        typeDropDown.dataSource = types
        typeDropDown.bottomOffset = CGPoint(x: 0, y: typeDropDown.frame.height + 2)
        typeDropDown.direction = .bottom
        typeDropDown.textFont = UIFont.myriadProRegular(ofSize: 16)
        typeDropDown.cellHeight = 40
        typeDropDown.animationduration = 0.2
        typeDropDown.backgroundColor = UIColor.white
        typeDropDown.selectionBackgroundColor = UIColor.yellow.withAlphaComponent(0.3)
        typeDropDown.dimmedBackgroundColor = UIColor.black.withAlphaComponent(0.3)
        typeDropDown.selectionAction = {[weak self] (index: Int, item: String) in
            guard let self = self else { return }
            if index == 2{
                let vc = CategoryAppViewController.init()
                vc.tapCategory = { [] value in
                    self.txfSearch.text = nil
                    self.lblTypeSearch.text = value
                    self.indexType = index
                    self.searchCategoryByCategory(value)
                }
                self.present(vc, animated: true)
            }
            else{
                self.lblTypeSearch.text = "\(self.types[index])"
                indexType = index
                txfSearch.text = nil
                appMenus = appSearchMenus
                tblApps.reloadData()
            }
          
        }
        callApi()
    }
    
    private func callApi(){
        self.showSimpleHUD()
        ManageAPI.shared.appMenus { arrs, error in
            self.hideLoading()
            if let arrs = arrs{
                self.appMenus = arrs
            }
            self.appSearchMenus = self.appMenus
            self.tblApps.reloadData()
            self.viewNoData.isHidden = self.appMenus.count == 0 ? false : true
        }
    }
}
extension AppsMenuViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appMenus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblApps.dequeueReusableCell(withIdentifier: "AppsMenuTableViewCell") as! AppsMenuTableViewCell
        cell.configCell(appMenus[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblApps.deselectRow(at: indexPath, animated: true)
        let dict = appMenus[indexPath.row]
        if let link = dict.object(forKey: "ios_app_link") as? String{
            print("link--->",link)
            if let url = URL(string: link), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
}


extension AppsMenuViewController: UITextFieldDelegate{
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.appMenus = self.appSearchMenus
        tblApps.reloadData()
        self.viewNoData.isHidden = self.appMenus.count == 0 ? false : true
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        // Lấy nội dung hiện tại
        let currentText = textField.text ?? ""
        
        // Tạo nội dung mới sau khi thay đổi
        if let textRange = Range(range, in: currentText) {
            let updatedText = currentText.replacingCharacters(in: textRange, with: string)
            if updatedText.isEmpty{
                if indexType == 2{
                    self.appMenus = self.arrSearchCateMenus
                    tblApps.reloadData()
                    self.viewNoData.isHidden = self.appMenus.count == 0 ? false : true
                }
                else{
                    self.appMenus = self.appSearchMenus
                    tblApps.reloadData()
                    self.viewNoData.isHidden = self.appMenus.count == 0 ? false : true
                }
                
            }
            else{
                if indexType == 2{
                    self.appMenus.removeAll()
                   
                    for item in arrSearchCateMenus{
                        let name = item.object(forKey: "app_name") as? String ?? ""
                        if name.lowercased().contains(updatedText.lowercased()){
                            self.appMenus.append(item)
                        }
                    }
                    self.viewNoData.isHidden = self.appMenus.count == 0 ? false : true
                    tblApps.reloadData()
                }
                else{
                    self.appMenus.removeAll()
                   
                    for item in appSearchMenus{
                        let name = item.object(forKey: "app_name") as? String ?? ""
                        let cate = item.object(forKey: "category") as? String ?? ""
                        if indexType == 0 {
                            if name.lowercased().contains(updatedText.lowercased()) || cate.lowercased().contains(updatedText.lowercased()){
                                self.appMenus.append(item)
                            }
                        }
                        else if indexType == 1 {
                            if name.lowercased().contains(updatedText.lowercased()){
                                self.appMenus.append(item)
                            }
                        }
                    }
                    self.viewNoData.isHidden = self.appMenus.count == 0 ? false : true
                    tblApps.reloadData()
                }
            }
        }

        return true // Trả về true để cho phép thay đổi
    }
}

