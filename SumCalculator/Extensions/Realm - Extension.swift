//
//  Realm - Extension.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/15.
//

import Foundation
import RealmSwift

extension Realm {
    func addNewNote(_ name: String) {
        let note = CalcNote()
        note.noteName = name
        try! self.write {
            self.add(note)
        }
    }
    func addNewTable(_ name: String, parentNote: CalcNote) {
        let note = parentNote
        let table = CalcTable()
        table.tableName = name
        try! self.write {
            note.calcTables.append(table)
        }
    }
    func addNewItem(_ calcItem: CalcItem, parentTable: CalcTable) {
        try! self.write {
            parentTable.calcItems.append(calcItem)
        }
    }
}
