//
//  Realm - Extension.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/15.
//

import Foundation
import RealmSwift

extension Realm {
    
    // --------------------------------------------------------------
    // addメソッド
    // --------------------------------------------------------------
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
    // --------------------------------------------------------------
    // deleteメソッド
    // --------------------------------------------------------------
    func deleteItem(calcItem: CalcItem) {
        try! self.write {
            self.delete(calcItem)
        }
    }
    func deleteTable(calcTable: CalcTable) {
        for i in calcTable.calcItems {
            self.deleteItem(calcItem: i)
        }
        try! self.write {
            self.delete(calcTable)
        }
    }
    func deleteNote(calcNote: CalcNote) {
        for i in calcNote.calcTables {
            self.deleteTable(calcTable: i)
        }
        try! self.write {
            self.delete(calcNote)
        }
    }
}
