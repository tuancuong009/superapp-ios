//
//  AccountStatusViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 29/10/2021.
//

import UIKit

enum AccountStatus: Int {
    case active = 1
    case deactivate = 0
    case delete = 2
    case cancelVip = 3
    var apiValue: String {
        switch self {
        case .active:
            return "1"
        case .deactivate:
            return "0"
        case .cancelVip:
            return ""
        case .delete:
            return ""
        }
    }
}

class AccountStatusViewController: BaseViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var activeButton: UIButton!
    
    @IBOutlet weak var deactivateButton: UIButton!
    @IBOutlet weak var deactivatedLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var cancelVipButton: UIButton!
    @IBOutlet weak var cancelVipLabel: UILabel!
    @IBOutlet weak var desCancelVipLabel: UILabel!
    @IBOutlet weak var viewCancelVip: UIView!
    
    private let selectedImage = UIImage(named: "ic_checked")
    private let unselectedImage = UIImage(named: "ic_uncheck")
    
    private var currentSelected: AccountStatus = .active {
        didSet {
            activeButton.setImage(currentSelected == .active ? selectedImage : unselectedImage, for: .normal)
            deactivateButton.setImage(currentSelected == .deactivate ? selectedImage : unselectedImage, for: .normal)
            deleteButton.setImage(currentSelected == .delete ? selectedImage : unselectedImage, for: .normal)
            cancelVipButton.setImage(currentSelected == .cancelVip ? selectedImage : unselectedImage, for: .normal)
            
            activeLabel.textColor = currentSelected == .active ? Constants.yellow : UIColor.white
            deactivatedLabel.textColor = currentSelected == .deactivate ? Constants.yellow : UIColor.white
            deleteLabel.textColor = currentSelected == .delete ? Constants.yellow : UIColor.white
            
            cancelVipLabel.textColor = currentSelected == .cancelVip ? Constants.yellow : UIColor.white
            desCancelVipLabel.textColor = currentSelected == .cancelVip ? Constants.yellow : UIColor.white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activeButton.tag = AccountStatus.active.rawValue
        deactivateButton.tag = AccountStatus.deactivate.rawValue
        deleteButton.tag = AccountStatus.delete.rawValue
        cancelVipButton.tag = AccountStatus.cancelVip.rawValue
        currentSelected = .active
        usernameLabel.text = AppSettings.shared.currentUser?.username
        usernameLabel.textColor = UIColor.white
        if let iser = AppSettings.shared.currentUser, iser.premium{
            viewCancelVip.isHidden = false
        }
        else{
            viewCancelVip.isHidden = true
        }
        fetchAccountStatus()
    }
    
    @IBAction func didTapStatusButton(_ sender: UIButton) {
        guard let status = AccountStatus(rawValue: sender.tag) else { return }
        currentSelected = status
    }
    
    @IBAction func didTapUpdateButton(_ sender: Any) {
        switch currentSelected {
        case .active, .deactivate:
            updateAccountStatus()
        case .cancelVip:
            showCancelPaid()
        case .delete:
            showInputPassword()
        }
    }
    @IBAction func doCancelPaid(_ sender: Any) {
        showCancelPaid()
    }
}

extension AccountStatusViewController {
    private func fetchAccountStatus() {
        guard let userId = AppSettings.shared.currentUser?.userId else { return }
        self.showSimpleHUD()
        ManageAPI.shared.fetchAccountStatus(userId: userId) {[weak self] status in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let status = status {
                    self.currentSelected = status
                    return
                }
            }
        }
    }
    
    private func updateAccountStatus() {
        guard let userId = AppSettings.shared.currentUser?.userId else { return }
        self.showSimpleHUD()
        ManageAPI.shared.updateAccountStatus(userId: userId, status: currentSelected.apiValue) {[weak self] error in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let error = error {
                    self.showErrorAlert(message: error)
                    return
                }
                if self.currentSelected == .deactivate {
                    self.showAlert(title: "Success", message: "You can always come back & reactivate.")
                }
            }
        }
    }
    
    private func showInputPassword() {
        let alertController = UIAlertController(title: "Password", message: "Please input your current passsword", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        
        let continueAction = UIAlertAction(title: "Continue", style: .destructive) {[weak alertController] _ in
            guard let textField = alertController?.textFields?.first else { return }
            guard let password = textField.text, !password.isEmpty else { return }
            self.showConfirmPopup(password: password)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(continueAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func showConfirmPopup(password: String) {
        let alertController = UIAlertController(title: "Are you sure you want to delete?", message: "All the data of your profile will be gone. You will have to re-register.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.deleteAccount(password: password)
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func deleteAccount(password: String) {
        guard let userId = AppSettings.shared.currentUser?.userId else { return }
        self.showSimpleHUD()
        ManageAPI.shared.deleteAccount(userId: userId, password: password) { [weak self] error in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let error = error {
                    self.showErrorAlert(message: error)
                    return
                }
                
                AppSettings.shared.reset()
                self.showDeleteSuccessPopup()
            }
        }
    }
    
    private func showDeleteSuccessPopup() {
        let alertController = UIAlertController(title: "Deleted", message: "Your Profile has been permanently deleted from our database. But you can always come back and sign up. Thanks.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .destructive) { _ in
            DispatchQueue.main.async {
                let navigationController = BaseNavigationController()
                navigationController.viewControllers = [NewFeedsViewController.instantiate(), LoginVC.instantiate(from: StoryboardName.authentication.rawValue)]
                self.switchRootViewController(navigationController)
            }
        }

        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func showCancelPaid() {
        let alertController = UIAlertController(title: "Cancel VIP Status", message: "Are you sure you want to cancel your VIP Status? Your profile will be removed from the VIP circle and you will miss out on all the BENEFITS.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Yes", style: .default) { _ in
            guard let userId = AppSettings.shared.currentUser?.userId else { return }
            self.showSimpleHUD()
            ManageAPI.shared.cancelSubscribe(para: ["uid": userId]) { success, error in
                self.hideLoading()
                DispatchQueue.main.async {
                    if !success{
                        if let error = error {
                            self.showErrorAlert(message: error)
                            return
                        }
                        
                    }
                    else{
                        if let error = error {
                            self.showAlert(title: nil, message: error)
                        }
                        self.viewCancelVip.isHidden = true
                        self.currentSelected = .active
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}





