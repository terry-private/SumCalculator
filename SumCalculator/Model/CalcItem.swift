//
//  CalcItem.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/08.
//

import Foundation
import RealmSwift

class CalcItem: Object {
    dynamic var id: String = ""
    dynamic var name: String = ""
    dynamic var unitPrice: Float = 0
    dynamic var quantity: Float = 0
    
    override static func primaryKey() -> String? {
            return "id"
        }
    
    var subtotal: Float {
        get {
            return unitPrice * quantity
        }
    }
}
