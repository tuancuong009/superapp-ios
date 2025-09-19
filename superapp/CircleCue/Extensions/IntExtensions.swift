//
//  IntExtensions.swift
//  CircleCue
//
//  Created by QTS Coder on 10/19/20.
//

import UIKit

extension Int {
    
    var float: Float {
        return Float(self)
    }
    
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    
    var double: Double {
        return Double(self)
    }
    
    var toVistorStats: String {
        if self <= 1 {
            return "\(self) Visitor"
        }
        return "\(self) Visitors"
    }
    
    var toOtherLike: String {
        if self <= 1 {
            return "\(self) other liked this"
        }
        return "\(self) others liked this"
    }
    
    var bool: Bool {
        return self != 0
    }
}

extension Double {
    
    var toMile: Double {
        self/AppConfiguration.MILE_CONVERT_VALUE
    }
    
    var distanceString: String {
        return String(format: "%.2f", arguments: [self.toMile]) + " Miles"
    }
}


extension Int {
    /// Determine if self is even (equivalent to `self % 2 == 0`)
    public var isEven: Bool {
        return (self % 2 == 0)
    }

    /// Determine if self is odd (equivalent to `self % 2 != 0`)
    public var isOdd: Bool {
        return (self % 2 != 0)
    }
    
    /// Determine if self is positive (equivalent to `self > 0`)
    public var isPositive: Bool {
        return (self > 0)
    }
    
    /// Determine if self is negative (equivalent to `self < 0`)
    public var isNegative: Bool {
        return (self < 0)
    }
    
    /**
     Convert self to a String.
     
     Most useful when operating on Int optionals.
     
     For example:
     ```
     let number: Int? = 5
     
     // instead of
     var string: String?
     if let number = number {
        string = String(number)
     }
     
     // use
     let string = number?.string
     ```
     */
    public var string: String {
        return String(self)
    }
    
    
    /**
     Convert self to an abbreviated String.
     
     Examples:
     ```
     Value : 598 -> 598
     Value : -999 -> -999
     Value : 1000 -> 1K
     Value : -1284 -> -1.3K
     Value : 9940 -> 9.9K
     Value : 9980 -> 10K
     Value : 39900 -> 39.9K
     Value : 99880 -> 99.9K
     Value : 399880 -> 0.4M
     Value : 999898 -> 1M
     Value : 999999 -> 1M
     Value : 1456384 -> 1.5M
     Value : 12383474 -> 12.4M
     ```
     */
    public var abbreviatedString: String {
        typealias Abbreviation = (threshold: Double, divisor: Double, suffix: String)
        let abbreviations: [Abbreviation] = [(0, 1, ""),
                                            (1000.0, 1000.0, "K"),
                                            (1_000_000.0, 1_000_000.0, "M"),
                                            (1_000_000_000.0, 1_000_000_000.0, "B")]
        // you can add more !
        
        let startValue = Double(abs(self))
        let abbreviation: Abbreviation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations where tmpAbbreviation.threshold <= startValue {
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        }()
        
        let numFormatter = NumberFormatter()
        let value = Double(self) / abbreviation.divisor
        numFormatter.positiveSuffix = abbreviation.suffix
        numFormatter.negativeSuffix = abbreviation.suffix
        numFormatter.allowsFloats = true
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 1
        
        return numFormatter.string(from: NSNumber(value: value)) ?? "\(self)"
    }

    
    /**
     Repeat a block `self` times.
     
     - parameter block: The block to execute (includes the current execution index)
     */
    public func `repeat`(_ block: (Int) throws -> Void) rethrows {
        guard self > 0 else { return }
        try (1...self).forEach(block)
    }
    
    /// Generate a random Int bounded by a closed interval range.
    public static func random(_ range: ClosedRange<Int>) -> Int {
        return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound + 1)))
    }
    
    /// Generate a random Int bounded by a range from min to max.
    public static func random(min: Int, max: Int) -> Int {
        return random(min...max)
    }
    
    public mutating func toggle() {
        if self == 0 {
            self = 1
        }
        self = 0
    }
    
    func durationTime() -> String {
        let minutes = (self / 60)
        let seconds = self % 60
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
}

