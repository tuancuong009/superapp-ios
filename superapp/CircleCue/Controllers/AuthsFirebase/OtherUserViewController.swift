//
//  OtherUserViewController.swift
//  SuperApp
//
//  Created by QTS Coder on 23/9/25.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class OtherUserViewController: BaseViewController {
    var menus = [MenuAppObj]()
    var menuSearchs = [MenuAppObj]()
    @IBOutlet weak var txfSearch: CustomTextField!
    @IBOutlet weak var viewNoData: UIStackView!
    @IBOutlet weak var cltMenus: UICollectionView!
    @IBOutlet weak var lblName: UILabel!
    var user: UserObj?
    override func viewDidLoad() {
        super.viewDidLoad()
        cltMenus.registerNibCell(identifier: "IdeaAppCollectionViewCell")
        lblName.text = user?.name
        cltMenus.alwaysBounceVertical = true
        txfSearch.tintColor = .blue
        self.viewNoData.isHidden = true
        menuSearchs = menus
        cltMenus.reloadData()
      
        fetchData()
        // Do any additional setup after loading the view.
    }
    
    private func fetchData(){
        self.fetchItems { arrs in
            self.menus = arrs
            self.menuSearchs = arrs
            self.cltMenus.reloadData()
            self.viewNoData.isHidden = self.menus.count == 0 ? false : true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        
    }
    @IBAction func doReport(_ sender: Any) {
        let alert = UIAlertController(title: APP_NAME, message: nil, preferredStyle: UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet)
        let hidden = UIAlertAction(title: "Report User", style: .default) { action in
            let reportVC = ReportViewController.init()
            self.present(reportVC, animated: true)
        }
        alert.addAction(hidden)
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
            
        }
        alert.addAction(cancel)
        self.present(alert, animated: true) {
            
        }
    }
    
    @IBAction func doMenu(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

   
    
    func fetchItems(completion: @escaping ([MenuAppObj]) -> Void) {
        guard let user = user else{
            completion([MenuAppObj]())
            return
        }
        let ref = Database.database().reference()
        let appsRef = ref.child(FIREBASE_TABLE.APPS)   // 👈 Không dùng user.uid
        
        appsRef.observeSingleEvent(of: .value, with: { snapshot in
            var objects: [MenuAppObj] = []
            
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let dict = snap.value as? [String: Any] {
                    let user_id = dict["user_id"] as? String ?? ""
                    let obj = MenuAppObj(id: 0, image: "", action: .other, category: "")
                    obj.key = snap.key
                    obj.link = dict["link"] as? String ?? ""
                    obj.name = dict["name"] as? String ?? ""
                    obj.category = dict["category"] as? String ?? ""
                    obj.user_id = user_id
                    obj.est = dict["est"] as? String ?? ""
                    obj.des = dict["desc"] as? String ?? ""
                    obj.images = dict["screenshots"] as? [String] ?? []
                    if user.uid == user_id{
                        objects.append(obj)
                    }
                    
                }
            }
            completion(objects)
        }) { error in
            print("❌ Firebase error: \(error.localizedDescription)")
        }
    }

}


extension OtherUserViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let menu = menus[indexPath.row]
        let cell = cltMenus.dequeueReusableCell(withReuseIdentifier: "IdeaAppCollectionViewCell", for: indexPath) as! IdeaAppCollectionViewCell
        cell.lblName.text = menu.name
        cell.imageView.layer.cornerRadius = 10
        cell.imageView.layer.borderWidth = 1.0
        cell.imageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        if menu.images.count > 0 {
            cell.imageView.image = FirebaseImageHelper.base64ToImage(menu.images[0])
        }
        else{
            cell.imageView.image = nil
        }
        cell.tapOption = { [self] in
            let alert = UIAlertController(title: APP_NAME, message: nil, preferredStyle: UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet)
            let hidden = UIAlertAction(title: "Report", style: .default) { action in
                let reportVC = ReportViewController.init()
                self.present(reportVC, animated: true)
            }
            alert.addAction(hidden)
            
            let share = UIAlertAction(title: "Share", style: .default) { action in
                self.share(text: menu.name, link: menu.des, from: self)
            }
            alert.addAction(share)
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
                
            }
            alert.addAction(cancel)
            self.present(alert, animated: true) {
                
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if DEVICE_IPAD{
            return CGSizeMake((cltMenus.frame.size.width - 24)/3, ((cltMenus.frame.size.width - 24)/3) * 1.4)
        }
        return CGSizeMake((cltMenus.frame.size.width - 12)/2, ((cltMenus.frame.size.width - 12)/2) * 1.4)
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        let menu = menus[indexPath.row]
        let vc = DetailAppViewController.init()
        vc.menuObj = menu
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func share(text: String, link: String, from viewController: UIViewController) {
       
        
        let items: [Any] = [text]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        // iPad cần sourceView tránh crash
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX,
                                                  y: viewController.view.bounds.midY,
                                                  width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        viewController.present(activityVC, animated: true)
    }
}

extension OtherUserViewController: UITextFieldDelegate{
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.menus = self.menuSearchs
        cltMenus.reloadData()
        self.viewNoData.isHidden = self.menus.count == 0 ? false : true
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        if let textRange = Range(range, in: currentText) {
            let updatedText = currentText.replacingCharacters(in: textRange, with: string)
            self.menus.removeAll()
            print(menuSearchs.count)
            for item in menuSearchs{
                let name = item.name
                if name.lowercased().contains(updatedText.lowercased()){
                    self.menus.append(item)
                }
            }
            self.viewNoData.isHidden = self.menus.count == 0 ? false : true
            UIView.performWithoutAnimation {
                self.cltMenus.performBatchUpdates({
                    self.cltMenus.reloadSections(IndexSet(integer: 0))
                }, completion: nil)
            }
        }

        return true
    }
}

