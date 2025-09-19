//
//  StringExtension+Helpers.swift
//  DesignMaterial
//
//  Created by QTS Coder on 8/25/20.
//

import UIKit

extension String {
    
    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    mutating func trim() {
        self = self.trimmed
    }
    
    var asURL: URL? {
        URL.init(string: self)
    }
    
    var asJSON: [String: Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
    
    var asArray: [Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any]
    }
    
    var asAttributedString: NSAttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
    }
    
    var containsOnlyDigits: Bool {
        let notDigits = NSCharacterSet.decimalDigits.inverted
        return rangeOfCharacter(from: notDigits, options: String.CompareOptions.literal, range: nil) == nil
    }
    
    var isAlphanumeric: Bool {
        !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    var isValidPhone: Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self.trimmed)
    }
    

    var wordCount: Int {
        let regex = try? NSRegularExpression(pattern: "\\w+")
        return regex?.numberOfMatches(in: self, range: NSRange(location: 0, length: self.utf16.count)) ?? 0
    }
    
    var bool: Bool? {
        if self == "0" || self == "false" {
            return false
        }
        if self == "1" || self == "true" {
            return true
        }
        return nil
    }
    
    var int: Int? {
        return Int(self)
    }
    
    func invalidURL() -> String {
        if self.hasPrefix("http") {
            return self
        }
        
        return "http://\(self)"
    }
    
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) { return self }
        return "\(prefix)\(self)"
    }
    
    var isImageURL: Bool {
        if self.lowercased().trimmed.hasSuffix(".jpg") || self.lowercased().trimmed.hasSuffix(".jpeg") || self.lowercased().trimmed.hasSuffix(".png") || self.lowercased().trimmed.hasSuffix(".bmp") {
            return true
        }
        
        return false
    }
    
    var flagIcon: String {
        var iconString = self
        if self.count > 2 {
            iconString = String(iconString[0...1])
        }
        return iconString
            .uppercased()
            .unicodeScalars
            .map({ 127397 + $0.value })
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
    
    func isValidSocialLink(host: String) -> Bool {
        if self.hasPrefix("http") {
            return true
        }
        
        if self.contains("www") {
            return true
        }
        
        if self.contains(host) {
            return true
        }
        
        return false
    }
    
    func invalidUrl()-> Bool{
        if self.trimmed.lowercased().hasPrefix("http") {
            return true
        }
        
        if self.trimmed.lowercased().contains("www") {
            return true
        }
        
        return false
    }
    
    func encodeUrlString() -> String {
        var allowedQueryParamAndKey = NSCharacterSet.urlQueryAllowed
        allowedQueryParamAndKey.remove(charactersIn: ";/?:@&=+$, ")
        let encode = self.addingPercentEncoding(withAllowedCharacters: allowedQueryParamAndKey)
        if let encoding = encode {
            return encoding
        }
        return self
    }
    
    // MARK: - SUBSCRIPT
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start..<end]
    }
    
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start...end]
    }
    
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        if end < start { return "" }
        return self[start...end]
    }
    
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex...end]
    }
    
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex..<end]
    }
    
    // MARK: - STRING.WIDTH(…) VÀ STRING.HEIGHT(…)
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

// MARK: - NSATTRIBUTEDSTRING
extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension String {
    
    func toAPIDate(format: AppDateFormat = .full) -> Date? {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format.rawValue
        dateFormat.timeZone = TimeZone(identifier: "America/Chicago")
        return dateFormat.date(from: self)
    }
    
    func toDate(_ format: AppDateFormat, timezone: TimeZone? = nil) -> Date? {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format.rawValue
        if let timezone = timezone {
            dateFormat.timeZone = timezone
        }
        return dateFormat.date(from: self)
    }
    
    func toDate(_ format: String, timezone: TimeZone? = nil) -> Date? {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        if let timezone = timezone {
            dateFormat.timeZone = timezone
        }
        return dateFormat.date(from: self)
    }
    
    var isTextFile: Bool {
        return self.lowercased().contains("txt") || self.lowercased().contains("doc") || self.lowercased().contains("docx")
    }
}

extension NSMutableAttributedString {
    func setAsLink(textToFind: String, linkName: String) {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedString.Key.link, value: linkName, range: foundRange)
        }
    }
    
    //Example
//    private let textView: UITextView = {
//        let textView = UITextView()
    
//        // Setup text and link for TextView
//        let mutableAttributedString = NSMutableAttributedString(string: "More ways to shop: Visit an Apple Store, call 1-800-MY-APPLE, or find a reseller.")
//        mutableAttributedString.setAsLink(textToFind: "Apple Store", linkName: "AppleStoreLink")
//        mutableAttributedString.setAsLink(textToFind: "1-800-MY-APPLE", linkName: "ApplePhoneNumber")
//        mutableAttributedString.setAsLink(textToFind: "find a reseller", linkName: "FindReseller")
//
//        textView.attributedText = mutableAttributedString
//        return textView
//    }()
    
//    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
//        if URL.absoluteString == "AppleStoreLink" {
//            // Handle action tap on AppleStoreLink
//            print("Go to Apple Store")
//            return true
//        } else if URL.absoluteString == "ApplePhoneNumber" {
//            // Handle action tap on ApplePhoneNumber
//            print("Call to Apple Phone")
//            return true
//        } else if URL.absoluteString == "FindReseller" {
//            // Handle action tap on FindReseller
//            print("Find a Reseller")
//            return true
//        }
//        return false
//    }
}
