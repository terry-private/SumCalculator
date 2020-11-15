//
//  FloatTests.swift
//  SumCalculatorTests
//
//  Created by 若江照仁 on 2020/11/15.
//

import XCTest
@testable import SumCalculator

class FloatTests: XCTestCase {

    func testCurrency() throws {
        var testFloat: Float = -2184.1
        XCTAssertEqual(testFloat.currency, "-¥2,184.1")
        
        testFloat = 0.1
        XCTAssertNotEqual(testFloat.currency, "¥0.10")
        
    }

}
