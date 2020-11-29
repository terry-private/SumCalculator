//
//  DecimalTests.swift
//  SumCalculatorTests
//
//  Created by 若江照仁 on 2020/11/22.
//

import XCTest
@testable import SumCalculator
class DecimalTests: XCTestCase {

    func testDecimalCurrency() throws {
        var testDecimal: Decimal = Decimal(string: "-12345.6789")!
        XCTAssertEqual(testDecimal.currency, "-12,345.6789")
        
        testDecimal = 0.1
        XCTAssertNotEqual(testDecimal.currency, "0.10")
    }
    
}
