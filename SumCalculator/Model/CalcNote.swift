//
//  CalcNote.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/08.
//

import Foundation
import RealmSwift

class CalcNote: Object {
    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var editedAt = Date()
    @objc dynamic var noteName: String = "" {
        didSet {
            editedAt = Date()
        }
    }
    var calcTables: List<CalcTable> = List<CalcTable>(){
        didSet {
            editedAt = Date()
        }
    }
    var total: Decimal {
        get {
            var sum = Decimal()
            for calcTable in calcTables {
                sum += calcTable.subtotal
            }
            return sum
        }
    }
    
    /// calcTablesの中で最新のlatestEditedDateを返す。
    /// 末端にCalcItemが無いもの容認しているのでnilの場合もあり得る。
    var latestEditedAt: Date? {
        var latestDate = editedAt
        for calcTable in calcTables {
            let tableLatestDate = calcTable.latestEditedAt
            if latestDate > tableLatestDate {
                latestDate = tableLatestDate
            }
        }
        return latestDate
    }
    
    
    override static func primaryKey() -> String? {
            return "id"
    }
}
