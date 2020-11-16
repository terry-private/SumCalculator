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
    @objc dynamic var tableName: String = ""
    var calcItems: List<CalcItem> = List<CalcItem>()
    var subtotal: Float {
        var sum = Float()
        for calcItem in calcItems {
            sum += calcItem.subtotal
        }
        return sum
    }
    
    var latestEditedAt: Date? {
        var latestDate: Date?
        for calcItem in calcItems {
            if latestDate == nil {
                latestDate = calcItem.latestEditedAt
            }else if latestDate! > calcItem.latestEditedAt {
                latestDate = calcItem.latestEditedAt
            }
        }
        return latestDate
    }
    
    
    override static func primaryKey() -> String? {
            return "id"
    }
    
}
