//
//  RoundingTests.swift
//  RDHDecimalNumberOperations
//
//  Created by Richard Hodgkins on 30/11/2014.
//  Copyright (c) 2014 Rich H. All rights reserved.
//

import Foundation

#if os(watchOS)
// No testing supported
@testable import RDHDecimalNumberOperations
#else
    
import XCTest
    
#if DEBUG
@testable import RDHDecimalNumberOperations
#else
import RDHDecimalNumberOperations
#endif

class RoundingTests: XCTestCase {

    func testRoundingEnumMethod() {
        let value = NSDecimalNumber(string: "4.2")
        
        XCTAssertEqual(NSRoundingMode.RoundUp.round(value, scale: 0), NSDecimalNumber(string: "5"), "Incorrect")
        XCTAssertEqual(NSRoundingMode.RoundDown.round(value, scale: 0), NSDecimalNumber(string: "4"), "Incorrect")
    }
    
    func testRoundingOperator() {
        let value = NSDecimalNumber(string: "3.7")
        
        var rounded = value ~ (NSRoundingMode.RoundUp, 0)
        XCTAssertEqual(rounded, NSDecimalNumber(string: "4"), "Incorrect")
        
        rounded = value ~ (NSRoundingMode.RoundDown, 0)
        XCTAssertEqual(rounded, NSDecimalNumber(string: "3"), "Incorrect")
    }
    
    func testRoundingAssigmentOperator() {
        let value = NSDecimalNumber(string: "3.7")
        
        var rounded = value
        rounded ~= (NSRoundingMode.RoundUp, 0)
        XCTAssertEqual(rounded, NSDecimalNumber(string: "4"), "Incorrect")
        
        rounded = value
        rounded ~= (roundingMode: NSRoundingMode.RoundDown, scale: 0)
        XCTAssertEqual(rounded, NSDecimalNumber(string: "3"), "Incorrect")
    }

}

#endif