//
//  ChangePasswordViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/6/20.
//

import UIKit
import Alamofire

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var oldPassErrorLabel: UILabel!
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPassErrorLabel: UILabel!
    
    @IBOutlet weak var confirmPassErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var showOldPasswordBtn: UIButton!
    @IBOutlet weak var showNewPasswordBtn: UIButton!
    @IBOutlet weak var showConfirmPasswordBtn: UIButton!
        
    var isShowingOldPassword: Bool = false {
        didSet {
            oldPasswordTextField.isSecureTextEntry = !isShowingOldPassword
            oldPasswordTextField.text = oldPasswordTextField.text
            showOldPasswordBtn.setImage(isShowingOldPassword ? #imageLiteral(resourceName: "ic_visibility_off") : #imageLiteral(resourceName: "ic_visibility"), for: .normal)
        }
    }
    
    var isShowingNewPassword: Bool = false {
        didSet {
            newPasswordTextField.isSecureTextEntry = !isShowingNewPassword
            newPasswordTextField.text = newPasswordTextField.text
            showNewPasswordBtn.setImage(isShowingNewPassword ? #imageLiteral(resourceName: "ic_visibility_off") : #imageLiteral(resourceName: "ic_visibility"), for: .normal)
        }
    }
    
    var isShowingConfirmPassword: Bool = false {
        didSet {
            confirmPasswordTextField.isSecureTextEntry = !isShowingConfirmPassword
            confirmPasswordTextField.text = confirmPasswordTextField.text
            showConfirmPasswordBtn.setImage(isShowingConfirmPassword ? #imageLiteral(resourceName: "ic_visibility_off") : #imageLiteral(resourceName: "ic_visibility"), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func showHidePassword(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            isShowingOldPassword.toggle()
        case 1:
            isShowingNewPassword.toggle()
        default:
            isShowingConfirmPassword.toggle()
        }
    }
    
    @IBAction func submitAction(_ sender: Any) {
        var newPassword: String = ""
        var para = Parameters()
        var errors: [Bool] = []
        if let oldPass = oldPasswordTextField.text?.trimmed, !oldPass.isEmpty {
            oldPassErrorLabel.showError(false)
            para.updateValue(oldPass, forKey: "oldpassword")
        } else {
            oldPassErrorLabel.showError(true, ErrorMessage.passwordIsEmpty.rawValue)
            errors.append(true)
        }
        
        if let newPass = newPasswordTextField.text?.trimmed, !newPass.isEmpty {
            newPassErrorLabel.showError(false)
            para.updateValue(newPass, forKey: "newpassword")
            newPassword = newPass
        } else {
            newPassErrorLabel.showError(true, ErrorMessage.newPasswordIsEmpty.rawValue)
            errors.append(true)
        }
        
        if let confirmPass = confirmPasswordTextField.text?.trimmed, !confirmPass.isEmpty {
            if confirmPass == newPasswordTextField.text?.trimmed {
                confirmPassErrorLabel.showError(false)
                para.updateValue(confirmPass, forKey: "confirmpassword")
            } else {
                confirmPassErrorLabel.showError(true, ErrorMessage.confirmDoesNotMatch.rawValue)
                errors.append(true)
            }
        } else {
            confirmPassErrorLabel.showError(true, ErrorMessage.newPasswordIsEmpty.rawValue)
            errors.append(true)
        }
        
        guard errors.isEmpty, let userId = AppSettings.shared.userLogin?.userId else { return }
        view.endEditing(true)
        
        para.updateValue(userId, forKey: "id")
        changePassword(para: para, newPassword: newPassword)
    }
}

extension ChangePasswordViewController {
    
    private func setupUI() {
        oldPasswordTextField.text = nil
        newPasswordTextField.text = nil
        confirmPasswordTextField.text = nil
        
        oldPassErrorLabel.text = nil
        newPassErrorLabel.text = nil
        confirmPassErrorLabel.text = nil
        
        isShowingOldPassword = false
        isShowingNewPassword = false
        isShowingConfirmPassword = false
    }
    
    private func changePassword(para: Parameters?, newPassword: String) {
        showSimpleHUD(text: "Updating...")
        ManageAPI.shared.changePassword(para) {[weak self] (error) in
            guard let self = self else { return }
            if let err = error {
                self.hideLoading()
                self.showErrorAlert(message: err)
                return
            }
            AppSettings.shared.updateNewPassword(newPassword)
            self.setupUI()
            self.showSuccessHUD(text: "Your password has been updated.")
        }
    }
}
