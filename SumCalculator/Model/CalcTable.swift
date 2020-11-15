//
//  CalcTable.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/08.
//

import Foundation

class CalcTable {
    let id: String = ""
    var tableName: String = ""
    var calcItems: [CalcItem] = []
    var subtotal: Float {
        get {
            var sum = Float()
            for calcItem in calcItems {
                sum += calcItem.subtotal
            }
            return sum
        }
    }
    
}
