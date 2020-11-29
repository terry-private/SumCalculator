//
//  TemplateTableListViewController.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/23.
//

import UIKit
import RealmSwift

protocol SetTableTemplateProtocol: class {
    func setTableTemplate(calcTable: CalcTable)
}

class TemplateTableListViewController: UIViewController{
    let cellId = "cellId"
    private var realm: Realm!
    var template: Template?
    var calcTables: List<CalcTable>?
    weak var tableDelegate: SetTableTemplateProtocol?
    weak var itemDelegate: SetItemTemplateProtocol?
    
    enum Mode {
        case Edit
        case Use
    }
    var mode: Mode = .Edit
    
    @IBOutlet weak var listTableView: UITableView!
    
    // -------------------------------------------------
    // ライフサイクル
    // -------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(UINib(nibName: "TemplateTableListCell", bundle: nil), forCellReuseIdentifier: cellId)
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
        calcTables = template!.listTemplates
        DispatchQueue.main.async {
            self.listTableView.reloadData()
        }
    }
    
    
    @IBAction func tappedNewButton(_ sender: Any) {
        var alertTextField: UITextField?
        let alert = UIAlertController(title: "リストのテンプレを新規作成", message: "タイトルを入力", preferredStyle: UIAlertController.Style.alert)
        
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
                        self.realm.addNewTemplateList(text, template: self.template!)// 強制アンラップ
                        self.reload()
                    }
                }
            }
        )
        self.present(alert, animated: true, completion: nil)
//        let storyboard = UIStoryboard(name: "InputNewName", bundle: nil)
//        let inputNewNameViewController = storyboard.instantiateViewController(identifier: "InputNewNameViewController") as! InputNewNameViewController
//        //inputCalcItemViewController.recordViewControllerDelegate = self
//        inputNewNameViewController.delegate = self
//        switch templateType {
//        case .Table:
//            inputNewNameViewController.navigationItem.title = "リストテンプレート新規作成"
//        case .Item:
//            inputNewNameViewController.navigationItem.title = "項目テンプレートのフォルダ作成"
//        }
//        let nav = UINavigationController(rootViewController: inputNewNameViewController)
//
//        self.present(nav,animated: true, completion: nil)
    }
    
    @IBAction func tappedTemplateButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "TemplateItemFolderList", bundle: nil)
        let templateTableListViewController = storyboard.instantiateViewController(identifier: "TemplateItemFolderListViewController") as! TemplateItemFolderListViewController
        //inputCalcItemViewController.recordViewControllerDelegate = self
        templateTableListViewController.mode = .Use
        templateTableListViewController.itemDelegate = self
        templateTableListViewController.navigationItem.title = "テンプレから項目を作成"
        let nav = UINavigationController(rootViewController: templateTableListViewController)
        
        self.present(nav,animated: true, completion: nil)
    }
}

//extension TemplateTableListViewController: InputNewNameDelegate {
//    func addNew(name: String) {
//        switch templateType {
//        case .Table:
//            realm.addNewTemplateList(name, template: template!)
//        case .Item:
//            realm.addNewTemplateItemFolder(name, template: template!)
//        }
//        
//        reload()
//    }
//    
//    func upDate(name: String) {
//        
//    }
//    
//}

extension TemplateTableListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calcTables?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let itemsCount = calcTables?[indexPath.row].calcItems.count ?? 0
        return CGFloat(100 + 44 * itemsCount)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TemplateTableListCell
        cell.table = calcTables?[indexPath.row] ?? CalcTable()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // テンプレを使う時
        if mode == .Use {
            tableDelegate?.setTableTemplate(calcTable: calcTables![indexPath.row])
            dismiss(animated: true, completion: nil)
            return
        }
        
        // テンプレを編集する時
        let storyboard = UIStoryboard(name: "TemplateItemList", bundle: nil)
        let templateItemListViewController = storyboard.instantiateViewController(identifier: "TemplateItemListViewController") as! TemplateItemListViewController
        templateItemListViewController.tableId = calcTables?[indexPath.row].id ?? ""
        templateItemListViewController.itemOf = .ListTemplate
        navigationController!.pushViewController(templateItemListViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let deleteItem = calcTables?[indexPath.row] else { return }
        realm.deleteTable(calcTable: deleteItem)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
}

extension TemplateTableListViewController: SetItemTemplateProtocol {
    func setItemTemplate(calcItem: CalcItem) {
        itemDelegate?.setItemTemplate(calcItem: calcItem)
//        dismiss(animated: true, completion: nil)
    }
}
