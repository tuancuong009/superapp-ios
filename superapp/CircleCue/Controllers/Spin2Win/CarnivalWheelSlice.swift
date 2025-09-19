//
//  CarnivalWheelSlice.swift

import Foundation
import UIKit
public class CarnivalWheelSlice: FortuneWheelSliceProtocol {
    
    public enum Style {
        case brickRed
        case sandYellow
        case babyBlue
        case deepBlue
    }
    
    public var title: String
    public var degree: CGFloat = 0.0
    
    public var backgroundColor: UIColor? {
        switch style {
        case .brickRed: return UIColor.init(hex: "16b78e")
        case .sandYellow: return UIColor.init(hex: "1a3a6b")
        case .babyBlue: return UIColor.init(hex: "f14e2b")
        case .deepBlue: return UIColor.init(hex: "f7b016")
        }
    }
    
    public var fontColor: UIColor {
        return UIColor.white
    }
    
    public var offsetFromExterior:CGFloat {
        return 20.0
    }
    
    public var font: UIFont {
        switch style {
        case .brickRed: return .myriadProBold(ofSize: 13)
        case .sandYellow: return .myriadProBold(ofSize: 17)
        case .babyBlue: return .myriadProBold(ofSize: 13)
        case .deepBlue: return .myriadProBold(ofSize: 17)
        }
    }
    
    public var stroke: StrokeInfo? {
        switch style {
        case .brickRed:
            return StrokeInfo(color: UIColor.init(hex: "00ab7e"), width: 6.0)
        case .sandYellow:
            return StrokeInfo(color: UIColor.init(hex: "2b2860"), width: 6.0)
        case .babyBlue:
            return StrokeInfo(color: UIColor.init(hex: "ed1c24"), width: 6.0)
        case .deepBlue:
            return StrokeInfo(color: UIColor.init(hex: "f6a71c"), width: 6.0)
        }
        
    }
    
    public var style:Style = .brickRed
    
    public init(title:String) {
        self.title = title
    }
    
    public convenience init(title:String, degree:CGFloat) {
        self.init(title:title)
        self.degree = degree
    }
    
}
