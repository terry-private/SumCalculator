//
//  NoteDetailViewController.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/12.
//

import UIKit
import RealmSwift

class NoteDetailViewController: UIViewController {
    let cellId = "cellId"
    var searchController: UISearchController!
    var indicator = UIActivityIndicatorView()
    var currentIndexPath: IndexPath?
    
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
        setupIndicator()
        setupSearchBar()
        //データベースの準備
        realm = try! Realm()
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
    func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "リストを検索します。"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    // クルクルインジゲーター設定
    func setupIndicator() {
        indicator.center = view.center
        indicator.style = UIActivityIndicatorView.Style.large
        view.addSubview(indicator)
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
        let storyboard = UIStoryboard(name: "InputNewName", bundle: nil)
        let inputNewNameViewController = storyboard.instantiateViewController(identifier: "InputNewNameViewController") as! InputNewNameViewController
        //inputCalcItemViewController.recordViewControllerDelegate = self
        inputNewNameViewController.delegate = self
        inputNewNameViewController.navigationItem.title = "新規リストの作成"
        let nav = UINavigationController(rootViewController: inputNewNameViewController)
        
        self.present(nav,animated: true, completion: nil)
    }
    
    @IBAction func tappedEditButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "InputNewName", bundle: nil)
        let inputNewNameViewController = storyboard.instantiateViewController(identifier: "InputNewNameViewController") as! InputNewNameViewController
        //inputCalcItemViewController.recordViewControllerDelegate = self
        inputNewNameViewController.delegate = self
        inputNewNameViewController.navigationItem.title = "タイトルの編集"
        inputNewNameViewController.originName = calcNote?.noteName ?? ""
        let nav = UINavigationController(rootViewController: inputNewNameViewController)
        
        self.present(nav,animated: true, completion: nil)
    }
}

//------------------------------------------------------------------------------
extension NoteDetailViewController: InputNewNameDelegate {
    func upDate(name: String) {
        func upDate(name: String) {
            realm.updateNote(calcNote!, name: name) // 強制アンラップ
            reload()
        }
    }
    
    func addNew(name: String) {
        realm.addNewTable(name, parentNote: calcNote!)
        reload()
    }
}


//------------------------------------------------------------------------------
/// UISearchBarDelegateのロジック周りをextensionとして分けます。
extension NoteDetailViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    // 編集だけでなくキーボードを開く時も
    // Apiのタスクとクルクルが止まる仕様(taskがrunningの場合のみ)
    func updateSearchResults(for searchController: UISearchController) {
        DispatchQueue.main.async {
            //self.repositoryListModel.cancel()
            self.indicator.stopAnimating()
        }
    }
    // 検索ボタン押下時処理　クルクルスタート
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // guard let searchWord = searchBar.text else { return }
        self.view.endEditing(true)
        indicator.startAnimating()
    }
}

//------------------------------------------------------------------------------
extension NoteDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calcNote?.calcTables.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = noteDetailTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NoteTableViewCell
        cell.table = calcNote?.calcTables[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let itemsCount = calcNote?.calcTables[indexPath.row].calcItems.count ?? 0
        return CGFloat(120 + 64 * itemsCount)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // prepareの処理でindexを使いたいのでselfのindexに一旦保持します。
        currentIndexPath = indexPath
        performSegue(withIdentifier: "openTable", sender: self)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        }
    }
    
}



