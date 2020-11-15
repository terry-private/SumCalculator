//
//  NoteDetailViewController.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/12.
//

import UIKit

class NoteDetailViewController: UIViewController {
    let cellId = "cellId"
    var searchController: UISearchController!
    var indicator = UIActivityIndicatorView()
    
    var testTableCount = 6

    @IBOutlet weak var noteDetailTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupIndicator()
        setupSearchBar()
        
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

}

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


extension NoteDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = noteDetailTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NoteTableViewCell
        print("cellForRowAt:")
        cell.testItemsCount = testTableCount
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100 + 64 * testTableCount)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
    }
    
}



