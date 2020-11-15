//
//  CalcNoteTests.swift
//  SumCalculatorTests
//
//  Created by 若江照仁 on 2020/11/08.
//

import XCTest
@testable import SumCalculator

class CalcNoteTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTotal() throws {
        
        let calcNote = CalcNote()
        
        let calcTable1 = CalcTable()
        
        let calcItem1 = CalcItem()
        calcItem1.quantity = 3
        calcItem1.unitPrice = 1000
        let testResult1:Float = 3000
        calcTable1.calcItems.append(calcItem1)
        
        let calcItem2 = CalcItem()
        calcItem2.quantity = 4
        calcItem2.unitPrice = 2000
        let testResult2:Float = 8000
        calcTable1.calcItems.append(calcItem2)
        
        calcNote.calcTables.append(calcTable1)
        
        let calcTable2 = CalcTable()
        
        let calcItem3 = CalcItem()
        calcItem3.quantity = 2
        calcItem3.unitPrice = 4000
        let testResult3:Float = 8000
        calcTable2.calcItems.append(calcItem3)
        
        calcNote.calcTables.append(calcTable2)
        
        XCTAssertEqual(calcNote.total, testResult1 + testResult2 + testResult3)
        
        let calcItem4 = CalcItem()
        calcItem4.quantity = 1
        calcItem4.unitPrice = 5000
        let testResult4:Float = 5001
        calcTable2.calcItems.append(calcItem4)
        
        XCTAssertNotEqual(calcNote.total, testResult1 + testResult2 + testResult3 + testResult4)
        
        
    }

}
