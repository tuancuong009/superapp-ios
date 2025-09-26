//
//  DetailAppViewController.swift
//  SuperApp
//
//  Created by QTS Coder on 25/9/25.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class DetailAppViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblEst: UILabel!
    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var photoImage1: UIImageView!
    @IBOutlet weak var photoImage2: UIImageView!
    @IBOutlet weak var photoImage3: UIImageView!
    @IBOutlet weak var lblNumberMessage: UILabel!
    @IBOutlet weak var viewComment: UIView!
    @IBOutlet weak var imgAvatarComment: UIImageView!
    @IBOutlet weak var lblNameComment: UILabel!
    @IBOutlet weak var lblMessageComment: UILabel!
    @IBOutlet weak var lblDateAgoComment: UILabel!
    var menuObj: MenuAppObj?
    var userObj =  UserObj.init(uid: "", name: "", avatar: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fecthComment()
    }
    private func setupUI()
    {
        guard let menuObj = menuObj else{
            return
        }
        lblTitle.text = menuObj.name
        lblDes.text = menuObj.des
        lblEst.text = menuObj.est
        self.lblUser.text = ""
        self.lblUser.textColor = .blue
        fetchUserProfile(uid: menuObj.user_id) { data in
            if let data = data {
               
                let name = data["name"] as? String ?? ""
                let phone = data["avatar"] as? String ?? ""
                
                let user = UserObj(uid: menuObj.user_id, name: name, avatar: phone)
                self.userObj = user
                self.lblUser.text = (data["name"] as? String ?? "")
               
            } else {
                print("❌ No profile found")
            }
        }
        if menuObj.images.count == 3{
            photoImage1.image = FirebaseImageHelper.base64ToImage(menuObj.images[0])
            photoImage2.image = FirebaseImageHelper.base64ToImage(menuObj.images[1])
            photoImage3.image = FirebaseImageHelper.base64ToImage(menuObj.images[2])
            
            photoImage1.layer.cornerRadius = 10
            photoImage1.layer.borderWidth = 1.0
            photoImage1.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
            
            photoImage2.layer.cornerRadius = 10
            photoImage2.layer.borderWidth = 1.0
            photoImage2.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
            
            photoImage3.layer.cornerRadius = 10
            photoImage3.layer.borderWidth = 1.0
            photoImage3.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        }
        else if menuObj.images.count == 2{
            photoImage1.image = FirebaseImageHelper.base64ToImage(menuObj.images[0])
            photoImage2.image = FirebaseImageHelper.base64ToImage(menuObj.images[1])
            photoImage3.image = nil
            
            photoImage1.layer.cornerRadius = 10
            photoImage1.layer.borderWidth = 1.0
            photoImage1.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
            
            photoImage2.layer.cornerRadius = 10
            photoImage2.layer.borderWidth = 1.0
            photoImage2.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
            
         
        }
        else if menuObj.images.count == 1{
            photoImage1.image = FirebaseImageHelper.base64ToImage(menuObj.images[0])
            photoImage2.image = nil
            photoImage3.image = nil
            photoImage1.layer.cornerRadius = 10
            photoImage1.layer.borderWidth = 1.0
            photoImage1.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        }
        else{
            photoImage1.image = nil
            photoImage2.image = nil
            photoImage3.image = nil
        }
        viewComment.isHidden = true
        imgAvatarComment.layer.cornerRadius = imgAvatarComment.frame.size.height/2
    }
    
    
    func fecthComment(){
        fetchItems { arrs in
            self.lblNumberMessage.text = "(\(arrs.count))"
            if arrs.count > 0 {
                self.viewComment.isHidden = false
                self.configCell(arrs.last!)
            }
        }
    }
    func fetchItems(completion: @escaping ([NSDictionary]) -> Void) {
        guard let menuAppObj = menuObj else{
            return
        }
        let ref = Database.database().reference()
        let appsRef = ref.child(FIREBASE_TABLE.APP_MESSAGES).child(menuAppObj.key)
        
        appsRef.observeSingleEvent(of: .value, with: { snapshot in
            var objects: [NSDictionary] = []
            
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let dict = snap.value as? NSDictionary {
                    objects.append(dict)
                }
            }
            completion(objects)
        }) { error in
            print("❌ Firebase error: \(error.localizedDescription)")
        }
    }
    
    func configCell(_ dict: NSDictionary){
        self.lblNameComment.text = nil
        lblMessageComment.text = dict.object(forKey: "message") as? String
        if let user_id = dict.object(forKey: "user_id") as? String{
            fetchUserProfile(uid: user_id) { data in
                if let data = data {
                    self.lblNameComment.text = data["name"] as? String
                    if let avatar =  data["avatar"] as? String{
                        self.imgAvatarComment.image = FirebaseImageHelper.base64ToImage(avatar)
                    }
                } else {
                    print("❌ No profile found")
                }
            }
        }
        else{
            self.imgAvatarComment.image = UIImage(named: "noavatar")
        }
        
        if let createdAt = dict.object(forKey: "createdAt") as? Double{
            let date = Date(timeIntervalSince1970: createdAt)
            lblDateAgoComment.text = DateHelper.timeAgoTwoDate(date)
        }
        else{
            lblDateAgoComment.text = "Just Now"
        }
    }
    
   
    func fetchUserProfile(uid: String, completion: @escaping ([String: Any]?) -> Void) {
        let ref = Database.database().reference()
        ref.child(FIREBASE_TABLE.USERS).child(uid).observeSingleEvent(of: .value) { snapshot in
            if let data = snapshot.value as? [String: Any] {
                completion(data)
            } else {
                completion(nil)
            }
        }
    }
    @IBAction func doPhoto3(_ sender: Any) {
        guard let image1 = photoImage3.image else{
            return
        }
        let controller = CustomPhotoViewerController(referencedView: photoImage3, image: image1)
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func doPhoto2(_ sender: Any) {
        guard let image1 = photoImage2.image else{
            return
        }
        let controller = CustomPhotoViewerController(referencedView: photoImage2, image: image1)
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func doPhoto1(_ sender: Any) {
        guard let image1 = photoImage1.image else{
            return
        }
        let controller = CustomPhotoViewerController(referencedView: photoImage1, image: image1)
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func doOption(_ sender: Any) {
        let alert = UIAlertController(title: APP_NAME, message: nil, preferredStyle: UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet)
        let hidden = UIAlertAction(title: "Report App", style: .default) { action in
            let reportVC = ReportViewController.init()
            self.present(reportVC, animated: true)
        }
        alert.addAction(hidden)
        let share = UIAlertAction(title: "Share", style: .default) { action in
            guard let menuObj = self.menuObj else{
                return
            }
            self.share(menu: menuObj)
        }
        alert.addAction(share)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
            
        }
        alert.addAction(cancel)
        self.present(alert, animated: true) {
            
        }
    }
    
    @IBAction func doComments(_ sender: Any) {
        let vc = ChatAppViewController.init()
        vc.menuAppObj = menuObj
        self.present(vc, animated: true)
    }
    @IBAction func doViewImage(_ sender: Any) {
        let vc = OtherUserViewController.init()
        vc.user = self.userObj
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func doback(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func share(menu: MenuAppObj) {
       // guard let url = URL(string: link) else { return }
        
        let items: [Any] = [menu]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        // iPad cần sourceView tránh crash
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX,
                                                  y: self.view.bounds.midY,
                                                  width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(activityVC, animated: true)
    }
}
