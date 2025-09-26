//
//  SuperAppViewController.swift
//  SuperApp
//
//  Created by QTS Coder on 4/3/25.
//

import UIKit
import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import LGSideMenuController
import SDWebImage
struct UserObj {
    var uid: String
    var name: String
    var avatar: String
}
class SuperFirebaseAppViewController: BaseViewController {
    @StateObject var appRouter = AppRouter()
    var menus = [MenuAppObj]()
    var menuSearchs = [MenuAppObj]()
    @IBOutlet weak var txfSearch: CustomTextField!
    @IBOutlet weak var viewNoData: UIStackView!
    @IBOutlet weak var cltMenus: UICollectionView!
    @IBOutlet weak var txfCategory: UITextField!
    @IBOutlet weak var cltUsers: UICollectionView!
    @IBOutlet weak var floatButton: UIButton!
    @IBOutlet weak var loadingApp: UIActivityIndicatorView!
    @IBOutlet weak var loadingUser: UIActivityIndicatorView!
    @IBOutlet weak var btnAddSuperApp: UIButton!
    @IBOutlet weak var viewNavi: UIView!
    @IBOutlet weak var heightNavi: NSLayoutConstraint!
    private let types = ["All", "App Name", "Category"]
    private var indexType = 0
    private var typeDropDown = DropDown()
    private var arrSearchCateMenus = [MenuAppObj]()
    private var users = [UserObj]()
    private var contentOffSet = CGFloat(0)
    private var isToolbarHidden = false
    private var contentOffsetThreshold: CGFloat = 20
    @IBOutlet weak var viewMutipleApp: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        cltMenus.registerNibCell(identifier: "IdeaAppCollectionViewCell")
        cltUsers.registerNibCell(identifier: "UserCollectionViewCell")
        cltUsers.showsHorizontalScrollIndicator = false
        cltMenus.alwaysBounceVertical = true
        txfSearch.tintColor = .blue
        self.viewNoData.isHidden = true
        menuSearchs = menus
        cltMenus.reloadData()
        typeDropDown.anchorView = txfCategory
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
                    self.txfCategory.text = value
                    self.indexType = index
                    self.searchCategoryByCategory(value)
                }
                self.present(vc, animated: true)
            }
            else{
                self.txfCategory.text = "\(self.types[index])"
                indexType = index
                txfSearch.text = nil
                menus = menuSearchs
                cltMenus.reloadData()
            }
          
        }
        
        fetchData()
        // Shadow
        floatButton.layer.shadowColor = UIColor.black.cgColor
        floatButton.layer.shadowOpacity = 0.3
        floatButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        floatButton.layer.shadowRadius = 6
        loadingApp.startAnimating()
        loadingUser.startAnimating()
        NotificationCenter.default.addObserver(self, selector: #selector(registerSuccess), name: NSNotification.Name(rawValue: "REGISTERSSUCCESS"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logoutUsccess), name: NSNotification.Name(rawValue: "LOGOUTSUCCESS"), object: nil)
        btnAddSuperApp.isHidden = true
        // Do any additional setup after loading the view.
    }
    @objc func logoutUsccess(){
        APP_DELEGATE.initSuperApp()
    }
    @objc func registerSuccess(){
        
        let contentView = BaseView().environmentObject(appRouter)
        let swiftUIView = UIHostingController(rootView: contentView)
        self.addChild(swiftUIView)
        swiftUIView.view.frame = self.view.bounds
        self.view.addSubview(swiftUIView.view)
        swiftUIView.didMove(toParent: self)
    }

    private func fetchData(){
        self.fetchItems { arrs in
            self.loadingApp.isHidden = true
            self.menus = arrs.reversed()
            self.menuSearchs = arrs.reversed()
            self.cltMenus.reloadData()
            self.viewNoData.isHidden = self.menus.count == 0 ? false : true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllUsers { arrs in
            self.loadingUser.isHidden = true
            self.users = arrs
            self.cltUsers.reloadData()
        }
       
        
    }
    private func searchCategoryByCategory(_ name: String){
        self.arrSearchCateMenus.removeAll()
        for item in menuSearchs{
            let cate = item.category
            if cate.lowercased().contains(name.lowercased()){
                self.arrSearchCateMenus.append(item)
            }
        }
        self.menus = arrSearchCateMenus
        self.cltMenus.reloadData()
        self.viewNoData.isHidden = self.menus.count == 0 ? false : true
    }
    
    @IBAction func doCategory(_ sender: Any) {
        typeDropDown.show()
    }
    
    @IBAction func changeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            viewMutipleApp.isHidden = false
            btnAddSuperApp.isHidden = true
        }
        else{
            viewMutipleApp.isHidden = true
            btnAddSuperApp.isHidden = false
        }
    }
    
    @IBAction func doRR(_ sender: Any) {
        if APP_DELEGATE.isCheckLogin(){
            APP_DELEGATE.initHome()
        }
        else{
            APP_DELEGATE.initShowCase()
        }
    }
    @IBAction func doKK(_ sender: Any) {
        if (AuthKaKonex.shared.getAccessToken() != nil){
            let contentView = BaseView().environmentObject(appRouter)
            let swiftUIView = UIHostingController(rootView: contentView)
            self.addChild(swiftUIView)
            swiftUIView.view.frame = self.view.bounds
            self.view.addSubview(swiftUIView.view)
            swiftUIView.didMove(toParent: self)
        }
        else{
            let contentView = WelcomeView().environmentObject(appRouter)
            let swiftUIView = UIHostingController(rootView: contentView)
            self.addChild(swiftUIView)
            swiftUIView.view.frame = self.view.bounds
            self.view.addSubview(swiftUIView.view)
            swiftUIView.didMove(toParent: self)
        }
    }
    @IBAction func doMenu(_ sender: Any) {
        self.sideMenuController?.showLeftView(animated: true)
    }

    @IBAction func doAddApp(_ sender: Any) {
        let nextVC = AddNewAppViewController.init()
        nextVC.tapSuccess = { [self] in
            self.showAlert(title: APP_NAME, message: "You idea has been added successfully!")
            self.fetchData()
        }
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func fetchItems(completion: @escaping ([MenuAppObj]) -> Void) {
        let ref = Database.database().reference()
        let appsRef = ref.child(FIREBASE_TABLE.APPS)   // 👈 Không dùng user.uid
        
        appsRef.observeSingleEvent(of: .value, with: { snapshot in
            var objects: [MenuAppObj] = []
            
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let dict = snap.value as? [String: Any] {
                    
                    let obj = MenuAppObj(id: 0, image: "", action: .other, category: "")
                    obj.key = snap.key
                    obj.link = dict["link"] as? String ?? ""
                    obj.name = dict["name"] as? String ?? ""
                    obj.category = dict["category"] as? String ?? ""
                    obj.user_id = dict["user_id"] as? String ?? ""
                    obj.est = dict["est"] as? String ?? ""
                    obj.des = dict["desc"] as? String ?? ""
                    obj.images = dict["screenshots"] as? [String] ?? []
                    objects.append(obj)
                }
            }
            completion(objects)
        }) { error in
            print("❌ Firebase error: \(error.localizedDescription)")
        }
    }

    
    func getAllUsers(completion: @escaping ([UserObj]) -> Void) {
        let ref = Database.database().reference().child(FIREBASE_TABLE.USERS)
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var users: [UserObj] = []
            
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let dict = snap.value as? [String: Any] {
                    
                    let uid = snap.key
                    let name = dict["name"] as? String ?? ""
                    let phone = dict["avatar"] as? String ?? ""
                    
                    let user = UserObj(uid: uid, name: name, avatar: phone)
                    users.append(user)
                }
            }
            
            completion(users)
        })
    }
}


