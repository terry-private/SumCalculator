//
//  NoteListViewController.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/09.
//

import UIKit
import RealmSwift

class NoteListViewController: UIViewController {
    let cellId = "cellId"
    var searchController: UISearchController!
    var indicator = UIActivityIndicatorView()
    var currentIndexPath: IndexPath?
    
    var calcNotes: Results<CalcNote>?
    private var realm: Realm!
    
    @IBOutlet weak var noteListTableView: UITableView!
    
    // -------------------------------------------------
    // ライフサイクル
    // -------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // 各パーツのセットアップ
        setupTableView()
        setupSearchBar()
        setupIndicator()
        //データベースの準備
        realm = try! Realm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    // -------------------------------------------------
    // setup系
    // -------------------------------------------------
    func setupTableView() {
        noteListTableView.delegate = self
        noteListTableView.dataSource = self
    }
    func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "ノートを検索します。"
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
        calcNotes = realm.objects(CalcNote.self)
        DispatchQueue.main.async {
            self.noteListTableView.reloadData()
        }
    }
    
    // -------------------------------------------------
    // IBAction　遷移系
    // -------------------------------------------------
    @IBAction func tappedNewButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "InputNewName", bundle: nil)
        let inputNewNameViewController = storyboard.instantiateViewController(identifier: "InputNewNameViewController") as! InputNewNameViewController
        //inputCalcItemViewController.recordViewControllerDelegate = self
        inputNewNameViewController.delegate = self
        inputNewNameViewController.navigationItem.title = "新規ノートの作成"
        let nav = UINavigationController(rootViewController: inputNewNameViewController)
        
        self.present(nav,animated: true, completion: nil)
    }
    @IBAction func tappedTemplateEditButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "TemplateSelect", bundle: nil)
        let inputNewNameViewController = storyboard.instantiateViewController(identifier: "TemplateSelectViewController") as! TemplateSelectViewController
        //inputCalcItemViewController.recordViewControllerDelegate = self
        let nav = UINavigationController(rootViewController: inputNewNameViewController)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav,animated: true, completion: nil)
    }
    

}

//------------------------------------------------------------------------------
extension NoteListViewController: InputNewNameDelegate {
    func upDate(name: String) {
    }
    
    func addNew(name: String) {
        realm.addNewNote(name)
        reload()
    }
}

//------------------------------------------------------------------------------
// UISearchBarDelegateのロジック周りをextensionとして分けます。
extension NoteListViewController: UISearchResultsUpdating, UISearchBarDelegate {
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
// UITableViewDelegate, UITableViewDataSourceのロジック周りをextensionとして分けます。
extension NoteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calcNotes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = noteListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NoteListTableViewCell
        cell.noteNameLabel.text = calcNotes?[indexPath.row].noteName ?? ""
        cell.latestEditedTimeLabel.text = calcNotes?[indexPath.row].latestEditedAt?.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // prepareの処理でindexを使いたいのでselfのindexに一旦保持します。
        currentIndexPath = indexPath
        performSegue(withIdentifier: "openNote", sender: self)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let deleteItem = calcNotes?[indexPath.row] else { return }
        realm.deleteNote(calcNote: deleteItem)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // 遷移前に遷移先Viewにモデルとそのデリゲートをセットします。
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let indexPath = currentIndexPath else { return }
        if segue.identifier == "openNote"{
            let noteDetailVC = segue.destination as! NoteDetailViewController
            noteDetailVC.noteId = calcNotes?[indexPath.row].id ?? ""
            
        }
    }

}



class NoteListTableViewCell: UITableViewCell {
    @IBOutlet weak var noteNameLabel: UILabel!
    @IBOutlet weak var latestEditedTimeLabel: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
