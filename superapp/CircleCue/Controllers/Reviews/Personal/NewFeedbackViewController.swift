//
//  NewFeedbackViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/23/20.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire

class NewFeedbackViewController: BaseViewController {

    @IBOutlet weak var searchUserButton: UIButton!
    @IBOutlet weak var inputManualButton: UIButton!
    
    @IBOutlet weak var searchUserTextField: SearchTextField!
    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var businessInfoTextField: UITextField!
    
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBOutlet weak var searchUserOverlayView: UIView!
    @IBOutlet weak var inputUserOverlayView: UIView!

    weak var delegate: PersonalFeedbackDelegate?
    var currentIndex: Int = 0
    var businessUsers: [BusinessUserObject] = []
    var selectedUser: BusinessUserObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        fetchBusinessUserList()
    }

    @IBAction func selectTypeUserAction(_ sender: UIButton) {
        guard currentIndex != sender.tag else { return }
        if sender.tag == 0 {
            searchUserButton.setImage(#imageLiteral(resourceName: "ic_radio_selected_20"), for: .normal)
            inputManualButton.setImage(#imageLiteral(resourceName: "ic_radio_white"), for: .normal)
            searchUserOverlayView.isHidden = false
            inputUserOverlayView.isHidden = true
        } else {
            inputManualButton.setImage(#imageLiteral(resourceName: "ic_radio_selected_20"), for: .normal)
            searchUserButton.setImage(#imageLiteral(resourceName: "ic_radio_white"), for: .normal)
            searchUserOverlayView.isHidden = true
            inputUserOverlayView.isHidden = false
        }
        ratingView.rating = 0.0
        currentIndex = sender.tag
        self.view.endEditing(true)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        view.endEditing(true)
        var error: [String] = []
        var para: Parameters = ["id": userId]
        switch currentIndex {
        case 0:
            if let user = selectedUser {
                para.updateValue(user.id, forKey: "id2")
            } else {
                error.append(ErrorMessage.businessNameEmpty.rawValue)
            }
        default:
            if let businessName = businessNameTextField.trimmedText, !businessName.isEmpty {
                para.updateValue(businessName, forKey: "name")
            } else {
                error.append(ErrorMessage.businessNameEmpty.rawValue)
            }
            
            if let email = businessInfoTextField.trimmedText, !email.isEmpty {
                para.updateValue(email, forKey: "email")
            }
        }
        
        if ratingView.rating == 0 {
            error.append(ErrorMessage.notRating.rawValue)
        } else {
            para.updateValue(ratingView.rating, forKey: "rating")
        }
        
        if reviewTextView.text.trimmed.isEmpty {
            error.append(ErrorMessage.reviewEmpty.rawValue)
        } else {
            para.updateValue(reviewTextView.text.trimmed, forKey: "content")
        }

        guard error.isEmpty else {
            let errorMessage = error.joined(separator: "\n")
            self.showErrorAlert(message: errorMessage)
            return
        }
        
        self.addReview(para)
    }
}

extension NewFeedbackViewController {
    private func fetchBusinessUserList() {
        showSimpleHUD()
        ManageAPI.shared.fetchBusinessUserList {[weak self] (users) in
            guard let self = self else { return }
            self.hideLoading()
            self.businessUsers = users
            DispatchQueue.main.async {
                self.configureSimpleSearchTextField()
            }
        }
    }
    
    private func addReview(_ para: Parameters) {
        showSimpleHUD()
        ManageAPI.shared.addReview(para) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let err = error {
                    return self.showErrorAlert(message: err)
                }
                self.delegate?.reloadData()
                self.showAlert(title: "Submitted", message: "Your review has been submitted.") { (_) in
                    self.delegate?.didAddNewFeedback()
                    self.reset()
                }
            }
        }
    }
}

extension NewFeedbackViewController {
    
    private func setup() {
        setupUI()
        setupTextField()
        setupTextView()
    }
    
    private func setupUI() {
        currentIndex = 0
        searchUserButton.setImage(#imageLiteral(resourceName: "ic_radio_selected_20"), for: .normal)
        inputManualButton.setImage(#imageLiteral(resourceName: "ic_radio_white"), for: .normal)
        searchUserOverlayView.isHidden = false
        inputUserOverlayView.isHidden = true
    }
    
    private func setupTextField() {
        searchUserTextField.addPaddingLeft(10)
    }

    private func configureSimpleSearchTextField() {
        // Set data source
        searchUserTextField.theme.cellHeight = 44
        searchUserTextField.theme.bgColor = .white
        searchUserTextField.theme.font = UIFont.myriadProRegular(ofSize: 16)
        searchUserTextField.theme.separatorColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8)
        searchUserTextField.highlightAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.myriadProBold(ofSize: 17)]
        searchUserTextField.startVisible = true
        let tags = businessUsers.map({$0.username})
        searchUserTextField.filterStrings(tags)
        searchUserTextField.delegate = self
        
        searchUserTextField.itemSelectionHandler = {[weak self] (filterResult, index) in
            self?.searchUserTextField.text = filterResult[index].title
            self?.view.endEditing(true)
            if let userIndex = self?.businessUsers.firstIndex(where: {$0.username == filterResult[index].title}) {
                self?.selectedUser = self?.businessUsers[userIndex]
                
                LOG("User = \(String(describing: self?.selectedUser))")
            }
        }
    }
    
    private func setupTextView() {
        reviewTextView.textContainerInset.left = 6
        reviewTextView.textContainerInset.right = 6
        reviewTextView.delegate = self
    }
    
    private func reset() {
        businessNameTextField.text = nil
        businessInfoTextField.text = nil
        searchUserTextField.text = nil
        reviewTextView.text = nil
        placeholderLabel.isHidden = reviewTextView.hasText
        ratingView.rating = 0.0
        setupUI()
    }
    
    private func showNotFoundUserAlert() {
        let titleAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.myriadProSemiBold(ofSize: 16), .foregroundColor: UIColor.black]
        let messageAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.myriadProRegular(ofSize: 14), .foregroundColor: UIColor.black]
        
        let titleString = NSAttributedString(string: "Oops!", attributes: titleAttribute)
        let messageString = NSAttributedString(string: "Business user not found.", attributes: messageAttribute)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alertController.setValue(titleString, forKey: "attributedTitle")
        alertController.setValue(messageString, forKey: "attributedMessage")
        
        let closeAction = UIAlertAction(title: "Close", style: .cancel) { (action) in
            self.searchUserTextField.becomeFirstResponder()
        }
        
        alertController.addAction(closeAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension NewFeedbackViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField == searchUserTextField else { return }
        if let text = textField.trimmedText, !text.isEmpty {
            let tags = businessUsers.map({$0.username})
            if !tags.contains(text) {
                showNotFoundUserAlert()
            }
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == searchUserTextField {
            selectedUser = nil
        }
        
        return true
    }
}

extension NewFeedbackViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.hasText
    }
}
