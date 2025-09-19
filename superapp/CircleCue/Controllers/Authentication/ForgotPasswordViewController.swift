//
//  ForgotPasswordViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/3/20.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    weak var delegate: LoginDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetAction(_ sender: Any) {
        view.endEditing(true)
        
        guard let userName = emailTextField.text?.trimmed, !userName.isEmpty else { return }
        showSimpleHUD()
        ManageAPI.shared.resetPassword(userName) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            if let err = error {
                self.showErrorAlert(message: err)
                return
            }
            
            self.showAlert(title: "Successful!", message: "Your password has been sent to your registed email address (also check your spam folder). Please check that. ", buttonTitles: ["OK"], highlightedButtonIndex: 0) { (_) in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func registerAction(_ sender: Any) {
        let controller = RegisterViewController.instantiate(from: StoryboardName.authentication.rawValue)
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ForgotPasswordViewController {
    
    private func setupUI() {
        resetButton.isEnabled = false
        emailErrorLabel.text = nil
        emailTextField.addTarget(self, action: #selector(observerInformation), for: .editingChanged)
    }
    
    private func resetAction() {
    }
    
    @objc private func observerInformation() {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespaces), !email.isEmpty else {
            resetButton.isEnabled = false
            return
        }
        resetButton.isEnabled = true
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
