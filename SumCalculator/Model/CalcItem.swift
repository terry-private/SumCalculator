//
//  CalcItem.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/08.
//

import Foundation
import RealmSwift

class CalcItem: Object {
    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var name: String = "" {
        didSet {
            editedAt = Date()
        }
    }
    @objc dynamic var unitPrice: Double = 0 {
        didSet {
            editedAt = Date()
        }
    }
    @objc dynamic var quantity: Double = 0 {
        didSet {
            editedAt = Date()
        }
    }
    
    @objc dynamic var unit: String = "" {
        didSet {
            editedAt = Date()
        }
    }
    
    @objc dynamic var editedAt = Date()
    
    override static func primaryKey() -> String? {
            return "id"
    }
    
    var subtotal: Double {
        get {
            return unitPrice * quantity
        }
    }
}
