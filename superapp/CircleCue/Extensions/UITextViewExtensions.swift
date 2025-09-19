//
//  UITextViewExtensions.swift
//  CircleCue
//
//  Created by QTS Coder on 10/3/20.
//

import UIKit

typealias ChangeTextAttributes = (changeText: String, font: UIFont?, foregroundColor: UIColor?)
typealias TextAttributes = [NSAttributedString.Key : Any]?

extension NSAttributedString {
    
    static func create(forTitle title: String, stringsToChange: [ChangeTextAttributes], attributes: TextAttributes = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: title, attributes: attributes)
        stringsToChange.forEach {
            if let index = title.range(of: $0.changeText)?.lowerBound {
                var attributes: [NSAttributedString.Key: Any] = [:]
                attributes[.font] = $0.font
                attributes[.foregroundColor] = $0.foregroundColor
                attributedString.addAttributes(attributes, range: NSRange(location: index.utf16Offset(in: title), length: $0.changeText.count))
            }
        }
        return NSAttributedString(attributedString: attributedString)
    }
    
    static func setAsLink(forAttributedString attributedString: NSMutableAttributedString, value: String, range: String) {
        return attributedString.addAttribute(NSAttributedString.Key.link, value: value, range: attributedString.mutableString.range(of: range))
    }
}
