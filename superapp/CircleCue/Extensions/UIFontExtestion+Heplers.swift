//
//  UIFontExtestion+Heplers.swift
//  CRT
//
//  Created by QTS Coder on 8/15/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

enum FontName: Int {
    case light = 0
    case regular = 1
    case semiBold = 2
    case bold = 3
    case italic = 4
    case semiItalic = 5
    case boldItalic = 6
    
    var font: String {
        switch self {
            case .light:
                return "MyriadPro-Light"
            case .regular:
                return "MyriadPro-Regular"
            case .semiBold:
                return "MyriadPro-Semibold"
            case .bold:
                return "MyriadPro-Bold"
            case .italic:
                return "MyriadPro-SemiboldIt"
            case .semiItalic:
                return "MyriadPro-It"
            case .boldItalic:
                return "MyriadPro-BoldIt"
                
        }
    }
}

extension UIFont {
    
    static func myriadProRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontName.regular.font, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func myriadProSemiBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontName.semiBold.font, size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    static func myriadProBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontName.bold.font, size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    static func myriadProLight(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontName.light.font, size: size) ?? UIFont.systemFont(ofSize: size, weight: .light)
    }
    
    static func myriadProItalic(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontName.italic.font, size: size) ?? UIFont.italicSystemFont(ofSize: size)
    }
    
    static func myriadProSemiBoldItalic(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontName.semiItalic.font, size: size) ?? UIFont.italicSystemFont(ofSize: size)
    }
    
    static func myriadProBoldItalic(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontName.boldItalic.font, size: size) ?? UIFont.italicSystemFont(ofSize: size)
    }
}
