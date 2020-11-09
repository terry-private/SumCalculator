//
//  NoteListViewController.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/09.
//

import UIKit

class NoteListViewController: UIViewController {
    
    var searchController: UISearchController!
    var indicator = UIActivityIndicatorView()
    
    @IBOutlet weak var noteListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupIndicator()

        // Do any additional setup after loading the view.
    }
    func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "計算ノートを検索します。"
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
