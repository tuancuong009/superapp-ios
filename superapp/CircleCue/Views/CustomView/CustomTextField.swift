//
//  CustomTextField.swift
//  CircleCue
//
//  Created by QTS Coder on 10/7/20.
//

import UIKit

class CustomTextField: UITextField {

    @IBInspectable
    var placeholderColor: UIColor = Constants.gray_holder {
        didSet {
            update()
        }
    }
    
    func update() {
        let attribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: placeholderColor,
                                                        NSAttributedString.Key.font: self.font ?? UIFont.myriadProRegular(ofSize: 13)]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: attribute)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tintColor = UIColor.blue
        update()
    }
}
