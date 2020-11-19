//
//  DoubleTests.swift
//  SumCalculatorTests
//
//  Created by 若江照仁 on 2020/11/15.
//

import XCTest
@testable import SumCalculator

class DoubleTests: XCTestCase {

    func testCurrency() throws {
        var testDouble: Double = -2184.1
        XCTAssertEqual(testDouble.currency, "-2,184.1円")
        
        testDouble = 0.1
        XCTAssertNotEqual(testDouble.currency, "0.10円")
        
    }
    
    func testQuantity() throws {
        var testDouble: Double = -2184.1
        XCTAssertEqual(testDouble.quantity, "-2184.1")
        
        testDouble = 0.1
        XCTAssertNotEqual(testDouble.quantity, "0.10")
    }

}
