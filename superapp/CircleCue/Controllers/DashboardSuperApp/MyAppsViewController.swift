//
//  MyAppsViewController.swift
//  SuperApp
//
//  Created by QTS Coder on 11/4/25.
//

import UIKit
import LGSideMenuController
import SafariServices
import FirebaseAuth
import FirebaseDatabase
class MyAppsViewController: BaseViewController {
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
    @IBOutlet weak var lblNavi: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if AppSettings.shared.isUseFirebase{
            lblNavi.text = "My IDEAs"
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func doType(_ sender: Any) {
        typeDropDown.show()
    }
    
   
    @IBAction func doMenu(_ sender: Any) {
        self.sideMenuController?.showLeftView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AppSettings.shared.isUseFirebase{
            self.fetchItems { arrs in
                self.appMenus = arrs
                self.appSearchMenus = self.appMenus
                self.tblApps.reloadData()
                self.viewNoData.isHidden = self.appMenus.count == 0 ? false : true
            }
        }
        else{
            callApi()
        }
       
        self.lblTypeSearch.text = "All"
        txfSearch.text = ""
        self.indexType = 0
    }
    @IBAction func doAdd(_ sender: Any) {
        if AppSettings.shared.isUseFirebase{
            let nextVC = AddNewAppViewController.init()
            nextVC.tapSuccess = { [] in
                
            }
            navigationController?.pushViewController(nextVC, animated: true)
        }
        else{
            print("https://superapp.app/add_app.php?uid=\( UserDefaults.standard.value(forKey: USER_ID_SUPER_APP) as? String ?? "")")
            if let url = URL.init(string: "https://superapp.app/add_app.php?uid=\( UserDefaults.standard.value(forKey: USER_ID_SUPER_APP) as? String ?? "")"){
                let vc = SFSafariViewController(url: url)
                present(vc, animated: true)
            }
        }
       
    }
    
    func fetchItems(completion: @escaping ([NSDictionary]) -> Void) {
        let currentUser =  Auth.auth().currentUser?.uid ?? ""
        let ref = Database.database().reference()
        let appsRef = ref.child(FIREBASE_TABLE.APPS)   // 👈 Không dùng user.uid
        
        appsRef.observeSingleEvent(of: .value, with: { snapshot in
            var objects: [NSDictionary] = []
            
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let dict = snap.value as? [String: Any] {
                    let user_id = dict["user_id"] as? String ?? ""
                    if currentUser == user_id{
                        var newDict = dict
                        newDict["key"] = snap.key   // 👈 thêm key vào dict
                        objects.append(newDict as NSDictionary)
                    }
                   
                }
            }
            completion(objects)
        }) { error in
            print("❌ Firebase error: \(error.localizedDescription)")
        }
    }
}


extension MyAppsViewController{
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
        tblApps.registerNibCell(identifier: "MyAppTableViewCell")
        tblApps.registerNibCell(identifier: "MyAppFirebaseTableViewCell")
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
       
    }
    
    private func callApi(){
        self.showSimpleHUD()
        ManageAPI.shared.myAPps { arrs, error in
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
extension MyAppsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appMenus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblApps.dequeueReusableCell(withIdentifier:AppSettings.shared.isUseFirebase ? "MyAppFirebaseTableViewCell" : "MyAppTableViewCell") as! MyAppTableViewCell
        if AppSettings.shared.isUseFirebase{
            cell.configCellFirebase(appMenus[indexPath.row])
        }
        else{
            cell.configCellMyAPp(appMenus[indexPath.row])
        }
        
        cell.tapOption = { [self] in
            var style = UIAlertController.Style.actionSheet
            if DEVICE_IPAD{
                style = UIAlertController.Style.alert
            }
            let alert = UIAlertController(title: APP_NAME,
                                          message: nil,
                                          preferredStyle: style)
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            
            let delete = UIAlertAction.init(title: "Delete", style: .destructive) { action in
                self.showAlertDetele(indexPath)
            }
            alert.addAction(delete)
            self.present(alert, animated: true, completion: nil)
        }
        return cell
    }
    
    private func showAlertDetele(_ indexPath: IndexPath){
        let style = UIAlertController.Style.alert
       
        let alert = UIAlertController(title: APP_NAME,
                                      message: "Do you want to delete?",
                                      preferredStyle: style)
        let cancelAction = UIAlertAction(title: "No",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        let delete = UIAlertAction.init(title: "Yes", style: .destructive) { action in
            let value = self.appMenus[indexPath.row]
            if AppSettings.shared.isUseFirebase{
                if let id = value.object(forKey: "key") as? String{
                    let ref = Database.database().reference()
                    ref.child(FIREBASE_TABLE.APPS).child(id).removeValue()
                    self.fetchItems { arrs in
                        self.appMenus = arrs
                        self.appSearchMenus = self.appMenus
                        self.tblApps.reloadData()
                        self.viewNoData.isHidden = self.appMenus.count == 0 ? false : true
                    }
                }
            }
            else{
                if  let dict = value.object(forKey: "business_name") as? NSDictionary{
                    if let id = dict.object(forKey: "id") as? String{
                        self.showSimpleHUD()
                        ManageAPI.shared.deleteMyApp(id) { vale, error in
                            self.callApi()
                        }
                    }
                }
            }
            
        }
        alert.addAction(delete)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppSettings.shared.isUseFirebase ? 100 : 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblApps.deselectRow(at: indexPath, animated: true)
        let value = appMenus[indexPath.row]
        if AppSettings.shared.isUseFirebase{
            return
        }
        else{
            if  let dict = value.object(forKey: "business_name") as? NSDictionary{
                if let link = dict.object(forKey: "app_link") as? String{
                    print("link--->",link)
                    if let url = URL(string: link), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
        
    }
}


extension MyAppsViewController: UITextFieldDelegate{
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
                self.appMenus = self.appSearchMenus
                tblApps.reloadData()
                self.viewNoData.isHidden = self.appMenus.count == 0 ? false : true
                
            }
            else{
                self.appMenus.removeAll()
               
                for item in appSearchMenus{
                    if AppSettings.shared.isUseFirebase{
                        let name = item.object(forKey: "name") as? String ?? ""
                        let cate = item.object(forKey: "link") as? String ?? ""
                        if name.lowercased().contains(updatedText.lowercased()) || cate.lowercased().contains(updatedText.lowercased()){
                            self.appMenus.append(item)
                        }
                    }
                    else{
                        if  let dict = item.object(forKey: "business_name") as? NSDictionary{
                            let name = dict.object(forKey: "app_name") as? String ?? ""
                            let cate = dict.object(forKey: "app_link") as? String ?? ""
                            if name.lowercased().contains(updatedText.lowercased()) || cate.lowercased().contains(updatedText.lowercased()){
                                self.appMenus.append(item)
                            }
                        }
                    }
                   
                }
                self.viewNoData.isHidden = self.appMenus.count == 0 ? false : true
                tblApps.reloadData()
            }
        }

        return true // Trả về true để cho phép thay đổi
    }
}

