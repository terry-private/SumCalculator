//
//  TableDetailViewController.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/15.
//

import UIKit

class TableDetailViewController: UIViewController {

    let cellId = "cellId"
    var searchController: UISearchController!
    var indicator = UIActivityIndicatorView()
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    var testTableCount = 6

    @IBOutlet weak var itemsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupIndicator()
        setupSearchBar()
        totalAmountLabel.text = "123,456円"
    }
    
    func setupTableView() {
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
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
extension TableDetailViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
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


extension TableDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = itemsTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ItemTableViewCell
        print("cellForRowAt:")
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        let storyboard = UIStoryboard(name: "InputCalcItem", bundle: nil)
        let inputCalcItemViewController = storyboard.instantiateViewController(identifier: "InputCalcItemViewController") as! InputCalcItemViewController
        //inputCalcItemViewController.recordViewControllerDelegate = self
        
        let nav = UINavigationController(rootViewController: inputCalcItemViewController)
        
        self.present(nav,animated: true, completion: nil)
    }
    
}

class ItemTableViewCell: UITableViewCell {
    @IBOutlet weak var calcItemNameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var unitPriceLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
