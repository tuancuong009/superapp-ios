//
//  HelpViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/6/20.
//

import UIKit
import Alamofire

class HelpViewController: BaseViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var customerSupportTextView: UITextView!
    
    var shouldBack: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func submitAction(_ sender: Any) {
        let desc = textView.text.trimmed
        guard !desc.isEmpty else {
            return self.showErrorAlert(message: "Please input your questions/comments.")
        }
        
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        view.endEditing(true)
        submit(userId, desc)
    }
}

extension HelpViewController {
    private func setupUI() {
        self.topBarMenuView.leftButtonType = shouldBack ? 1 : 0
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 10, right: 5)
        
        customerSupportTextView.text = "For Customer Support Call or Text to\n1-833-MY CIRCLE (1-833-692-4725)"
        customerSupportTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func submit(_ userId: String, _ desc: String) {
        showSimpleHUD(text: "Submitting...")
        ManageAPI.shared.submitContactUs(userId, desc) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let err = error {
                    self.showErrorAlert(message: err)
                    return
                }
                self.textView.text = nil
                self.placeHolderLabel.isHidden = false
                self.showAlert(title: "Thanks!", message: "Your questions/comments have been submitted.")
            }
        }
    }
}

extension HelpViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeHolderLabel.isHidden = textView.hasText
    }
}
