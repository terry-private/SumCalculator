//
//  TemplateItemListViewController.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/23.
//

import UIKit
import RealmSwift

protocol SetItemTemplateProtocol: class {
    func setItemTemplate(calcItem: CalcItem)
}

class TemplateItemListViewController: UIViewController {
    enum Mode {
        case Edit
        case Use
    }
    enum ItemOf {
        case Template
        case ListTemplate
    }
    
    var itemOf: ItemOf = .Template
    var mode: Mode = .Edit
    let cellId = "cellId"
    // ドメイン系のプロパティ
    var tableId = "" // 親のノートID {リロードの時にこれを使って note<CalcNote> の値をrealmから取ってくる
    var calcTable: CalcTable?
    var currentIndex = 0
    weak var delegate: SetItemTemplateProtocol?
    private var realm: Realm!
    
    @IBOutlet weak var itemListTableView: UITableView!
    @IBOutlet weak var templateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupEditButton()
        
        // リストテンプレの中の項目を追加するときだけ押せるようにしたいのでその他の場合にHiddenになるようにしてます。
        templateButton.isHidden = mode != .Edit || itemOf != .ListTemplate
        try! realm = Realm()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    func setupTableView() {
        itemListTableView.delegate = self
        itemListTableView.dataSource = self
        //itemListTableView.register(UINib(nibName: "TemplateItemListTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    func setupEditButton() {
        let editButtonItem = UIBarButtonItem(title: "編集", style: .plain, target: self, action: #selector(tappedEditButton))
//        editButtonItem.tintColor = .label
        navigationItem.setRightBarButton(editButtonItem, animated: true)
    }
    
    @objc private func tappedEditButton() {
        // アラート画面で新規ノートのタイトルを入力させます。
        var alertTextField: UITextField?
        let title = itemOf == .ListTemplate ? "リストのタイトル変更" : "フォルダのタイトル変更"
        let alert = UIAlertController(title: title, message: "タイトルを入力", preferredStyle: UIAlertController.Style.alert)
        
        // テキストフィールド追加
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            alertTextField = textField
            textField.text = self.calcTable?.tableName
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
                        self.realm.updateTable(self.calcTable!, name: text) // 強制アンラップ
                        self.reload()
                    }
                }
            }
        )
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func reload() {
        calcTable = realm.object(ofType: CalcTable.self, forPrimaryKey: tableId)
        DispatchQueue.main.async {
            self.navigationItem.title = self.calcTable?.tableName
            self.itemListTableView.reloadData()
        }
    }
    
    @IBAction func tappedNewButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "InputCalcItem", bundle: nil)
        let inputCalcItemViewController = storyboard.instantiateViewController(identifier: "InputCalcItemViewController") as! InputCalcItemViewController
        //inputCalcItemViewController.recordViewControllerDelegate = self
        inputCalcItemViewController.delegate = self
        inputCalcItemViewController.navigationItem.title = "新規項目の作成"
        inputCalcItemViewController.isTemplate = true
        let nav = UINavigationController(rootViewController: inputCalcItemViewController)
        
        self.present(nav,animated: true, completion: nil)
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

extension TemplateItemListViewController: SetItemTemplateProtocol {
    func setItemTemplate(calcItem: CalcItem) {
        let newCalcItem = Template.copyItem(calcItem: calcItem)
        realm.addNewItem(newCalcItem, parentTable: calcTable!) // 強制アンラップ
        reload()
        
    }
}

extension TemplateItemListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calcTable?.calcItems.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = itemListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TemplateItemListTableViewCell
        let item = calcTable?.calcItems[indexPath.row]
        let unit = item?.unit ?? ""

        cell.calcItemNameLabel.text = item?.name
        
        // unitPrice
        cell.unitPriceIntegerPartLabel.text = item?.unitPrice.unitPriceRounded.intPartCurrency
        cell.unitPriceAfterDotLabel.text = item?.unitPrice.unitPriceRounded.afterDot
        if unit == "" {
            cell.unitPriceUnitLabel.text = ""
        } else {
            cell.unitPriceUnitLabel.text = "円／\(unit)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if mode == .Use {

            delegate?.setItemTemplate(calcItem: calcTable?.calcItems[indexPath.row] ?? CalcItem())
            dismiss(animated: true, completion: nil)
//            presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            return
        }
        
        let storyboard = UIStoryboard(name: "InputCalcItem", bundle: nil)
        let inputCalcItemViewController = storyboard.instantiateViewController(identifier: "InputCalcItemViewController") as! InputCalcItemViewController
        inputCalcItemViewController.isTemplate = true
        inputCalcItemViewController.delegate = self
        inputCalcItemViewController.before = calcTable?.calcItems[indexPath.row]
        let nav = UINavigationController(rootViewController: inputCalcItemViewController)
        currentIndex = indexPath.row
        self.present(nav,animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let deleteItem = calcTable?.calcItems[indexPath.row] else { return }
        realm.deleteItem(calcItem: deleteItem)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
}

extension TemplateItemListViewController: InputCalcItemViewControllerDelegate {
    func inputData(calcItem: CalcItem, inputType: InputType) {
        if inputType == .AddNew {
            realm.addNewItem(calcItem, parentTable: calcTable!) // 強制アンラップ使ってます。
        } else {
            realm.updateItem(calcTable!.calcItems[currentIndex], after: calcItem) // 強制アンラップ使ってます。
        }
        reload()
    }
}


class TemplateItemListTableViewCell: UITableViewCell {
    @IBOutlet weak var calcItemNameLabel: UILabel!
    @IBOutlet weak var unitPriceIntegerPartLabel: UILabel!
    @IBOutlet weak var unitPriceAfterDotLabel: UILabel!
    @IBOutlet weak var unitPriceUnitLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