extension SuperFirebaseAppViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cltUsers{
            return users.count
        }
        return menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cltUsers{
            let user = users[indexPath.row]
            let cell = cltUsers.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as! UserCollectionViewCell
            cell.avatarImageView.layer.cornerRadius = 40
            cell.avatarImageView.layer.borderWidth = 1.0
            cell.avatarImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
            if user.avatar.isEmpty{
                cell.avatarImageView.image = nil
                cell.avatarImageView.backgroundColor =  UIColor.randomNotWhite()
                cell.lblCharacter.text = user.name.initials()
            }
            else{
                cell.lblCharacter.text = nil
                cell.avatarImageView.image = FirebaseImageHelper.base64ToImage(user.avatar)
            }
            return cell
        }
        else{
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
       
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cltUsers{
            return CGSizeMake(80, 80)
        }
        if DEVICE_IPAD{
            return CGSizeMake((cltMenus.frame.size.width - 24)/3, ((cltMenus.frame.size.width - 24)/3) * 1.4)
        }
        return CGSizeMake((cltMenus.frame.size.width - 12)/2, ((cltMenus.frame.size.width - 12)/2) * 1.4)
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cltUsers{
            let vc = OtherUserViewController.init()
            vc.user = users[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        let menu = menus[indexPath.row]
        let vc = DetailAppViewController.init()
        vc.menuObj = menu
        self.navigationController?.pushViewController(vc, animated: true)
       
    }
    
    func share(text: String, link: String, from viewController: UIViewController) {
       // guard let url = URL(string: link) else { return }
        
        let items: [Any] = [text, link]
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

extension SuperFirebaseAppViewController: UITextFieldDelegate{
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
            if updatedText.isEmpty{
                if indexType == 2{
                    self.menus = self.arrSearchCateMenus
                    cltMenus.reloadData()
                    self.viewNoData.isHidden = self.menus.count == 0 ? false : true
                }
                else{
                    self.menus = self.menuSearchs
                    cltMenus.reloadData()
                    self.viewNoData.isHidden = self.menus.count == 0 ? false : true
                }
                
            }
            else{
                if indexType == 2{
                    self.menus.removeAll()
                   
                    for item in arrSearchCateMenus{
                        let name = AppSettings.shared.isUseFirebase ? item.name : item.action.name
                        if name.lowercased().contains(updatedText.lowercased()){
                            self.menus.append(item)
                        }
                    }
                    self.viewNoData.isHidden = self.menus.count == 0 ? false : true
                    cltMenus.reloadData()
                }
                else{
                    self.menus.removeAll()
                   
                    for item in menuSearchs{
                        let name = AppSettings.shared.isUseFirebase ? item.name : item.action.name
                        let cate = item.category
                        if indexType == 0 {
                            if name.lowercased().contains(updatedText.lowercased()) || cate.lowercased().contains(updatedText.lowercased()){
                                self.menus.append(item)
                            }
                        }
                        else if indexType == 1 {
                            if name.lowercased().contains(updatedText.lowercased()){
                                self.menus.append(item)
                            }
                        }
                    }
                    self.viewNoData.isHidden = self.menus.count == 0 ? false : true
                    UIView.performWithoutAnimation {
                        self.cltMenus.performBatchUpdates({
                            self.cltMenus.reloadSections(IndexSet(integer: 0))
                        }, completion: nil)
                    }
                }
            }
        }

        return true 
    }
}

extension SuperFirebaseAppViewController: UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        contentOffSet = scrollView.contentOffset.y;
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = scrollView.contentOffset.y
        if scrollPos >= contentOffSet + contentOffsetThreshold {
            if !isToolbarHidden {
                isToolbarHidden = true
                self.hiddenAction() // Fully hide toolbar
            }
        } else if scrollPos < contentOffSet - contentOffsetThreshold {
            if isToolbarHidden {
                isToolbarHidden = false
                self.shownAction() // Slide toolbar back
            }
        }
    }
    
    private func hiddenAction(){
        UIView.animate(withDuration: 0.2, animations: {
            self.viewNavi.alpha = 0
            self.heightNavi.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func shownAction(){
        UIView.animate(withDuration: 0.2, animations: {
            self.viewNavi.alpha = 1.0
            self.heightNavi.constant = 180
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}


extension UIImageView {
    func setAppIcon(from appStoreUrl: String) {
        // Tìm appId trong URL
        guard let idRange = appStoreUrl.range(of: "id\\d+", options: .regularExpression) else {
            print("❌ App ID not found in URL")
            return
        }
        let appId = String(appStoreUrl[idRange]).replacingOccurrences(of: "id", with: "")
        
        // Gọi API lookup
        let urlString = "https://itunes.apple.com/lookup?id=\(appId)&country=vn"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let results = json["results"] as? [[String: Any]],
               let first = results.first,
               let iconUrlString = first["artworkUrl512"] as? String,
               let iconUrl = URL(string: iconUrlString) {
                
                DispatchQueue.main.async {
                    self.sd_setImage(with: iconUrl, placeholderImage: nil)
                }
            }
        }.resume()
    }
}
