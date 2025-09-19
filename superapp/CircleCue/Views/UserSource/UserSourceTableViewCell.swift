//
//  UserSourceTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 11/07/2022.
//

import UIKit

protocol UserSourceViewDelegate: AnyObject {
    func didSelectOtherSource(source: UserSource)
}

class UserSourceTableViewCell: UITableViewCell {

    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var sourceNameLabel: UILabel!
    @IBOutlet weak var otherSourceView: UIView!
    @IBOutlet weak var otherTextField: UITextField!
    
    weak var delegate: UserSourceViewDelegate?
    
    private var source: UserSource?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        otherTextField.delegate = self
    }
    
    func setup(source: UserSource, isSelected: Bool) {
        self.source = source
        sourceNameLabel.text = source.name
        selectedImageView.image = isSelected ? UIImage(named: "radio_gradient_selected") : UIImage(named: "radio_gradient")
        otherSourceView.isHidden = source.isHidden
        otherTextField.isUserInteractionEnabled = isSelected
    }
}

extension UserSourceTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let source = source, !source.isHidden,
              let text = otherTextField.trimmedText, !text.isEmpty
        else {
            return
        }
        
        delegate?.didSelectOtherSource(source: .other(text: text))
        
    }
}
