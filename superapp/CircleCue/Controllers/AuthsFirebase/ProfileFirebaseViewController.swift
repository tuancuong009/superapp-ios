//
//  ProfileFirebaseViewController.swift
//  SuperApp
//
//  Created by QTS Coder on 23/9/25.
//

import UIKit
import LGSideMenuController
import FirebaseAuth
import FirebaseDatabase
class ProfileFirebaseViewController: BaseViewController {

    @IBOutlet weak var txfName: CustomTextField!
    @IBOutlet weak var txfEmail: CustomTextField!
    @IBOutlet weak var photoImageView: UIImageView!
    var imagePicker: UIImagePickerController!
    var imageAvatar: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let uid = Auth.auth().currentUser?.uid {
            fetchUserProfile(uid: uid) { data in
                if let data = data {
                    self.txfName.text = data["name"] as? String
                    self.txfEmail.text = data["email"] as? String
                    if let avatar =  data["avatar"] as? String{
                        self.photoImageView.image = FirebaseImageHelper.base64ToImage(avatar)
                    }
                } else {
                    print("❌ No profile found")
                }
            }
        }
        photoImageView.layer.cornerRadius = photoImageView.frame.size.height/2
        photoImageView.layer.borderWidth = 1.0
        photoImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        // Do any additional setup after loading the view.
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
    
    @IBAction func doAvatar(_ sender: Any) {
        showPhotoAndLibrary()
    }
    
    @IBAction func doMenu(_ sender: Any) {
        self.sideMenuController?.showLeftView()
    }
    
    @IBAction func doUpdate(_ sender: Any) {
        let name = txfName.text!.trimmed
        
        if name.isEmpty{
            self.showAlert(title: APP_NAME, message: "Name is required")
            return
        }
        view.endEditing(true)
        guard let user = Auth.auth().currentUser else{
            return
        }
        let ref = Database.database().reference()
       
        if let imageAvatar = imageAvatar{
            if let resizedImage = imageAvatar.resizeTo200(),let base64String = FirebaseImageHelper.imageToBase64(resizedImage)
            {
                ref.child(FIREBASE_TABLE.USERS).child(user.uid).updateChildValues(["avatar": base64String])
            }
        }
        ref.child(FIREBASE_TABLE.USERS).child(user.uid).updateChildValues(["name": name])
        self.showAlert(title: APP_NAME, message: "Update successfully!")
        
    }
    @IBAction func doDeleteAccount(_ sender: Any) {
        let alert = UIAlertController(title: APP_NAME, message: "Do you want to delete account?", preferredStyle: UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet)
        let hidden = UIAlertAction(title: "Delete", style: .destructive) { action in
            guard let user = Auth.auth().currentUser else{
                return
            }
           
            user.delete { error in
                if let error = error {
                    //self.showErrorAlert(message: error.localizedDescription)
                    UserDefaults.standard.removeObject(forKey: USER_ID_SUPER_APP)
                    do {
                        try Auth.auth().signOut()
                        APP_DELEGATE.initLoginSuper()
                        print("✅ Logout")
                    } catch let error {
                        print("❌ Fail: \(error.localizedDescription)")
                    }
                    print("❌ Error deleting user: \(error.localizedDescription)")
                } else {
                    let ref = Database.database().reference()
                    ref.child(FIREBASE_TABLE.APPS).child(user.uid).removeValue()
                    ref.child(FIREBASE_TABLE.USERS).child(user.uid).removeValue()
                    UserDefaults.standard.removeObject(forKey: USER_ID_SUPER_APP)
                    APP_DELEGATE.initLoginSuper()
                    print("✅ User account deleted successfully")
                }
            }
        }
        alert.addAction(hidden)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
            
        }
        alert.addAction(cancel)
        self.present(alert, animated: true) {
            
        }
    }
    
    private func showPhotoAndLibrary()
    {
        var stype = UIAlertController.Style.actionSheet
        if DEVICE_IPAD{
            stype = UIAlertController.Style.alert
        }
        
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: stype)
        let camera = UIAlertAction.init(title: "Take a photo", style: .default) { (action) in
            //self.showCamera()
            self.showCamera()
        }
        alert.addAction(camera)
        
        let library = UIAlertAction.init(title: "Choose from library", style: .default) { (action) in
            self.showLibrary()
        }
        alert.addAction(library)
        
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(cancel)
        self.present(alert, animated: true) {
            
        }
    }
    
    private func showCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = ["public.image"]
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
    private func showLibrary()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = ["public.image"]
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
}
extension ProfileFirebaseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
   
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            
            return
        }
        imageAvatar = image
        photoImageView.image = image
        self.dismiss(animated: true)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
            
        }
    }
}
