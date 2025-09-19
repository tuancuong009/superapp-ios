//
//  UILabelExtensions.swift
//  CircleCue
//
//  Created by QTS Coder on 10/5/20.
//

import UIKit

extension UILabel {
    func showError(_ error: Bool, _ message: String? = nil) {
        self.isHidden = false
        self.text = error ? message : nil
    }
    
    func createBasicAttribute(content: String, highlightContent: String, highlightFont: UIFont, highlightColor: UIColor) {
        let attribute = NSMutableAttributedString()
        
        let contentAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.myriadProRegular(ofSize: 17), .foregroundColor: UIColor.white]
        let highlightAttribute: [NSAttributedString.Key: Any] = [.font: highlightFont, .foregroundColor: highlightColor]
        
        attribute.append(NSAttributedString(string: content, attributes: contentAttribute))
        attribute.append(NSAttributedString(string: highlightContent, attributes: highlightAttribute))
        
        self.attributedText = attribute
    }
    
    func createCustomAttribute(content: String, highlightContent: String, highlightFont: UIFont, highlightColor: UIColor, contentFont: UIFont, contentColor: UIColor, paragraphStyle: NSMutableParagraphStyle? = nil) {
        let attribute = NSMutableAttributedString()
        
        let contentAttribute: [NSAttributedString.Key: Any] = [.font: contentFont, .foregroundColor: contentColor]
        let highlightAttribute: [NSAttributedString.Key: Any] = [.font: highlightFont, .foregroundColor: highlightColor]
        
        attribute.append(NSAttributedString(string: content, attributes: contentAttribute))
        attribute.append(NSAttributedString(string: highlightContent, attributes: highlightAttribute))
        
        if let paragraphStyle = paragraphStyle {
            attribute.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attribute.length))
        }
        
        self.attributedText = attribute
    }
    
    
    func intentText(_ content: String) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.firstLineHeadIndent = 0
        paragraph.headIndent = 8

        let mutString = NSAttributedString(
            string: content,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraph]
        )

        self.attributedText = mutString
    }
}
