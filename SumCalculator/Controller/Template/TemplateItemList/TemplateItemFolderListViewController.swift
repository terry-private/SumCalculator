//
//  TemplateItemFolderListViewController.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/25.
//

import UIKit
import RealmSwift

class TemplateItemFolderListViewController: UIViewController {
    let cellId = "cellId"
    private var realm: Realm!
    var template: Template?
    var calcTables: List<CalcTable>?
    weak var itemDelegate: SetItemTemplateProtocol?
    
    enum Mode {
        case Edit
        case Use
    }
    var mode: Mode = .Edit
    
    @IBOutlet weak var templateItemFolderListTableView: UITableView!
    
    
    // -------------------------------------------------
    // ライフサイクル
    // -------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        templateItemFolderListTableView.delegate = self
        templateItemFolderListTableView.dataSource = self
        try! realm = Realm()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    // -------------------------------------------------
    // reload
    // -------------------------------------------------
    func reload() {
        let templates = realm.objects(Template.self)
        
        
        if templates.count == 0 {
            template = Template()
            realm.addNewTemplate(template!)
        } else {
            template = templates[0]
        }
        
        calcTables = template!.itemTemplates
        
        DispatchQueue.main.async {
            self.templateItemFolderListTableView.reloadData()
        }
    }
    
    
    
    @IBAction func tappedNewButton(_ sender: Any) {
        var alertTextField: UITextField?
        let alert = UIAlertController(title: "フォルダを新規作成", message: "タイトルを入力", preferredStyle: UIAlertController.Style.alert)
        
        // テキストフィールド追加
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            alertTextField = textField
            textField.text = ""
            textField.placeholder = "タイトル"
            // textField.isSecureTextEntry = true
        })
        
        // キャンセルボタン追加
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: UIAlertAction.Style.cancel,
                handler: nil))
        
        // OKボタン追加
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default) { _ in
                if let text = alertTextField?.text {
                    if text != "" {
                        self.realm.addNewTemplateItemFolder(text, template: self.template!) // 強制アンラップ
                        self.reload()
                    }
                }
            }
        )
        self.present(alert, animated: true, completion: nil)
    }
    

}

extension TemplateItemFolderListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calcTables?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = templateItemFolderListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TemplateItemFolderListTableCell
        cell.calcTableNameLabel.text = calcTables?[indexPath.row].tableName
        cell.calcItemCountLabel.text = "\(String(calcTables?[indexPath.row].calcItems.count ?? 0))項目"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "TemplateItemList", bundle: nil)
        let templateItemListViewController = storyboard.instantiateViewController(identifier: "TemplateItemListViewController") as! TemplateItemListViewController
        templateItemListViewController.tableId = calcTables?[indexPath.row].id ?? ""
        if mode == .Use {
            templateItemListViewController.delegate = self
            templateItemListViewController.mode = .Use
        }
        navigationController!.pushViewController(templateItemListViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let deleteItem = calcTables?[indexPath.row] else { return }
        realm.deleteTable(calcTable: deleteItem)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
}

extension TemplateItemFolderListViewController: SetItemTemplateProtocol {
    func setItemTemplate(calcItem: CalcItem) {
        itemDelegate?.setItemTemplate(calcItem: calcItem)
//        dismiss(animated: true, completion: nil)
    }
}

class TemplateItemFolderListTableCell: UITableViewCell {
    @IBOutlet weak var calcTableNameLabel: UILabel!
    @IBOutlet weak var calcItemCountLabel: UILabel!
    
}
