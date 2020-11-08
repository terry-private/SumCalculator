//
//  CalcTable.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/08.
//

import Foundation

struct CalcTable {
    let id: String = ""
    var tableName: String = ""
    var calcItems: [CalcItem] = []
    var subtotal: Int {
        get {
            var sum = 0
            for ci in calcItems {
                sum += ci.subtotal
            }
            return sum
        }
    }
    
}
