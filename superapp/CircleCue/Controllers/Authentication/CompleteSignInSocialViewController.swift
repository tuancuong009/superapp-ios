//
//  CompleteSignInSocialViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 4/28/21.
//

import UIKit
import Alamofire

enum SocialLoginType {
    case facebook(_ email: String, _ username: String?)
    case apple(_ token: String, _ username: String?, _ firstName: String?, _ lastName: String?)
    case google(_ email: String, _ username: String?)
}

class CompleteSignInSocialViewController: BaseViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleErrorLabel: UILabel!
    @IBOutlet weak var avatarImageView: RoundImageView!
    @IBOutlet weak var informLabel: UILabel!
    @IBOutlet weak var fNameTexField: UITextField!
    @IBOutlet weak var fNameErrorLabel: UILabel!
    @IBOutlet weak var lNameTextFiled: UITextField!
    @IBOutlet weak var lNameErrorLabel: UILabel!
    
    private var pickerController: ImagePicker?
    private var picturePath: String?
    
    var socialLoginType: SocialLoginType?
    
    private var username: String? {
        didSet {
            usernameTextField.text = username
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        var error: [String] = []
        var para: Parameters = ["app_src": "iOS"]
        if let fname = fNameTexField.trimmedText, !fname.isEmpty {
            para.updateValue(fname, forKey: "fname")
        } else {
            error.append("Missing an valid first name")
            
        }
        if let lname = lNameTextFiled.trimmedText, !lname.isEmpty {
            para.updateValue(lname, forKey: "lname")
        } else {
            error.append("Missing an valid last name")
        }
        if let username = username, !username.isEmpty {
            para.updateValue(username, forKey: "name")
        } else {
            error.append("Missing an valid username")
        }
        
        if let title = titleTextField.trimmedText, !title.isEmpty {
            para.updateValue(title, forKey: "title")
        } else {
            error.append("Missing an Occupation/Title")
        }
        
        if let pic = picturePath {
            para.updateValue(Constants.UPLOAD_URL + pic, forKey: "pic")
        } else {
            error.append("Missing a photo / logo upload")
        }
        
        guard error.isEmpty else {
            self.showErrorAlert(message: error.joined(separator: "\n"))
            return
        }
        
        guard let socialLoginType = socialLoginType else { return }
        
        self.showSimpleHUD()
        switch socialLoginType {
        case .apple(let token, _, _ , _ ):
            para.updateValue(token, forKey: "token")
            para.updateValue("Apple", forKey: "social_login")
        case .facebook(let email, _):
            para.updateValue(email, forKey: "email")
            para.updateValue("Facebook", forKey: "social_login")
        case .google(let email, _):
            para.updateValue(email, forKey: "email")
            para.updateValue("Google", forKey: "social_login")
        }
        
        ManageAPI.shared.loginWithSocial(para) {[weak self] (userId, error) in
            guard let self = self else { return }
            if let userId = userId {
                self.fetchUserInfo(userId: userId)
                return
            }
            self.hideLoading()
            self.showErrorAlert(message: error)
        }
    }
    
    @IBAction func chooseImageAction(_ sender: Any) {
        self.view.endEditing(true)
        self.pickerController?.present(from: self.avatarImageView)
    }
    
    private func showHomePage() {
        let homeVC = BaseNavigationController(rootViewController: CircleFeedNewViewController.instantiate())
        self.switchRootViewController(homeVC)
    }
}

extension CompleteSignInSocialViewController {
    
    private func setupUI() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 5
        informLabel.createCustomAttribute(content: "CLICK HERE\nTO\n", highlightContent: "UPLOAD\nPHOTO / LOGO", highlightFont: .myriadProBold(ofSize: 16), highlightColor: .black, contentFont: .myriadProRegular(ofSize: 16), contentColor: .black, paragraphStyle: paragraphStyle)
        pickerController = ImagePicker(presentationController: self, delegate: self, mediaTypes: [.image], allowsEditing: true, iCloud: true)
        
