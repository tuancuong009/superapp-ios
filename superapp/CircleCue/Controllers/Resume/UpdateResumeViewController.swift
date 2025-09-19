//
//  UpdateResumeViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 12/8/20.
//

import UIKit
import Alamofire
import MobileCoreServices

class UpdateResumeViewController: BaseViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var resumeImageView: UIImageView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    private var selectedImageData: Data?
    private var imagePicker: ImagePicker?
    
    weak var delegate: ResumeViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }

    @IBAction func updateResumeAction(_ sender: Any) {
        var error: [String] = []
        if titleTextField.trimmedText?.isEmpty == true {
            error.append("Missing Resume Title")
        }
        
        if bioTextView.text.trimmed.isEmpty && (selectedImageData == nil && AppSettings.shared.currentUser?.resume == nil) {
            error.append("Please type something or upload an image.\nThanks.")
        }
        
        guard error.isEmpty else {
            self.showErrorAlert(message: error.joined(separator: "\n"))
            return
        }
        
        self.uploadImage(data: selectedImageData)
    }
    
    @IBAction func optionAction(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let importFile = UIAlertAction(title: "Import Text File", style: .default) { (action) in
            self.showImportFile(sourceView: sender)
        }
        
        let changeImageResume = UIAlertAction(title: "Change Image Resume", style: .default) { (action) in
            self.showChangeImage(sourceView: sender)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(importFile)
        alert.addAction(changeImageResume)
        alert.addAction(cancel)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension UpdateResumeViewController {
    private func updateUI() {
        guard let user = AppSettings.shared.currentUser else { return }
        titleTextField.text = user.resume_title
        bioTextView.text = user.resume_text
        placeholderLabel.isHidden = bioTextView.hasText
        if let resume = user.resume {
            resumeImageView.setImage(with: resume, placeholderImage: .photo)
        }
    }
    
    private func setupUI() {
        bioTextView.textContainerInset.left = 6
        bioTextView.textContainerInset.right = 6
        bioTextView.delegate = self
        titleTextField.delegate = self
        placeholderLabel.text = "Type Bio/Cover letter here"
    }
    
    private func showImportFile(sourceView: UIButton) {
        imagePicker = ImagePicker(presentationController: self, delegate: self, mediaTypes: [.image], allowsEditing: false, iCloud: true, documentTypes: [kUTTypePlainText as String], cloudOnly: true)
        imagePicker?.present(title: nil, message: nil, from: sourceView)
    }
    
    private func showChangeImage(sourceView: UIButton) {
        imagePicker = ImagePicker(presentationController: self, delegate: self, mediaTypes: [.image], allowsEditing: false, iCloud: true)
        imagePicker?.present(title: nil, message: nil, from: sourceView)
    }
}

extension UpdateResumeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.hasText
    }
}

extension UpdateResumeViewController: ImagePickerDelegate {
    
    func didSelect(textFile: URL) {
        if let stringText = try? String(contentsOf: textFile, encoding: .utf8) {
            self.bioTextView.text = stringText
            self.placeholderLabel.isHidden = bioTextView.hasText
        }
    }

    func didSelect(image: UIImage?) {
        resumeImageView.image = image
        selectedImageData = image?.jpegData(compressionQuality: 0.5)
    }
    
    private func uploadImage(data: Data?) {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        let resumeTitle = titleTextField.trimmedText ?? ""
        if let data = data {
            let fileName = "\(userId)\(randomString()).jpg"
            showSimpleHUD(text: "Uploading...")
            ManageAPI.shared.uploadFile(file: data, fileName) {[weak self] (path, error) in
                guard let self = self else { return }
                if let path = path {
                    self.updateResume(userId: userId, resumeTitle: resumeTitle, resumePath: path, resume_text: self.bioTextView.text.trimmed.isEmpty ? " " : self.bioTextView.text.trimmed)
                    return
                }
                self.hideLoading()
                self.showErrorHUD(text: error)
            }
        } else {
            if var resume = AppSettings.shared.currentUser?.resume {
                resume = resume.replacingOccurrences(of: Constants.UPLOAD_URL_RETURN, with: "").replacingOccurrences(of: Constants.UPLOAD_URL, with: "")
                self.updateResume(userId: userId, resumeTitle: resumeTitle, resumePath: resume, resume_text: self.bioTextView.text.trimmed.isEmpty ? " " : self.bioTextView.text.trimmed)
            } else {
                self.updateResume(userId: userId, resumeTitle: resumeTitle, resumePath: nil, resume_text: self.bioTextView.text.trimmed.isEmpty ? " " : self.bioTextView.text.trimmed)
            }
        }
    }
    
    private func updateResume(userId: String, resumeTitle: String, resumePath: String?, resume_text: String) {
        let para: Parameters = ["id": userId, "resume_title": resumeTitle, "resume": resumePath ?? "", "resume_text": resume_text]
        showSimpleHUD(text: "Updating...")
        ManageAPI.shared.updateResume(para) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            if let err = error {
                return self.showErrorAlert(message: err)
            }
            
            AppSettings.shared.currentUser?.resume_title = resumeTitle
            AppSettings.shared.currentUser?.resume_text = resume_text.trimmed.isEmpty ? nil : resume_text.trimmed
            if let resumePath = resumePath {
                AppSettings.shared.currentUser?.resume = Constants.UPLOAD_URL + resumePath
            } else {
                AppSettings.shared.currentUser?.resume = nil
            }
            
            self.delegate?.didUpdateResume()
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension UpdateResumeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
