//
//  CalcNote.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/08.
//

import Foundation

class CalcNote {
    let id: String = ""
    var noteName: String = ""
    var calcTables: [CalcTable] = []
    var total: Int {
        get {
            var sum = 0
            for calcTable in calcTables {
                sum += calcTable.subtotal
            }
            return sum
        }
    }
}