        usernameTextField.addTarget(self, action: #selector(verify(_:)), for: .editingDidEnd)
        usernameTextField.setPlaceHolderTextColor(.lightText)
        titleTextField.setPlaceHolderTextColor(.lightText)
        fNameTexField.setPlaceHolderTextColor(.lightText)
        lNameTextFiled.setPlaceHolderTextColor(.lightText)
        usernameTextField.addTarget(self, action: #selector(verify(_:)), for: .editingDidEnd)
        titleTextField.addTarget(self, action: #selector(observerInformation(_:)), for: .editingChanged)
        fNameTexField.addTarget(self, action: #selector(observerInformation(_:)), for: .editingChanged)
        lNameTextFiled.addTarget(self, action: #selector(observerInformation(_:)), for: .editingChanged)
        usernameTextField.delegate = self
        titleTextField.delegate = self
        fNameTexField.delegate = self
        lNameTextFiled.delegate = self
    }
    
    private func setupData() {
        picturePath = nil
        usernameErrorLabel.text = nil
        titleErrorLabel.showError(false)
        fNameErrorLabel.text = nil
        lNameErrorLabel.text = nil
        fNameErrorLabel.showError(false)
        lNameErrorLabel.showError(false)
        guard let social = socialLoginType else { return }
        switch social {
        case .apple(_, let username, let firstName, let lastName):
            guard let userName = username else { return }
            let (firstname, lastname) = splitName(userName)
            self.fNameTexField.text = firstname
            self.lNameTextFiled.text = lastname
            //self.checkUserName(username: userName)
        case .facebook(_, let username), .google(_, let username):
            guard let userName = username else { return }
            let (firstname, lastname) = splitName(userName)
            self.fNameTexField.text = firstname
            self.lNameTextFiled.text = lastname
            //self.checkUserName(username: userName)
        }
    }
    
    func splitName(_ name: String) -> (String, String) {
        // Sử dụng Regular Expression để tìm các từ bắt đầu bằng chữ hoa
        let pattern = "[A-Z][a-z]*"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: name.utf16.count)
        
        // Tìm các kết quả phù hợp
        let matches = regex?.matches(in: name, options: [], range: range) ?? []
        let words = matches.compactMap {
            Range($0.range, in: name).map { String(name[$0]) }
        }
        
        if words.count >= 2 {
            let firstname = words[0]
            let lastname = words.dropFirst().joined(separator: " ")
            return (firstname, lastname)
        } else if words.count == 1 {
            // Nếu chỉ có một từ in hoa, gán vào firstname
            return (words[0], "")
        }
        
        return ("", "")
    }
    
    private func fetchUserInfo(userId: String) {
        ManageAPI.shared.fetchUserInfo(userId) {[weak self] (user, error) in
            guard let self = self else { return }
            self.hideLoading()
            if let user = user {
                ManageAPI.shared.updateUserLoginStatus(userId)
                AppSettings.shared.currentUser = user
                AppSettings.shared.saveSocialLogin(userId: userId)
                self.initHomePage()
                return
            }
            self.showAlert(title: "Opps!", message: error)
        }
    }
    
    @objc private func observerInformation(_ textField: UITextField) {
        switch textField {
        case usernameTextField:
            usernameErrorLabel.showError(false)
        case titleTextField:
            titleErrorLabel.showError(false)
        case fNameTexField:
            fNameErrorLabel.showError(false)
        case lNameTextFiled:
            lNameErrorLabel.showError(false)
        default:
            break
        }
    }
    
    @objc private func verify(_ textField: UITextField) {
        guard let username = textField.trimmedText, !username.isEmpty else { return }
        if username.count < 3 {
            self.showAlert(title: "CircleCue", message: "Username must at least 3 letters.", buttonTitles: ["OK"], highlightedButtonIndex: nil) { _ in
                self.usernameTextField.becomeFirstResponder()
            }
        } else {
            verifyUserName(username: username)
        }
    }
    
    private func verifyUserName(username: String) {
        showSimpleHUD(text: "Verify Username...")
        ManageAPI.shared.verifyUsername(username: username) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let err = error {
                    self.username = nil
                    self.usernameErrorLabel.text = err.replacingOccurrences(of: "<br>", with: "\n").replacingOccurrences(of: "<BR>", with: "\n").trimmed
                    self.showErrorAlert(message: err)
                    return
                } else {
                    self.usernameErrorLabel.text = nil
                    self.username = username
                }
            }
        }
    }
    
    private func checkUserName(username: String) {
        showSimpleHUD(text: "Verify Username...")
        ManageAPI.shared.verifyUsername(username: username) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let err = error {
                    self.usernameTextField.text = username
                    self.usernameErrorLabel.text = err.replacingOccurrences(of: "<br>", with: "\n").replacingOccurrences(of: "<BR>", with: "\n").trimmed
                    self.showErrorAlert(message: err)
                    return
                } else {
                    self.usernameErrorLabel.text = nil
                    self.username = username
                }
            }
        }
    }
}

extension CompleteSignInSocialViewController: ImagePickerDelegate {
    
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

extension CompleteSignInSocialViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
