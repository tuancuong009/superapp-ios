//
//  EditTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/7/20.
//

import UIKit

protocol EditProfileDelegate: AnyObject {
    func updateSocialLink(_ item: HomeSocialItem)
    func updatePersonalInfo(_ info: ProfileInfomation)
    func updateCustomLink(_ customLink: CustomLink)
    func addMoreCustomLink()
    func selectingAll(item: EditSocialObject)
    func uploadAction(_ item: ProfileInfomation)
    func socialLogin(_ item: HomeSocialItem)
    func didChangePushNotification(currentStatus: Bool)
    func updateBlogStatus(_ info: Bool)
}

class EditTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var socialNameLabel: UILabel!
    @IBOutlet weak var textField: CustomTextField!
    @IBOutlet weak var privateButton: UIButton!
    
    static let cellHeight: CGFloat = 70.0
    weak var delegate: EditProfileDelegate?
    var item: HomeSocialItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        item = nil
        textField.text = nil
        iconImageView.image = nil
        socialNameLabel.text = nil
    }

    func setup(item: HomeSocialItem) {
        textField.update()
        self.item = item
        iconImageView.image = item.type.image
        socialNameLabel.text = item.type.rawValue
        if let userName = item.link, !userName.isEmpty {
            if let domain = item.type.domain {
                if userName.isValidSocialLink(host: domain) {
                    textField.text = userName
                } else {
                    textField.text = domain + userName
                }
            } else {
                textField.text = userName
            }
        } else {
            textField.text = nil
        }
        privateButton.setHomePrivateStatus(item.isPrivate)
        
        if item.type == .website {
            textField.placeholder = "Type full URL. Example: www.websitename.com"
        } else {
            textField.placeholder = "Type your username only. Example: username"
        }
    }
    
    @IBAction func privateAction(_ sender: UIButton) {
        guard var item = self.item else { return }
        item.isPrivate.toggle()
        delegate?.updateSocialLink(item)
    }
    
    @IBAction func socialLoginAction(_ sender: Any) {
        guard let item = self.item else { return }
        delegate?.socialLogin(item)
    }
    
}

extension EditTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard var item = self.item else { return }
        
        if let str = textField.text?.trimmed, let url = URL(string: str) {
            var path = url.path
            if path.hasPrefix("/") {
                path = String(path.dropFirst())
            }
            
            if item.type == .tiktok {
                if path.hasPrefix("@") {
                    item.link = path
                } else {
                    item.link = "@" + path
                }
            } else {
                item.link = path
            }
            print(path)
        } else if let domain = item.type.domain {
            item.link = textField.text?.trimmed.replacingOccurrences(of: domain, with: "") ?? ""
        } else {
            item.link = textField.text?.trimmed ?? ""
        }
        
        delegate?.updateSocialLink(item)
    }
}
