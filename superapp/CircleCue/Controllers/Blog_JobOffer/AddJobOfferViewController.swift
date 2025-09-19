//
//  AddJobOfferViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 11/10/20.
//

import UIKit
import Alamofire
import MobileCoreServices

protocol AddJobOffseDelegate: AnyObject {
    func shouldReloadData()
    func viewImage(imageView: UIImageView)
    func viewUserProfile(id: String)
}

extension AddJobOffseDelegate {
    func viewUserProfile(id: String) {}
}

class AddJobOfferViewController: BaseViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var removeImageButton: UIButton!
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var dateView: UIView!
    
    var data: Blog_Job?
    var viewType: MenuItem = .jobOffer
    weak var delegate: AddJobOffseDelegate?
    
    private var imagePicker: ImagePicker?
    private var selectedImage: UIImage? {
        didSet {
            mediaImageView.image = selectedImage ?? PlaceHolderImage.photo.image
            removeImageButton.isHidden = selectedImage == nil
        }
    }
    
    private var selectDate: Date? = nil {
        didSet {
            self.dateTextField.text = selectDate?.toDateString(.addNote)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func importFileAction(_ sender: UIButton) {
        showImportFile(sourceView: sender)
    }
    
    @IBAction func chooseImageAction(_ sender: Any) {
        guard data == nil else {
            self.showSimplePhotoViewer(for: mediaImageView, image: mediaImageView.image)
            return
        }
        showChangeImage(sourceView: mediaImageView)
    }
    
    @IBAction func removeImageAction(_ sender: Any) {
        selectedImage = nil
    }
    
    @IBAction func didTapSelectDateButton(_ sender: Any) {
        let controller = DatePickerViewController.instantiate()
        controller.selectedDate = selectDate
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .overFullScreen
        controller.delegate = self
        self.present(controller, animated: false, completion: nil)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        view.endEditing(true)
        var error = [String]()
        var para: Parameters = ["id": userId]
        
        if let itemId = data?.id {
            para.updateValue(itemId, forKey: "id")
        }
        
        if let title = titleTextField.text?.trimmed, !title.isEmpty {
            para.updateValue(title, forKey: "title")
        } else {
            error.append(ErrorMessage.titleEmpty.rawValue)
        }
        
        let dateString = (selectDate ?? Date()).toDateString(.addNote)
        para.updateValue(dateString, forKey: "date")

        if contentTextView.text.trimmed.isEmpty {
            error.append(ErrorMessage.contentEmpty.rawValue)
        } else {
            para.updateValue(contentTextView.text.trimmed, forKey: "content")
        }
        
        guard error.isEmpty else {
            let errorMessage = error.joined(separator: "\n")
            self.showErrorAlert(message: errorMessage)
            return
        }
        
        submitData(image: selectedImage, para: para)
    }
}

extension AddJobOfferViewController {
    
    private func setup() {
        imagePicker = ImagePicker(presentationController: self, delegate: self, mediaTypes: [.image], allowsEditing: false, iCloud: true, documentTypes: [kUTTypePlainText as String], cloudOnly: true)
        setupUI()
        updateUI()
    }
    
    private func setupUI() {
        removeImageButton.isHidden = true
        contentTextView.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 10, right: 5)
        contentTextView.delegate = self
        if let data = data {
            mediaView.isHidden = !data.imageItem
            mediaImageView.setImage(with: data.media, placeholderImage: .photo)
            self.topBarMenuView.title = viewType == .blog ? "Edit Blogs/Events/Promos" : "Edit \(viewType.rawValue)"
        } else {
            mediaView.isHidden = false
            self.topBarMenuView.title = viewType == .blog ? "Add Blogs/Events/Promos" : "Add \(viewType.rawValue)"
        }
        
        if viewType == .blog {
            dateView.isHidden = false
            dateTextField.text = data?.date
            selectDate = data?.date.toAPIDate(format: .addNote)
        } else {
            dateView.isHidden = true
            dateTextField.text = nil
        }
    }
    
    private func updateUI() {
        if let data = data {
            titleTextField.text = data.title
            contentTextView.text = data.content
            placeholderLabel.isHidden = contentTextView.hasText
        }
    }
}

