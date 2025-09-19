//
//  AddCustomLinkTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/16/20.
//

import UIKit

class AddCustomLinkTableViewCell: UITableViewCell {

    @IBOutlet weak var socialNameTextField: CustomTextField!
    @IBOutlet weak var urlTextField: CustomTextField!
    @IBOutlet weak var privateButton: UIButton!
    
    weak var delegate: EditProfileDelegate?
    var customLink: CustomLink?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        socialNameTextField.delegate = self
        urlTextField.delegate = self
        socialNameTextField.placeholder = "Title"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        customLink = nil
    }
    
    func setup(item: CustomLink) {
        customLink = item
        socialNameTextField.text = item.name
        urlTextField.text = item.link
        privateButton.setHomePrivateStatus(item.isPrivate)
    }
    
    @IBAction func privateAction(_ sender: UIButton) {
        guard var item = self.customLink else { return }
        item.isPrivate.toggle()
        delegate?.updateCustomLink(item)
    }
}

extension AddCustomLinkTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard var item = self.customLink else { return }
        item.link = urlTextField.text?.trimmed ?? ""
        item.name = socialNameTextField.text?.trimmed ?? ""
        delegate?.updateCustomLink(item)
    }
}
