//
//  CalcItemTests.swift
//  SumCalculatorTests
//
//  Created by 若江照仁 on 2020/11/08.
//

import XCTest
@testable import SumCalculator

class CalcItemTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSubtotal() throws {
        var calcItem = CalcItem()
        let testPrice = 2800
        let testQuantity = 3
        calcItem.unitPrice = testPrice
        calcItem.quantity = testQuantity
        XCTAssertEqual(calcItem.subtotal, testPrice * testQuantityΩ)
    }

}