extension AddJobOfferViewController {
    
    private func showImportFile(sourceView: UIView) {
        imagePicker = ImagePicker(presentationController: self, delegate: self, mediaTypes: [.image], allowsEditing: false, iCloud: true, documentTypes: [kUTTypePlainText as String], cloudOnly: true)
        imagePicker?.present(title: nil, message: nil, from: sourceView)
    }
    
    private func showChangeImage(sourceView: UIView) {
        imagePicker = ImagePicker(presentationController: self, delegate: self, mediaTypes: [.image], allowsEditing: false, iCloud: true)
        imagePicker?.present(title: nil, message: nil, from: sourceView)
    }
    

    private func addNewItem(_ para: Parameters) {
        switch viewType {
        case .blog:
            showSimpleHUD(text: "Submitting...")
            ManageAPI.shared.addBlog(para) {[weak self] (error) in
                guard let self = self else { return }
                self.hideLoading()
                DispatchQueue.main.async {
                    if let err = error {
                        return self.showErrorAlert(message: err)
                    }
                    
                    self.delegate?.shouldReloadData()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        case .jobOffer:
            showSimpleHUD(text: "Submitting...")
            ManageAPI.shared.addJob(para) {[weak self] (error) in
                guard let self = self else { return }
                self.hideLoading()
                DispatchQueue.main.async {
                    if let err = error {
                        return self.showErrorAlert(message: err)
                    }
                    
                    self.delegate?.shouldReloadData()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        default:
            break
        }
    }
    
    private func updateData(_ para: Parameters) {
        switch viewType {
        case .blog:
            showSimpleHUD(text: "Submitting...")
            ManageAPI.shared.updateBlog(para) {[weak self] (error) in
                guard let self = self else { return }
                self.hideLoading()
                DispatchQueue.main.async {
                    if let err = error {
                        return self.showErrorAlert(message: err)
                    }
                    
                    self.delegate?.shouldReloadData()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        case .jobOffer:
            showSimpleHUD(text: "Submitting...")
            ManageAPI.shared.updateJob(para) {[weak self] (error) in
                guard let self = self else { return }
                self.hideLoading()
                DispatchQueue.main.async {
                    if let err = error {
                        return self.showErrorAlert(message: err)
                    }
                    
                    self.delegate?.shouldReloadData()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        default:
            break
        }
    }
    
    private func handleUpdateData(para: Parameters) {
        if data != nil {
            self.updateData(para)
        } else {
            self.addNewItem(para)
        }
    }
}

extension AddJobOfferViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.hasText
    }
}

extension AddJobOfferViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddJobOfferViewController: ImagePickerDelegate {
    
    func didSelect(textFile: URL) {
        if let stringText = try? String(contentsOf: textFile, encoding: .utf8) {
            self.contentTextView.text = stringText
            self.placeholderLabel.isHidden = contentTextView.hasText
        }
    }
    
    func didSelect(image: UIImage?) {
        selectedImage = image
    }
    
    private func submitData(image: UIImage?, para: Parameters) {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        guard let data = image?.jpegData(compressionQuality: 0.5) else {
            self.handleUpdateData(para: para)
            return
        }
        
        let fileName = "\(userId)\(randomString()).jpg"
        showSimpleHUD(text: "Uploading...")
        ManageAPI.shared.uploadFile(file: data, fileName) {[weak self] (path, error) in
            guard let self = self else { return }
            if let path = path {
                var newPara = para
                newPara.updateValue(path, forKey: "media")
                self.handleUpdateData(para: newPara)
                return
            }
            self.hideLoading()
            self.showErrorHUD(text: error)
        }
    }
}

extension AddJobOfferViewController: DatePickerViewDelegate {
    func didSelectDate(date: Date) {
        selectDate = date
    }
}
