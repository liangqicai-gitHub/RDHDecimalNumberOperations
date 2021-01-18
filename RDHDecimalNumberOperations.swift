//
//  RDHDecimalNumberOperations.swift
//  RDHDecimalNumberOperations
//
//  Created by Richard Hodgkins on 28/11/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

import Foundation

// MARK: - Equivalence

extension NSDecimalNumber: Comparable {
}

public func == (left: NSDecimalNumber, right: NSDecimalNumber) -> Bool {
    return left.isEqual(to: right)
}

public func < (left: NSDecimalNumber, right: NSDecimalNumber) -> Bool {
    return left.compare(right) == ComparisonResult.orderedAscending
}


// MARK: - Addition

public prefix func + (value: NSDecimalNumber) -> NSDecimalNumber {
    return value
}

public func + (left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber {
    return left.adding(right)
}

public func += ( left: inout NSDecimalNumber, right: NSDecimalNumber) {
    left = left + right
}

public prefix func ++ ( value: inout NSDecimalNumber) -> NSDecimalNumber {
    value += NSDecimalNumber.one
    return value
}

public postfix func ++ ( value: inout NSDecimalNumber) -> NSDecimalNumber {
    let result = value
    ++value
    return result
}

// MARK: Overflow

public func &+ (left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber {
    return left.adding(right, withBehavior: LenientDecimalNumberHandler)
}


// MARK: - Subtraction

//public prefix func - (value: NSDecimalNumber) -> NSDecimalNumber {
//    return value * NSDecimalNumber.minusOne
//}

public func - (left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber {
    return left.subtracting(right)
}

public func -= ( left: inout NSDecimalNumber, right: NSDecimalNumber) {
    left = left - right
}

public prefix func -- ( value: inout NSDecimalNumber) -> NSDecimalNumber {
    value -= NSDecimalNumber.one
    return value
}

public postfix func -- ( value: inout NSDecimalNumber) -> NSDecimalNumber {
    let result = value
    --value
    return result
}

// MARK: Overflow

public func &- (left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber {
    return left.subtracting(right, withBehavior: LenientDecimalNumberHandler)
}


// MARK: - Multiplication

public func * (left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber {
    return left.multiplying(by: right)
}

public func *= ( left: inout NSDecimalNumber, right: NSDecimalNumber) {
    left = left * right
}

// MARK: Overflow

public func &* (left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber {
    return left.multiplying(by: right, withBehavior: LenientDecimalNumberHandler)
}


// MARK: - Division

public func / (left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber {
    return left.dividing(by: right)
}

public func /= ( left: inout NSDecimalNumber, right: NSDecimalNumber) {
    left = left / right
}


//// MARK: - Powers
//
///// Give greater precedence than multiplication
//infix operator ** { precedence 155 }
//
///// Power
//public func ** (left: NSDecimalNumber, right: Int) -> NSDecimalNumber {
//    return left.decimalNumberByRaisingToPower(right)
//}
//
///// Match all assignment operators
//infix operator **= { associativity right precedence 90 }
//
///// 2 **= 2 will return 4
//public func **= (inout left: NSDecimalNumber, right: Int) {
//    left = left ** right
//}
//
//// MARK: Overflow
//
//// Match the power operator
//infix operator &** { precedence 155 }
//
//public func &** (left: NSDecimalNumber, right: Int) -> NSDecimalNumber {
//    return left.decimalNumberByRaisingToPower(right, withBehavior: LenientDecimalNumberHandler)
//}


// MARK: - Other

private let LenientDecimalNumberHandler: NSDecimalNumberBehaviors = NSDecimalNumberHandler(roundingMode: NSDecimalNumberHandler.default.roundingMode(), scale: NSDecimalNumberHandler.default.scale(), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)

//public extension NSDecimalNumber {
//
//    /// -1
//    public class var minusOne: NSDecimalNumber {
//        struct Lazily {
//            static let minusOne = NSDecimalNumber.zero() - NSDecimalNumber.one()
//        }
//        return Lazily.minusOne
//    }
//
//    public func isNaN() -> Bool {
//        return self == NSDecimalNumber.notANumber()
//    }
//
//    public func abs() -> NSDecimalNumber {
//
//        if (self.isNaN()) {
//            return NSDecimalNumber.notANumber()
//        }
//
//        if (self >= NSDecimalNumber.zero()) {
//            return self
//        } else {
//            return -self
//        }
//    }
//}

// MARK: - Rounding

private let VaraibleDecimalNumberHandler: (_ roundingMode: NSDecimalNumber.RoundingMode, _ scale: Int16) -> NSDecimalNumberBehaviors = { (roundingMode, scale) -> NSDecimalNumberHandler in
    
    return NSDecimalNumberHandler(roundingMode: roundingMode, scale: scale, raiseOnExactness: false, raiseOnOverflow: true, raiseOnUnderflow: true, raiseOnDivideByZero: true)
}

public extension NSDecimalNumber.RoundingMode {
 
    public func round(value: NSDecimalNumber, scale: Int16) -> NSDecimalNumber {
        return value.rounding(accordingToBehavior: VaraibleDecimalNumberHandler(self, scale))
    }
}

//// Act like cast operator
//infix operator ~ { precedence 132 }
//
///// @returns the rounded number
//public func ~ (left: NSDecimalNumber, right: (roundingMode: NSRoundingMode, scale: Int16)) -> NSDecimalNumber {
//    return right.roundingMode.round(left, scale: right.scale)
//}
//
///// Rounds the number in place
//public func ~= (inout left: NSDecimalNumber, right: (roundingMode: NSRoundingMode, scale: Int16)) {
//    left = left ~ right
//}


// MARK: - Creation

public extension String {
    
    /// @warning Uses NSDecimalNumber(string:)
    public var decimalNumber: NSDecimalNumber {
        return NSDecimalNumber(string: self)
    }
}


public extension NSDecimalNumber {
    public var countAfterDot: Int {
        if self == .notANumber {return 0}
        let substrings = self.stringValue.components(separatedBy: ".")
        if substrings.count == 2 {
            return substrings.last!.count
        } else {
            return 0
        }
    }
    
    public var twoCountAfterDotString: String {
        if self == .notANumber {return "0.00"}
        
        let dotCount = countAfterDot
        if dotCount == 0 {
            return self.stringValue + ".00"
        } else if dotCount == 1 {
            return self.stringValue + "0"
        } else if dotCount == 2 {
            return self.stringValue
        } else {
            return String(self.stringValue.prefix(self.stringValue.count - dotCount + 2))
        }
    }
}
