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
    
    func addNewTemplate(_ template: Template) {
        try! self.write {
            self.add(template)
        }
    }
    func addNewTemplateList(_ name: String, template: Template) {
        let tmp = template
        let table = CalcTable()
        table.tableName = name
        try! self.write {
            tmp.listTemplates.append(table)
        }
    }
    // --------------------------------------------------------------
    // updateメソッド
    // --------------------------------------------------------------
    func updateItem(_ before: CalcItem, after: CalcItem) {
        try! self.write {
            before.name = after.name
            before.quantity = after.quantity
            before.unit = after.unit
            before.unitPrice = after.unitPrice
        }
    }
    
    func updateTable(_ calcTable: CalcTable, name: String) {
        try! self.write {
            calcTable.tableName = name
        }
    }
    
    func updateNote(_ calcNote: CalcNote, name: String) {
        try! self.write {
            calcNote.noteName = name
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
