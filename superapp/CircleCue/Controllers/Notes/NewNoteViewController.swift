//
//  NewNoteViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/16/20.
//

import UIKit
import Alamofire

protocol NoteViewControllerDelegate: AnyObject {
    func didAddNewNote()
    func viewNoteImage(_ note: Note, imageView: UIImageView)
}

class NewNoteViewController: BaseViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var notePlaceholderLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleErrorLabel: UILabel!
    @IBOutlet weak var noteErrorLabel: UILabel!
    @IBOutlet weak var dateErrorLabel: UILabel!
    
    @IBOutlet weak var removeImageButton: UIButton!
    
    var noteImagePath: String?
    weak var delegate: NoteViewControllerDelegate?
    var imagePicker: ImagePicker?
    var selectDate: Date? = nil {
        didSet {
            self.dateTextField.text = selectDate?.toDateString(.addNote)
            dateErrorLabel.showError(true, " ")
        }
    }
    var selectImage: UIImage? = nil {
        didSet {
            imageView.image = selectImage ?? PlaceHolderImage.photo.image
            removeImageButton.isHidden = (selectImage == nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func selectDateAction(_ sender: Any) {
        let controller = DatePickerViewController.instantiate()
        controller.selectedDate = selectDate
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .overFullScreen
        controller.delegate = self
        self.present(controller, animated: false, completion: nil)
    }
    
    @IBAction func selectImageAction(_ sender: UITapGestureRecognizer) {
        imagePicker?.present(title: "Attach Image", message: nil, from: imageView)
    }
    
    @IBAction func removeImageAction(_ sender: Any) {
        selectImage = nil
        noteImagePath = nil
    }
    
    @IBAction func submitAction(_ sender: Any) {
        view.endEditing(true)
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        var para: Parameters = ["uid": userId]
        
        var error = false
        if let title = titleTextField.text?.trimmed, !title.isEmpty {
            titleErrorLabel.showError(true, " ")
            para.updateValue(title, forKey: "title")
        } else {
            titleErrorLabel.showError(true, ErrorMessage.titleEmpty.rawValue)
            error = true
        }
        
        if !noteTextView.text.trimmed.isEmpty {
            noteErrorLabel.showError(true, " ")
            para.updateValue(noteTextView.text.trimmed, forKey: "desc")
        } else {
            noteErrorLabel.showError(true, ErrorMessage.noteEmpty.rawValue)
            error = true
        }
        
        if let selectDate = selectDate {
            dateErrorLabel.showError(true, " ")
            para.updateValue(selectDate.toDateString(.addNote) ?? dateTextField.text!.trimmed, forKey: "date")
        } else {
            dateErrorLabel.showError(true, ErrorMessage.dateEmpty.rawValue)
            error = true
        }
        guard !error else { return }
        
        if let image = selectImage {
            self.uploadImage(image: image, para: para)
        } else {
            addNewNote(para: para, mediaPath: nil)
        }
    }
}

extension NewNoteViewController {
    
    private func setup() {
        setupUI()
        setupTextField()
    }
    
    private func setupUI() {
        imagePicker = ImagePicker(presentationController: self, delegate: self, mediaTypes: [.image], allowsEditing: true, iCloud: true)
        titleErrorLabel.text = " "
        noteErrorLabel.text = " "
        dateErrorLabel.text = " "
        noteTextView.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 10, right: 5)
        noteTextView.delegate = self
        imageView.contentMode = .scaleAspectFill
        
        selectImage = nil
        selectDate = nil
    }
    
    private func setupTextField() {
        titleTextField.delegate = self
        dateTextField.delegate = self
        titleTextField.addTarget(self, action: #selector(textFieldChange(_:)), for: .editingChanged)
        dateTextField.addTarget(self, action: #selector(textFieldChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldChange(_ textField: UITextField) {
        switch textField {
        case titleTextField:
            titleErrorLabel.showError(true, " ")
        case dateTextField:
            dateErrorLabel.showError(true, " ")
        default:
            break
        }
    }
    
    private func addNewNote(para: Parameters, mediaPath: String?) {
        var newPara = para
        if let mediaPath = mediaPath {
            newPara.updateValue(mediaPath, forKey: "img")
        }
        ManageAPI.shared.addNewNote(para: newPara) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let err = error {
                    self.showErrorAlert(message: err)
                    return
                }
                
                self.showSuccessHUD(text: "Note added successfully!")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.delegate?.didAddNewNote()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

extension NewNoteViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.selectImage = image
    }
    
    private func uploadImage(image: UIImage, para: Parameters) {
        guard let userId = AppSettings.shared.userLogin?.userId, let data = image.jpegData(compressionQuality: 0.5) else { return }
        let fileName = "\(userId)\(randomString()).jpg"
        showSimpleHUD(text: "Submitting...")
        ManageAPI.shared.uploadFile(file: data, fileName) {[weak self] (path, error) in
            guard let self = self else { return }
            if let path = path {
                self.addNewNote(para: para, mediaPath: path)
                return
            }
            self.hideLoading()
            self.showErrorAlert(message: error)
        }
    }
}

extension NewNoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        notePlaceholderLabel.isHidden = textView.hasText
        noteErrorLabel.showError(true, " ")
    }
}

extension NewNoteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension NewNoteViewController: DatePickerViewDelegate {
    func didSelectDate(date: Date) {
        selectDate = date
    }
}
