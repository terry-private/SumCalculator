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
    @objc dynamic var _unitPrice: String = "0" {
        didSet {
            editedAt = Date()
        }
    }
    @objc dynamic var _quantity: String = "0" {
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
    
    var subtotal: Decimal {
        get {
            return unitPrice * quantity
        }
    }
    
    var unitPrice: Decimal {
        get {
            return Decimal(string: _unitPrice) ?? Decimal()
        }
        set {
            _unitPrice = newValue.description
        }
    }
    
    var quantity: Decimal {
        get {
            return Decimal(string: _quantity) ?? Decimal()
        }
        set {
            _quantity = newValue.description
        }
    }
    
}
