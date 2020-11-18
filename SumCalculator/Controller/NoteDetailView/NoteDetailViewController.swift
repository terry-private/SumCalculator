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
    var note: CalcNote?
    private var realm: Realm!

    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var noteDetailTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 各パーツのセットアップ
        setupTableView()
        setupIndicator()
        setupSearchBar()
        //データベースの準備
        realm = try! Realm()
        
    }
    
    func setupTableView() {
        noteDetailTableView.delegate = self
        noteDetailTableView.dataSource = self
        noteDetailTableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
    }
    func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "表を検索します。"
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    func reload() {
        note = realm.object(ofType: CalcNote.self, forPrimaryKey: noteId)
        DispatchQueue.main.async {
            self.navigationItem.title = self.note?.noteName
            self.totalAmountLabel.text = self.note?.total.currency
            self.noteDetailTableView.reloadData()
        }
    }
    @IBAction func tappedNewButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "InputNewName", bundle: nil)
        let inputNewNameViewController = storyboard.instantiateViewController(identifier: "InputNewNameViewController") as! InputNewNameViewController
        //inputCalcItemViewController.recordViewControllerDelegate = self
        inputNewNameViewController.delegate = self
        inputNewNameViewController.navigationItem.title = "新規ノートの作成"
        let nav = UINavigationController(rootViewController: inputNewNameViewController)
        
        self.present(nav,animated: true, completion: nil)
    }
}

//------------------------------------------------------------------------------
extension NoteDetailViewController: InputNewNameDelegate {
    func addNew(name: String) {
        realm.addNewTable(name, parentNote: note!)
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
        return note?.calcTables.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = noteDetailTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NoteTableViewCell
        cell.table = note?.calcTables[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let itemsCount = note?.calcTables[indexPath.row].calcItems.count ?? 0
        return CGFloat(120 + 64 * itemsCount)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // prepareの処理でindexを使いたいのでselfのindexに一旦保持します。
        currentIndexPath = indexPath
        performSegue(withIdentifier: "openTable", sender: self)
    }
    
    // 遷移前に遷移先Viewにモデルとそのデリゲートをセットします。
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let indexPath = currentIndexPath else { return }
        if segue.identifier == "openTable"{
            let tableDetailVC = segue.destination as! TableDetailViewController
            tableDetailVC.tableId = note?.calcTables[indexPath.row].id ?? ""
            
        }
    }
    
}



