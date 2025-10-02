//
//  SuperAppViewController.swift
//  SuperApp
//
//  Created by QTS Coder on 4/3/25.
//

import UIKit
import SwiftUI
import LGSideMenuController

class SuperAppViewController: BaseViewController {
    @StateObject var appRouter = AppRouter()
    var menuAlls = [MenuAppObj.init(id: 1, image: "ic_cc_app", action: .socialMedia, category: "Social Networking"),
                    MenuAppObj.init(id: 2, image: "ic_kk", action: .carRentals, category: "Travel"),
                    MenuAppObj.init(id: 3, image: "ic_rr", action: .roomRentals, category: "Travel"),
                    MenuAppObj.init(id: 4, image: "ic_mr", action: .datingMatch, category: "Social Networking"),
                    MenuAppObj.init(id: 5, image: "app_nn", action: .nextnannies, category: "Child Care"),
                    MenuAppObj.init(id: 6, image: "app_resumerule", action: .resumerule, category: "Jobs & Employment"),
                    MenuAppObj.init(id: 7, image: "app_rv", action: .appReviews, category: "Lifestyle"),
                    MenuAppObj.init(id: 8, image: "app_kkredit", action: .kreditKorp, category: "Finance")
    ]
    var menus = [MenuAppObj]()
    var menuSearchs = [MenuAppObj]()
    @IBOutlet weak var txfSearch: CustomTextField!
    @IBOutlet weak var viewNoData: UIStackView!
    @IBOutlet weak var cltMenus: UICollectionView!
    @IBOutlet weak var txfCategory: UITextField!
    private let types = ["All", "App Name", "Category"]
    private var indexType = 0
    private var typeDropDown = DropDown()
    private var arrSearchCateMenus = [MenuAppObj]()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(registerSuccess), name: NSNotification.Name(rawValue: "REGISTERSSUCCESS"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logoutUsccess), name: NSNotification.Name(rawValue: "LOGOUTSUCCESS"), object: nil)
        cltMenus.registerNibCell(identifier: "SuperCollectionViewCell")
        let menuHidden = SuperAppHelper.shared.getNumbers()
        for item in menuAlls{
            if !menuHidden.contains(item.id){
                menus.append(item)
            }
        }
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
        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doMat(_ sender: Any) {
        APP_DELEGATE.rootApp()
    }
    @IBAction func doKar(_ sender: Any) {
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
    
    @IBAction func doSocial(_ sender: Any) {
        let vc = AutoLoginViewController.instantiate(from: StoryboardName.authentication.rawValue)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func doRR(_ sender: Any) {
        if APP_DELEGATE.isCheckLogin(){
            APP_DELEGATE.initHome()
        }
        else{
            APP_DELEGATE.initShowCase()
        }
    }
}


extension SuperAppViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let menu = self.menus[indexPath.row]
        let cell = cltMenus.dequeueReusableCell(withReuseIdentifier: "SuperCollectionViewCell", for: indexPath) as! SuperCollectionViewCell
       
        cell.lblName.text = menu.action.name
        cell.imgApp.image = UIImage(named: menu.image)
        cell.tapOption = { [] in
            let alert = UIAlertController(title: APP_NAME, message: nil, preferredStyle: UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet)
            let hidden = UIAlertAction(title: "Hide App", style: .default) { action in
                SuperAppHelper.shared.addNumber(menu.id)
                self.menus.remove(at: indexPath.row)
                self.cltMenus.reloadData()
            }
            alert.addAction(hidden)
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
                
            }
            alert.addAction(cancel)
            self.present(alert, animated: true) {
                
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSizeMake((UIScreen.main.bounds.size.width - 70)/3, (UIScreen.main.bounds.size.width - 70)/3 + 100)
        }
        else{
            return CGSizeMake((cltMenus.frame.size.width - 10)/2.2, (cltMenus.frame.size.height - 10)/2.2)
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let menu = self.menus[indexPath.row]
        if menu.action == .socialMedia{
            self.doSocial(Any.self)
        }
        else if menu.action == .carRentals{
            self.doKar(Any.self)
        }
        else if menu.action == .roomRentals{
            self.doRR(Any.self)
        }
        else if menu.action == .datingMatch{
            self.doMat(Any.self)
        }
        else if menu.action == .nextnannies{
            let nextVC = WebSuperViewController.init()
            nextVC.url = "https://nextnannies.com/"
            nextVC.titleNavi = menu.action.name
            nextVC.modalPresentationStyle = .fullScreen
            present(nextVC, animated: true)
        }
        else if menu.action == .resumerule{
            let nextVC = WebSuperViewController.init()
            nextVC.url = "https://resumerule.com"
            nextVC.titleNavi = menu.action.name
            nextVC.modalPresentationStyle = .fullScreen
            present(nextVC, animated: true)
        }
        else if menu.action == .appReviews{
            let nextVC = WebSuperViewController.init()
            nextVC.url = "https://appreviews.net/index.html"
            nextVC.titleNavi = menu.action.name
            nextVC.modalPresentationStyle = .fullScreen
            present(nextVC, animated: true)
        }
        else if menu.action == .kreditKorp{
            let nextVC = WebSuperViewController.init()
            nextVC.url = "http://www.kreditkorp.com"
            nextVC.titleNavi = menu.action.name
            nextVC.modalPresentationStyle = .fullScreen
            present(nextVC, animated: true)
        }
    }
}

class MenuAppObj: NSObject{
    
    var id: Int = 0
    var key: String = ""
    var link: String = ""
    var image: String  = ""
    var name: String = ""
    var action: MenuSuperAction = .other
    var category: String  = ""
    var user_id: String = ""
    var est: String = ""
    var des: String = ""
    var images: [String] = []
    init(id: Int, image: String, action: MenuSuperAction, category: String) {
        self.id = id
        self.image = image
        self.action = action
        self.category = category
    }
}


enum MenuSuperAction: Int{
    case socialMedia
    case carRentals
    case roomRentals
    case datingMatch
    case nextnannies
    case resumerule
    case appReviews
    case kreditKorp
    case other
    var name: String{
        switch self {
        case .socialMedia:
            return "Social Media"
      
        case .carRentals:
            return "Car Rentals"
        case .roomRentals:
            return "Room Rentals"
        case .datingMatch:
            return "Dating Match"
        case .other:
            return ""
        case .nextnannies:
            return "Next Nannies"
        case .resumerule:
            return "ResumeRule"
        case .appReviews:
            return "AppReviews"
        case .kreditKorp:
            return "KreditKorp"
        }
    }
}
extension SuperAppViewController: UITextFieldDelegate{
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
                        let name = item.action.name
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
                        let name = item.action.name
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
                    cltMenus.reloadData()
                }
            }
        }

        return true 
    }
}
