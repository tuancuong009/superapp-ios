//
//  ViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/3/20.
//

import UIKit
import AuthenticationServices
import Alamofire
import FBSDKLoginKit
import GoogleSignIn

protocol LoginDelegate: AnyObject {
    func update(_ withUsername: String?)
}

class LoginVC: AuthenticationViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var socialLoginStackView: UIStackView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!
    
    var isShowingPassword: Bool = false {
        didSet {
            passwordTextField.isSecureTextEntry = !isShowingPassword
            passwordTextField.text = passwordTextField.text
            showPasswordButton.setImage(isShowingPassword ? UIImage(named: "ic_visibility_off") : UIImage(named: "ic_visibility"), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let diffHeight = scrollView.frame.height - containerView.frame.height
        containerTopConstraint.constant = max(diffHeight/2, 10)
    }
    
    @IBAction func backAction(_ sender: Any) {
        AppSettings.shared.discoverUser = nil
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showPasswordAction(_ sender: Any) {
        isShowingPassword.toggle()
    }
    
    @IBAction func forgotAction(_ sender: Any) {
        let controller = ForgotPasswordViewController.instantiate(from: StoryboardName.authentication.rawValue)
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespaces), let password = passwordTextField.text else { return }
        var errors: [Bool] = []
        
        if email.isEmpty {
            emailErrorLabel.showError(true, ErrorMessage.emailEmpty.rawValue)
            errors.append(true)
        } else {
            emailErrorLabel.showError(false)
        }
        
        if password.isEmpty {
            passwordErrorLabel.showError(true, ErrorMessage.passwordIsEmpty.rawValue)
            errors.append(true)
        } else {
            passwordErrorLabel.showError(false)
        }
        
        guard errors.isEmpty else { return }
        
        view.endEditing(true)
        
        performLogin(username: email, password: password)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        let controller = RegisterViewController.instantiate(from: StoryboardName.authentication.rawValue)
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func faceboolLoginAction(_ sender: Any) {
        LoginManager().logOut()
        signInWithFacebook()
    }
    
    @IBAction func didTapGoogleSignButton(_ sender: Any) {
        self.signInWithGoogle()
    }
    
    @IBAction func didTapAppleSignInButton(_ sender: Any) {
        self.performSignInWithApple()
    }
}

extension LoginVC {
    
    private func reset() {
        emailErrorLabel.text = nil
        passwordErrorLabel.text = nil
        loginButton.isEnabled = false
        isShowingPassword = false
        emailTextField.tintColor = UIColor.black
        passwordTextField.tintColor = UIColor.black
    }
    
    private func setupUI() {
        reset()
        emailTextField.addTarget(self, action: #selector(observerInformation(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(observerInformation(_:)), for: .editingChanged)
    }
    
    private func performLogin(username: String, password: String) {
        let para: Parameters = ["type": "1", "id": username, "password": password]
        showSimpleHUD(text: "Login...")
        ManageAPI.shared.login(para) {[weak self] (userID, error) in
            guard let self = self else { return }
            
            if let userID = userID {
                self.fetchUserInfo(userId: userID, username: username, password: password)
                return
            }
            self.hideLoading()
            DispatchQueue.main.async {
                self.showErrorAlert(title: "Oops!", message: error)
            }
        }
    }
    
    private func fetchUserInfo(userId: String, username: String, password: String) {
        ManageAPI.shared.fetchUserInfo(userId) {[weak self] (user, error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let user = user {
                    if user.is_verified {
                        ManageAPI.shared.updateUserLoginStatus(userId)
                        AppSettings.shared.currentUser = user
                        AppSettings.shared.saveLoginInfo(userId: userId, username: username, password: password)
                        self.initHomePage()
                    } else {
                        self.showErrorAlert(message: "Your account is temporary disabled, please contact us for more information.")
                    }
                    return
                }
                self.showAlert(title: "Opps!", message: error)
            }
        }
    }
    
    @objc private func observerInformation(_ textField: UITextField) {
        switch textField {
            case emailTextField:
                emailErrorLabel.showError(false)
            case passwordTextField:
                passwordErrorLabel.showError(false)
            default:
                break
        }
        
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespaces), let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else {
            loginButton.isEnabled = false
            return
        }
        loginButton.isEnabled = true
    }
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            textField.resignFirstResponder()
            loginAction(loginButton as Any)
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
}

extension LoginVC: LoginDelegate {
    func update(_ withUsername: String?) {
        self.reset()
        self.emailTextField.text = withUsername
        self.passwordTextField.text = nil
    }
}
