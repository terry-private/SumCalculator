//
//  CalcItem.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/08.
//

import Foundation

class CalcItem {
    let id: String = ""
    var name: String = ""
    var unitPrice: Int = 0
    var quantity: Int = 0
    
    var subtotal: Int {
        get {
            return unitPrice * quantity
        }
    }
}
