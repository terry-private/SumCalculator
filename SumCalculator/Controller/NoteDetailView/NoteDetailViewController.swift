//
//  NoteDetailViewController.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/12.
//

import UIKit
import RealmSwift

protocol Reloadable: AnyObject{
    func reload()
}

class NoteDetailViewController: UIViewController, Reloadable {
    let cellId = "cellId"
    let addNewCellId = "addNewCellId"
//    var searchController: UISearchController!
//    var indicator = UIActivityIndicatorView()
    var currentIndexPath: IndexPath?
    weak var delegate: Reloadable?
    // ドメイン系のプロパティ
    var noteId = "" // 親のノートID {リロードの時にこれを使って note<CalcNote> の値をrealmから取ってくる
    var calcNote: CalcNote?
    private var realm: Realm!
    
    // -------------------------------------------------
    // IBOutlet
    // -------------------------------------------------
    @IBOutlet weak var totalAmountIntegerPartLabel: UILabel!
    @IBOutlet weak var totalAmountAfterDotLabel: UILabel!
    @IBOutlet weak var noteDetailTableView: UITableView!

    // -------------------------------------------------
    // ライフサイクル
    // -------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // 各パーツのセットアップ
        setupTableView()
        navigationController?.navigationItem.backBarButtonItem?.action = #selector(back)
        //データベースの準備
        realm = try! Realm()
    }
    
    @objc func back() {
        delegate?.reload()
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    // -------------------------------------------------
    // setUp系
    // -------------------------------------------------
    func setupTableView() {
        noteDetailTableView.delegate = self
        noteDetailTableView.dataSource = self
        noteDetailTableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    // -------------------------------------------------
    // reload
    // -------------------------------------------------
    func reload() {
        calcNote = realm.object(ofType: CalcNote.self, forPrimaryKey: noteId)
        DispatchQueue.main.async {
            self.navigationItem.title = self.calcNote?.noteName
            self.totalAmountIntegerPartLabel.text = self.calcNote?.total.totalRounded.intPartCurrency
            self.totalAmountAfterDotLabel.text = self.calcNote?.total.totalRounded.afterDot
            self.noteDetailTableView.reloadData()
        }
    }
    
    // -------------------------------------------------
    // IBAction
    // -------------------------------------------------
    @IBAction func tappedNewButton(_ sender: Any) {
        openAddListAlert()
    }
    @IBAction func tappedTemplateButton(_ sender: Any) {
        openAddTemplateListSelector()
    }
    @IBAction func tappedEditButton(_ sender: Any) {
        // アラート画面で新規ノートのタイトルを入力させます。
        var alertTextField: UITextField?
        let alert = UIAlertController(title: "ノートのタイトルを変更", message: "タイトルを入力", preferredStyle: UIAlertController.Style.alert)
        
        // テキストフィールド追加
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            alertTextField = textField
            textField.text = self.calcNote?.noteName
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
                        self.realm.updateNote(self.calcNote!, name: text) // 強制アンラップ
                        self.reload()
                    }
                }
            }
        )
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    // -------------------------------------------------
    // 画面遷移系
    // -------------------------------------------------
    func openAddNewListAlert() {
        // アラート画面で新規ノートのタイトルを入力させます。
        var alertTextField: UITextField?
        let alert = UIAlertController(title: "新規のリストを追加", message: "タイトルを入力", preferredStyle: UIAlertController.Style.alert)
        
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
                        self.realm.addNewTable(text, parentNote: self.calcNote!) // 強制アンラップ
                        self.reload()
                    }
                }
            }
        )
        present(alert, animated: true, completion: nil)
    }
    func openAddTemplateListSelector() {
        let storyboard = UIStoryboard(name: "TemplateTableList", bundle: nil)
        let templateTableListViewController = storyboard.instantiateViewController(identifier: "TemplateTableListViewController") as! TemplateTableListViewController
        //inputCalcItemViewController.recordViewControllerDelegate = self
        templateTableListViewController.mode = .Use
        templateTableListViewController.tableDelegate = self
        templateTableListViewController.navigationItem.title = "テンプレからリストを追加"
        let nav = UINavigationController(rootViewController: templateTableListViewController)
        
        self.present(nav,animated: true, completion: nil)
    }
    
}

