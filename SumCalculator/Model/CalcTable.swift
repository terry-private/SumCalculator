//
//  CalcTable.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/08.
//

import Foundation
import RealmSwift

class CalcTable: Object {
    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var tableName: String = ""{
        didSet {
            editedAt = Date()
        }
    }
    @objc dynamic var editedAt = Date()
    
    var calcItems: List<CalcItem> = List<CalcItem>() {
        didSet {
            editedAt = Date()
        }
    }
    
    var subtotal: Double {
        var sum = Double()
        for calcItem in calcItems {
            sum += calcItem.subtotal
        }
        return sum
    }
    
    var latestEditedAt: Date {
        var latestDate = editedAt
        for calcItem in calcItems {
            if latestDate > calcItem.editedAt {
                latestDate = calcItem.editedAt
            }
        }
        return latestDate
    }
    
    
    override static func primaryKey() -> String? {
            return "id"
    }
    
}
