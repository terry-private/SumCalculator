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
        try! write {
            add(note)
        }
    }
    func addNewTable(_ name: String, parentNote: CalcNote) {
        let note = parentNote
        let table = CalcTable()
        table.tableName = name
        try! write {
            note.calcTables.append(table)
        }
    }
    func addNewTableForTemplate(_ newCalcTable: CalcTable, parentNote: CalcNote) {
        try! write {
            parentNote.calcTables.append(newCalcTable)
        }
    }
    
    func addNewItem(_ calcItem: CalcItem, parentTable: CalcTable) {
        try! write {
            parentTable.calcItems.append(calcItem)
        }
    }
    
    func addNewTemplate(_ template: Template) {
        try! write {
            add(template)
        }
    }
    func addNewTemplateList(_ name: String, template: Template) {
        let tmp = template
        let table = CalcTable()
        table.tableName = name
        try! write {
            tmp.listTemplates.append(table)
        }
    }
    func addNewTemplateItemFolder(_ name: String, template: Template) {
        let tmp = template
        let table = CalcTable()
        table.tableName = name
        try! write {
            tmp.itemTemplates.append(table)
        }
    }
    // --------------------------------------------------------------
    // updateメソッド
    // --------------------------------------------------------------
    func updateItem(_ before: CalcItem, after: CalcItem) {
        try! write {
            before.name = after.name
            before.quantity = after.quantity
            before.unit = after.unit
            before.unitPrice = after.unitPrice
            before.editedAt = after.editedAt
        }
    }
    
    func updateTable(_ calcTable: CalcTable, name: String) {
        try! write {
            calcTable.tableName = name
            calcTable.editedAt = Date()
        }
    }
    
    func updateNote(_ calcNote: CalcNote, name: String) {
        try! write {
            calcNote.noteName = name
            calcNote.editedAt = Date()
        }
    }
    
    // --------------------------------------------------------------
    // deleteメソッド
    // --------------------------------------------------------------
    func deleteItem(calcItem: CalcItem) {
        try! write {
            self.delete(calcItem)
        }
    }
    func deleteTable(calcTable: CalcTable) {
        for i in calcTable.calcItems {
            deleteItem(calcItem: i)
        }
        try! write {
            delete(calcTable)
        }
    }
    func deleteNote(calcNote: CalcNote) {
        for i in calcNote.calcTables {
            deleteTable(calcTable: i)
        }
        try! self.write {
            delete(calcNote)
        }
    }
    // --------------------------------------------------------------
    // 初期サンプルの作成
    // --------------------------------------------------------------
    func makeSample() {
        
        // --------------------------------------------------------------
        // サンプルのテンプレ作成（既にある場合も考慮してます。）
        // --------------------------------------------------------------
        let templates = objects(Template.self)
        let template: Template
        if templates.count == 0 {
            template = Template()
            addNewTemplate(template)
        } else {
            template = templates[0]
        }
        
        // --------------------------------------------------項目テンプレのフォルダ①
        let tmpCalcFolder1 = CalcTable()
        tmpCalcFolder1.tableName = "サンプルお肉フォルダ"
        try! write {
            template.itemTemplates.append(tmpCalcFolder1)
        }
        
        // 項目テンプレ1-1
        let tmpCalcItem1_1 = CalcItem()
        tmpCalcItem1_1.name = "カルビ"
        tmpCalcItem1_1.unit = "g"
        tmpCalcItem1_1.unitPrice = 2.56
        try! write {
            tmpCalcFolder1.calcItems.append(tmpCalcItem1_1)
        }
        // 項目テンプレ1-2
        let tmpCalcItem1_2 = CalcItem()
        tmpCalcItem1_2.name = "ロース"
        tmpCalcItem1_2.unit = "g"
        tmpCalcItem1_2.unitPrice = 2.82
        try! write {
            tmpCalcFolder1.calcItems.append(tmpCalcItem1_2)
        }
        
        // 項目テンプレ1-3
        let tmpCalcItem1_3 = CalcItem()
        tmpCalcItem1_3.name = "豚肉"
        tmpCalcItem1_3.unit = "g"
        tmpCalcItem1_3.unitPrice = 1.2
        try! write {
            tmpCalcFolder1.calcItems.append(tmpCalcItem1_3)
        }
        
        // 項目テンプレ1-4
        let tmpCalcItem1_4 = CalcItem()
        tmpCalcItem1_4.name = "チキン"
        tmpCalcItem1_4.unit = "g"
        tmpCalcItem1_4.unitPrice = 0.98
        try! write {
            tmpCalcFolder1.calcItems.append(tmpCalcItem1_4)
        }
        
        // --------------------------------------------------項目テンプレのフォルダ①
        let tmpCalcFolder2 = CalcTable()
        tmpCalcFolder2.tableName = "サンプルドリンクフォルダ"
        try! write {
            template.itemTemplates.append(tmpCalcFolder2)
        }
        // 項目テンプレ2-1
        let tmpCalcItem2_1 = CalcItem()
        tmpCalcItem2_1.name = "ビール"
        tmpCalcItem2_1.unit = "本(500ml)"
        tmpCalcItem2_1.unitPrice = 198
        try! write {
            tmpCalcFolder2.calcItems.append(tmpCalcItem2_1)
        }
        
        // 項目テンプレ2-2
        let tmpCalcItem2_2 = CalcItem()
        tmpCalcItem2_2.name = "コーラ"
        tmpCalcItem2_2.unit = "本(1.5ℓ)"
        tmpCalcItem2_2.unitPrice = 178
        try! write {
            tmpCalcFolder2.calcItems.append(tmpCalcItem2_2)
        }
        
        // 項目テンプレ2-3
        let tmpCalcItem2_3 = CalcItem()
        tmpCalcItem2_3.name = "水"
        tmpCalcItem2_3.unit = "本(2ℓ)"
        tmpCalcItem2_3.unitPrice = 100
        try! write {
            tmpCalcFolder2.calcItems.append(tmpCalcItem2_3)
        }
        
        // テンプレリスト作成
        
        let sampleList1 = Template.copyTable(calcTable: tmpCalcFolder1)
        sampleList1.tableName = "お肉リスト"
        try! write {
            template.listTemplates.append(sampleList1)
        }
        
        let sampleList2 = Template.copyTable(calcTable: tmpCalcFolder2)
        sampleList2.tableName = "ドリンクリスト"
        try! write {
            template.listTemplates.append(sampleList2)
        }
        
        
        // --------------------------------------------------------------
        // サンプル作成
        // --------------------------------------------------------------
        let sampleCalcNote = CalcNote()
        sampleCalcNote.noteName = "サンプルBBQ"
        try! write {
            add(sampleCalcNote)
        }
        
        let sampleCalcTable1 = Template.copyTable(calcTable: sampleList1)
        for item in sampleCalcTable1.calcItems {
            item.quantity = 500
        }
        try! write {
            sampleCalcNote.calcTables.append(sampleCalcTable1)
        }
        
        
        let sampleCalcTable2 = Template.copyTable(calcTable: sampleList2)
        sampleCalcTable2.calcItems[0].quantity = 6
        sampleCalcTable2.calcItems[1].quantity = 2
        sampleCalcTable2.calcItems[2].quantity = 4
        try! write {
            sampleCalcNote.calcTables.append(sampleCalcTable2)
        }
        
    }
}
