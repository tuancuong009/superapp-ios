//
//  ProfileInfoTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/7/20.
//

import UIKit

class ProfileInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var privateLabel: UILabel!
    @IBOutlet weak var bioView: UIView!
    @IBOutlet weak var bioTextView: UITextView!
    
    weak var delegate: EditProfileDelegate?
    private var item: ProfileInfomation?
    private var selectedImage: UIImage = #imageLiteral(resourceName: "ic_radio_white_selected")
    private var unselectedImage: UIImage = #imageLiteral(resourceName: "ic_radio_white")
    var isBlogStatus = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        bioTextView.delegate = self
        bioTextView.textContainerInset = .zero
        privateLabel.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        emailView.isHidden = true
        checkButton.isHidden = true
        bioView.isHidden = true
        item = nil
    }
    
    func setup(item: ProfileInfomation) {
        self.item = item
        privateLabel.isHidden = true
        titleLabel.text = item.type.rawValue
        bioView.isHidden = true
        switch item.type {
        case .email:
            emailView.isHidden = false
            checkButton.isHidden = !emailView.isHidden
            textField.placeholder = nil
            textField.keyboardType = .emailAddress
            textField.autocapitalizationType = .none
            textField.text = item.email
        case .album:
            emailView.isHidden = true
            checkButton.isHidden = !emailView.isHidden
            let image = item.albumPrivate == true ? selectedImage : unselectedImage
            checkButton.setImage(image, for: .normal)
            privateLabel.isHidden = false
        case .city:
            emailView.isHidden = false
            checkButton.isHidden = !emailView.isHidden
            textField.placeholder = nil
            textField.keyboardType = .default
            textField.autocapitalizationType = .words
            textField.text = item.city
        case .blog:
            emailView.isHidden = false
            checkButton.isHidden = false
            textField.placeholder = nil
            textField.keyboardType = .URL
            textField.autocapitalizationType = .words
            textField.text = item.blog
            let image = isBlogStatus ? selectedImage : unselectedImage
            checkButton.setImage(image, for: .normal)
            privateLabel.isHidden = false
        case .title:
            emailView.isHidden = false
            checkButton.isHidden = !emailView.isHidden
            textField.placeholder = nil
            textField.keyboardType = .default
            textField.autocapitalizationType = .sentences
            textField.text = item.title
            titleLabel.text = AppSettings.shared.currentUser?.accountType == .business ? "Industry/Title" : "Occupation/Title"
        case .bio:
            bioView.isHidden = false
            emailView.isHidden = true
            checkButton.isHidden = true
            bioTextView.text = item.bio
        case .location:
            emailView.isHidden = true
            checkButton.isHidden = !emailView.isHidden
            let image = item.showLocation == true ? selectedImage : unselectedImage
            checkButton.setImage(image, for: .normal)
        case .pushNotification:
            emailView.isHidden = true
            checkButton.isHidden = !emailView.isHidden
            let image = item.push == true ? selectedImage : unselectedImage
            checkButton.setImage(image, for: .normal)
        case .emailNotification:
            emailView.isHidden = true
            checkButton.isHidden = !emailView.isHidden
            let image = item.notification == true ? selectedImage : unselectedImage
            checkButton.setImage(image, for: .normal)
        case .uploadResume:
            emailView.isHidden = true
            checkButton.isHidden = !emailView.isHidden
            let image = item.uploadResumePrivate ? selectedImage : unselectedImage
            checkButton.setImage(image, for: .normal)
            privateLabel.isHidden = false
        case .review:
            emailView.isHidden = true
            checkButton.isHidden = !emailView.isHidden
            let image = item.reviewPrivate ? selectedImage : unselectedImage
            checkButton.setImage(image, for: .normal)
            privateLabel.isHidden = false
        case .circle_number:
            emailView.isHidden = true
            checkButton.isHidden = !emailView.isHidden
            let image = item.circle_status ? selectedImage : unselectedImage
            checkButton.setImage(image, for: .normal)
            privateLabel.isHidden = false
        case .blog_status:
            break
        }
    }
    @IBAction func checkActionUrl(_ sender: UIButton) {
        guard var item = item else { return }
        if item.type != .pushNotification {
            if sender.currentImage == unselectedImage {
                sender.setImage(selectedImage, for: .normal)
                isBlogStatus = true
                
            } else if sender.currentImage == selectedImage {
                sender.setImage(unselectedImage, for: .normal)
                isBlogStatus = false
            }
        }
       
        delegate?.updateBlogStatus(isBlogStatus)
    }
    
    @IBAction func checkAction(_ sender: UIButton) {
        guard var item = item else { return }
        if item.type != .pushNotification {
            if sender.currentImage == unselectedImage {
                sender.setImage(selectedImage, for: .normal)
            } else if sender.currentImage == selectedImage {
                sender.setImage(unselectedImage, for: .normal)
            }
        }
        switch item.type {
        case .emailNotification:
            item.notification.toggle()
        case .pushNotification:
            delegate?.didChangePushNotification(currentStatus: item.push)
            return
        case .location:
            item.showLocation.toggle()
        case .uploadResume:
            item.uploadResumePrivate.toggle()
        case .album:
            item.albumPrivate.toggle()
        case .review:
            item.reviewPrivate.toggle()
        case .circle_number:
            item.circle_status.toggle()
        case .blog_status:
            item.blog_status.toggle()
        default:
            break
        }
        delegate?.updatePersonalInfo(item)
    }
    
}

extension ProfileInfoTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard var item = self.item else { return }
        let text = textField.text?.trimmed ?? ""
        switch item.type {
        case .email:
            item.email = text
        case .city:
            item.city = text
        case .title:
            item.title = text
        case .bio:
            item.bio = text
        case .blog:
            item.blog = text
        default:
            break
        }
        delegate?.updatePersonalInfo(item)
    }
}

extension ProfileInfoTableViewCell: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        guard var item = self.item else { return }
        let text = textView.text.trimmed
        item.bio = text
        delegate?.updatePersonalInfo(item)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let maxLength = 300
        let maxReplacementLength = min(range.length, maxLength - range.location)
        let replacementRange = NSRange(location: range.location, length: maxReplacementLength)
        let result = NSString(string: (textView.text ?? "")).replacingCharacters(in: replacementRange, with: text)
        
        if result.count <= maxLength && range.length <= maxLength - range.location  {
            return true
        }
        textView.text = String(result[..<result.index(result.startIndex, offsetBy: min(result.count, maxLength))])
        
        return false
    }
}