extension NoteDetailViewController: SetTableTemplateProtocol {
    func setTableTemplate(calcTable: CalcTable) {
        let newCalcTable = Template.copyTable(calcTable: calcTable)
        realm.addNewTableForTemplate(newCalcTable, parentNote: calcNote!) // 強制アンラップ
        reload()
    }
}

extension NoteDetailViewController: CalcItemViewDelegate {
    func tappedCalcItem(calcItem: CalcItem) {
        let storyboard = UIStoryboard(name: "InputCalcItem", bundle: nil)
        let inputCalcItemViewController = storyboard.instantiateViewController(identifier: "InputCalcItemViewController") as! InputCalcItemViewController
        inputCalcItemViewController.delegate = self
        inputCalcItemViewController.before = calcItem
        let nav = UINavigationController(rootViewController: inputCalcItemViewController)
        self.present(nav,animated: true, completion: nil)
    }
}

extension NoteDetailViewController: InputCalcItemViewControllerDelegate{
    func inputData(calcItem: CalcItem, inputType: InputType) {
        realm.updateItem2(calcItem)
        reload()
    }
}

extension NoteDetailViewController: AddNewTableProtocol {
    // テンプレから追加か新規追加か選ばせるアラートを出します。
    func openAddListAlert() {
        let alert = UIAlertController(title: "リストを追加します", message: "追加するリストの選択", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "テンプレのリスト", style: .default) { _ in
            self.openAddTemplateListSelector()
        })
        alert.addAction(UIAlertAction(title: "新規のリスト", style: .default) { _ in
            self.openAddNewListAlert()
        })
        present(alert, animated: true, completion: nil)
    }
}

extension NoteDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (calcNote?.calcTables.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == calcNote?.calcTables.count ?? 0 {
            let cell = noteDetailTableView.dequeueReusableCell(withIdentifier: addNewCellId, for: indexPath) as! AddNewTableCell
            cell.delegate = self
            cell.itemOverView.layer.cornerRadius = 10
            cell.setTarget()
            return cell
        }
        let cell = noteDetailTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NoteTableViewCell
        cell.table = calcNote?.calcTables[indexPath.row]
        cell.delegate = self
        cell.reloadableDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == calcNote?.calcTables.count ?? 0 {
            return 60
        }
        let itemsCount = calcNote?.calcTables[indexPath.row].calcItems.count ?? 0
        return CGFloat(100 + 64 * itemsCount)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // prepareの処理でindexを使いたいのでselfのindexに一旦保持します。
        currentIndexPath = indexPath
        performSegue(withIdentifier: "openTable", sender: self)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row == calcNote?.calcTables.count ?? 0 {
            return
        }
        guard let deleteItem = calcNote?.calcTables[indexPath.row] else { return }
        realm.deleteTable(calcTable: deleteItem)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // 遷移前に遷移先Viewにモデルとそのデリゲートをセットします。
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let indexPath = currentIndexPath else { return }
        if segue.identifier == "openTable"{
            let tableDetailVC = segue.destination as! TableDetailViewController
            tableDetailVC.tableId = calcNote?.calcTables[indexPath.row].id ?? ""
            tableDetailVC.navigationItem.leftBarButtonItem?.title = calcNote?.noteName
//            let s = UIStoryboardSegue(identifier: "openTable", source: self, destination: <#T##UIViewController#>)
        }
    }
}



protocol AddNewTableProtocol: AnyObject {
    func openAddListAlert()
}

class AddNewTableCell: UITableViewCell {
    weak var delegate: AddNewTableProtocol?
    @IBOutlet weak var itemOverView: ItemOverView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    func setTarget() {
        itemOverView.setTarget(self, selector: #selector(tappedItemOverView))
    }
    @objc func tappedItemOverView() {
        delegate?.openAddListAlert()
    }
}
