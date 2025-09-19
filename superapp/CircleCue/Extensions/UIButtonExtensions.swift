//
//  UIButtonExtensions.swift
//  CircleCue
//
//  Created by QTS Coder on 10/29/20.
//

import UIKit

class DSButton: UIButton {
    
    @IBInspectable
    var minScale: CGFloat = 1.0 {
        didSet {
            self.titleLabel?.adjustsFontSizeToFitWidth = true
            self.titleLabel?.minimumScaleFactor = minScale
        }
    }
}

extension UIButton {
    func createCustomAttribute(content: String, highlightContent: String, highlightFont: UIFont, highlightColor: UIColor, contentFont: UIFont, contentColor: UIColor) {
        let attribute = NSMutableAttributedString()
        
        let contentAttribute: [NSAttributedString.Key: Any] = [.font: contentFont, .foregroundColor: contentColor]
        let highlightAttribute: [NSAttributedString.Key: Any] = [.font: highlightFont, .foregroundColor: highlightColor]
        
        attribute.append(NSAttributedString(string: content, attributes: contentAttribute))
        attribute.append(NSAttributedString(string: highlightContent, attributes: highlightAttribute))
        
        self.setAttributedTitle(attribute, for: .normal)
    }
    
    func setButtonTitle(title: String?) {
        self.titleLabel?.text = title
        self.setTitle(title, for: .normal)
    }
}
