//
//  CalcTableTests.swift
//  SumCalculatorTests
//
//  Created by 若江照仁 on 2020/11/08.
//

import XCTest
@testable import SumCalculator

class CalcTableTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSubtotal() throws {
        let calcTable = CalcTable()
        
        let calcItem1 = CalcItem()
        calcItem1.quantity = 3
        calcItem1.unitPrice = 1000
        let testResult1 = 3000
        calcTable.calcItems.append(calcItem1)
        
        let calcItem2 = CalcItem()
        calcItem2.quantity = 4
        calcItem2.unitPrice = 2000
        let testResult2 = 8000
        calcTable.calcItems.append(calcItem2)
        
        XCTAssertEqual(calcTable.subtotal, testResult1 + testResult2)
        
        let calcItem3 = CalcItem()
        calcItem3.quantity = 2
        calcItem3.unitPrice = 4000
        calcTable.calcItems.append(calcItem3)
        
        XCTAssertNotEqual(calcTable.subtotal, 5000)
    }

}
