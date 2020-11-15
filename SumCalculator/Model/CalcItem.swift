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
    var unitPrice: Float = 0
    var quantity: Float = 0
    
    var subtotal: Float {
        get {
            return unitPrice * quantity
        }
    }
}
