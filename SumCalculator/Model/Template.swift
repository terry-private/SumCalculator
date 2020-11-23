//
//  Template.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/22.
//

import Foundation
import RealmSwift

class Template: Object {
    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var editedAt = Date()
    @objc dynamic var noteName: String = "" {
        didSet {
            editedAt = Date()
        }
    }
    var listTemplates: List<CalcTable> = List<CalcTable>(){
        didSet {
            editedAt = Date()
        }
    }
    
    var itemTemplates: List<CalcTable> = List<CalcTable>() {
        didSet {
            editedAt = Date()
        }
    }
    
    /// calcTablesの中で最新のlatestEditedDateを返す。
    /// 末端にCalcItemが無いもの容認しているのでnilの場合もあり得る。
    var latestEditedAt: Date? {
        var latestDate = editedAt
        for calcTable in listTemplates {
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
    
    class func copyItem(calcItem: CalcItem) -> CalcItem {
        let copy = CalcItem()
        copy.name = calcItem.name
        copy.unit = calcItem.unit
        copy.unitPrice = calcItem.unitPrice
        return copy
    }
    
    class func copyTable(calcTable: CalcTable) -> CalcTable {
        let copy = CalcTable()
        copy.tableName = calcTable.tableName
        for i in calcTable.calcItems {
            copy.calcItems.append(self.copyItem(calcItem: i))
        }
        return copy
    }
}
