//
//  AddNewAppViewController.swift
//  SuperApp
//
//  Created by QTS Coder on 22/9/25.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class AddNewAppViewController: BaseViewController {

    @IBOutlet weak var txfName: CustomTextField!
    @IBOutlet weak var txfCategory: UITextField!
    @IBOutlet weak var txfLink: CustomTextField!
    @IBOutlet weak var photoImage1: UIImageView!
    @IBOutlet weak var photoImage2: UIImageView!
    @IBOutlet weak var photoImage3: UIImageView!
    @IBOutlet weak var btnPhotoImage1: UIButton!
    @IBOutlet weak var btnPhotoImage2: UIButton!
    @IBOutlet weak var btnPhotoImage3: UIButton!
    @IBOutlet weak var imageAddPhoto1: UIImageView!
    @IBOutlet weak var imageAddPhoto2: UIImageView!
    @IBOutlet weak var imageAddPhoto3: UIImageView!
    @IBOutlet weak var viewImage2: UIView!
    @IBOutlet weak var viewImage3: UIView!
    @IBOutlet weak var tvDes: GrowingTextView!
    var imagePicker: UIImagePickerController!
    private var indexPhoto = 1
    var tapSuccess:(()->())?
    var image1: UIImage? = nil{
        didSet{
            if let image1 = image1{
                photoImage1.image = image1
                imageAddPhoto1.isHidden = true
                btnPhotoImage1.setImage(UIImage(named: "ic_remove"), for: .normal)
            }
            else{
                photoImage1.image = nil
                imageAddPhoto1.isHidden = false
                btnPhotoImage1.setImage(nil, for: .normal)
            }
        }
    }
    
    var image2: UIImage? = nil{
        didSet{
            if let image2 = image2{
                photoImage2.image = image2
                imageAddPhoto2.isHidden = true
                btnPhotoImage2.setImage(UIImage(named: "ic_remove"), for: .normal)
            }
            else{
                photoImage2.image = nil
                imageAddPhoto2.isHidden = false
                btnPhotoImage2.setImage(nil, for: .normal)
            }
        }
    }
    
    var image3: UIImage? = nil{
        didSet{
            if let image3 = image3{
                photoImage3.image = image3
                imageAddPhoto3.isHidden = true
                btnPhotoImage3.setImage(UIImage(named: "ic_remove"), for: .normal)
            }
            else{
                photoImage3.image = nil
                imageAddPhoto3.isHidden = false
                btnPhotoImage3.setImage(nil, for: .normal)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImage1.layer.cornerRadius = 10
        photoImage2.layer.cornerRadius = 10
        photoImage3.layer.cornerRadius = 10
        btnPhotoImage1.setImage(nil, for: .normal)
        btnPhotoImage2.setImage(nil, for: .normal)
        btnPhotoImage3.setImage(nil, for: .normal)
        viewImage2.isHidden = true
        viewImage3.isHidden = true
        imageAddPhoto2.isHidden = true
        imageAddPhoto3.isHidden = true
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doPhoto1(_ sender: Any) {
        if image1 != nil{
            image1 = nil
        }
        else{
            indexPhoto = 1
            showPhotoAndLibrary()
        }
      
    }
    @IBAction func doPhoto2(_ sender: Any) {
        if image2 != nil{
            image2 = nil
        }
        else{
            indexPhoto = 2
            showPhotoAndLibrary()
        }
    }
    @IBAction func doPhoto3(_ sender: Any) {
        if image3 != nil{
            image3 = nil
        }
        else{
            indexPhoto = 3
            showPhotoAndLibrary()
        }
    }
    @IBAction func doCategory(_ sender: Any) {
        let vc = CategoryAppViewController.init()
        vc.tapCategory = { [] value in
            self.txfCategory.text = value
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func doClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func doSubmit(_ sender: Any) {
        let name = txfName.text!.trimmed
        let category = txfCategory.text!.trimmed
        let link = txfLink.text!.trimmed
        let desc = tvDes.text!.trimmed
        if name.isEmpty{
            self.showAlert(title: APP_NAME, message: "Name is required")
            return
        }
        if category.isEmpty{
            self.showAlert(title: APP_NAME, message: "Category is required")
            return
        }
        if link.isEmpty{
            self.showAlert(title: APP_NAME, message: "Estimated Time is required")
            return
        }
        if desc.isEmpty{
            self.showAlert(title: APP_NAME, message: "Description Time is required")
            return
        }
        var arrImages = [String]()
        if let image1 = image1{
            if let base64String = FirebaseImageHelper.imageToBase64(image1)
            {
                arrImages.append(base64String)
            }
        }
        if let image2 = image2{
            if let base64String = FirebaseImageHelper.imageToBase64(image2)
            {
                arrImages.append(base64String)
            }
        }
        if let image3 = image3{
            if let base64String = FirebaseImageHelper.imageToBase64(image3)
            {
                arrImages.append(base64String)
            }
        }
        if arrImages.count == 0{
            self.showAlert(title: APP_NAME, message: "Screenshots is required")
            return
        }
        self.view.endEditing(true)
        guard let user = Auth.auth().currentUser else{
            return
        }
        let ref = Database.database().reference()
        let newKey = ref.child(FIREBASE_TABLE.APPS).childByAutoId()

        let itemData: [String: Any] = [
            "name": name,
            "est": link,
            "category": category,
            "user_id": user.uid,
            "desc": desc,
            "screenshots": arrImages
        ]
        newKey.setValue(itemData)
        self.tapSuccess?()
        self.navigationController?.popViewController(animated: true)
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
extension AddNewAppViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
   
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            
            return
        }
        if indexPhoto == 1 {
            image1 = image
            viewImage2.isHidden = false
            imageAddPhoto2.isHidden = false
        }
        else  if indexPhoto == 2 {
            image2 = image
            viewImage3.isHidden = false
            imageAddPhoto3.isHidden = false
        }
        else{
            image3 = image
        }
        self.dismiss(animated: true)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
            
        }
    }
}
