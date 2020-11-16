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
    @objc dynamic var noteName: String = ""
    var calcTables: List<CalcTable> = List<CalcTable>()
    var total: Float {
        get {
            var sum = Float()
            for calcTable in calcTables {
                sum += calcTable.subtotal
            }
            return sum
        }
    }
    
    /// calcTablesの中で最新のlatestEditedDateを返す。
    /// 末端にCalcItemが無いもの容認しているのでnilの場合もあり得る。
    var latestEditedAt: Date? {
        var latestDate: Date?
        for calcTable in calcTables {
            if let calcDate = calcTable.latestEditedAt {
                if latestDate == nil {
                    latestDate = calcDate
                }else if latestDate! > calcDate {
                    latestDate = calcDate
                }
            }
        }
        return latestDate
    }
    
    
    override static func primaryKey() -> String? {
            return "id"
    }
}
