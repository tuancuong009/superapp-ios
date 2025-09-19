//
//  UpdateAvatarViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 1/19/21.
//

import UIKit

class UpdateAvatarViewController: BaseViewController {

    @IBOutlet weak var avatarImageView: RoundImageView!
    @IBOutlet weak var updateButton: CustomButton!
    @IBOutlet weak var informLabel: UILabel!
    
    private var pickerController: ImagePicker?
    private var picturePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 5
        informLabel.createCustomAttribute(content: "CLICK HERE\nTO\n", highlightContent: "UPLOAD\nPHOTO / LOGO", highlightFont: .myriadProBold(ofSize: 16), highlightColor: .black, contentFont: .myriadProRegular(ofSize: 16), contentColor: .black, paragraphStyle: paragraphStyle)
        pickerController = ImagePicker(presentationController: self, delegate: self, mediaTypes: [.image], allowsEditing: true, iCloud: true)
        picturePath = nil
    }
    
    @IBAction func updateAction(_ sender: Any) {
        guard let userId = AppSettings.shared.userLogin?.userId, let pic = picturePath else {
            self.showErrorAlert(message: "Please upload a photo/logo")
            return
        }
        showSimpleHUD(text: "Updating...")
        ManageAPI.shared.updateUserAvatar(userId, pic: pic) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let err = error {
                    self.showErrorAlert(message: err.msg)
                    return
                }
                if pic.hasPrefix("http") == true {
                    AppSettings.shared.currentUser?.pic = pic
                } else {
                    AppSettings.shared.currentUser?.pic = Constants.UPLOAD_URL + pic
                }
                self.showHomePage()
            }
        }
    }
    
    @IBAction func chooseImageAction(_ sender: Any) {
        self.pickerController?.present(from: self.avatarImageView)
    }
    
    private func showHomePage() {
        let homeVC = BaseNavigationController(rootViewController: CircleFeedNewViewController.instantiate())
        self.switchRootViewController(homeVC)
    }
}

extension UpdateAvatarViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        print(image as Any)
        guard let image = image else { return }
        uploadImage(image: image)
    }
    
    private func uploadImage(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.35) else { return }
        let fileName = "\(randomString()).jpg"
        showSimpleHUD(text: "Uploading...")
        ManageAPI.shared.uploadFile(file: data, fileName) {[weak self] (path, error) in
            guard let self = self else { return }
            if let path = path {
                self.avatarImageView.image = image
                self.informLabel.isHidden = true
                self.picturePath = path
                self.showSuccessHUD(text: "Your photo has been uploaded.")
                return
            }
            self.showErrorHUD(text: error)
        }
    }
}
