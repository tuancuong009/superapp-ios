//
//  HiddenSuperViewController.swift
//  SuperApp
//
//  Created by QTS Coder on 26/3/25.
//

import UIKit

class HiddenSuperViewController: UIViewController {
    var menuAlls = [MenuAppObj.init(id: 1, image: "ic_cc_app", action: .socialMedia, category: "Social Networking"),
                    MenuAppObj.init(id: 2, image: "ic_kk", action: .carRentals, category: "Travel"),
                    MenuAppObj.init(id: 3, image: "ic_rr", action: .roomRentals, category: "Travel"),
                    MenuAppObj.init(id: 4, image: "ic_mr", action: .datingMatch, category: "Social Networking"),
                    MenuAppObj.init(id: 5, image: "app_nn", action: .nextnannies, category: "Child Care"),
                    MenuAppObj.init(id: 6, image: "app_resumerule", action: .resumerule, category: "Jobs & Employment")
                    
    ]
    var menus = [MenuAppObj]()
    @IBOutlet weak var cltMenus: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        cltMenus.registerNibCell(identifier: "SuperCollectionViewCell")
        let menuHidden = SuperAppHelper.shared.getNumbers()
        for item in menuAlls{
            if menuHidden.contains(item.id){
                menus.append(item)
            }
        }
        cltMenus.reloadData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doMenu(_ sender: Any) {
        self.sideMenuController?.showLeftView(animated: true)
    }
}


extension HiddenSuperViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let menu = self.menus[indexPath.row]
        let cell = cltMenus.dequeueReusableCell(withReuseIdentifier: "SuperCollectionViewCell", for: indexPath) as! SuperCollectionViewCell
        cell.lblName.text = menu.action.name
        cell.imgApp.image = UIImage(named: menu.image)
        cell.tapOption = { [] in
            let alert = UIAlertController(title: APP_NAME, message: nil, preferredStyle: .actionSheet)
            let hidden = UIAlertAction(title: "Show App", style: .default) { action in
                SuperAppHelper.shared.removeNumber(menu.id)
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
            return CGSizeMake((cltMenus.frame.size.width - 20)/3, (cltMenus.frame.size.height - 20)/3 + 100)
        }
        else{
            return CGSizeMake((cltMenus.frame.size.width - 10)/2, (cltMenus.frame.size.height - 10)/2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
