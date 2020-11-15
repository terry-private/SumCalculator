//
//  NoteListViewController.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/09.
//

import UIKit

class NoteListViewController: UIViewController {
    let cellId = "cellId"
    var searchController: UISearchController!
    var indicator = UIActivityIndicatorView()
    var currentIndexPath: IndexPath?
    
    @IBOutlet weak var noteListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
        setupIndicator()
    }
    
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
    
    @IBAction func tappedPlusButton(_ sender: Any) {
        
    }

}


/// UISearchBarDelegateのロジック周りをextensionとして分けます。
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


extension NoteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = noteListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NoteListTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // prepareの処理でindexを使いたいのでselfのindexに一旦保持します。
        currentIndexPath = indexPath
        performSegue(withIdentifier: "openNote", sender: self)
    }
    
    // 遷移前に遷移先Viewにモデルとそのデリゲートをセットします。
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let indexPath = currentIndexPath else { return }
        if segue.identifier == "openNote"{
            let noteDetailVC = segue.destination as! NoteDetailViewController
            let cell = noteListTableView.cellForRow(at: indexPath) as? NoteListTableViewCell
            let name = cell?.noteNameLabel.text
            noteDetailVC.navigationItem.title = name
            print(indexPath)
            
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
