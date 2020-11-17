//
//  TableDetailViewController.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/15.
//

import UIKit
import RealmSwift

class TableDetailViewController: UIViewController {

    let cellId = "cellId"
    var searchController: UISearchController!
    var indicator = UIActivityIndicatorView()
    
    // ドメイン系のプロパティ
    var tableId = "" // 親のノートID {リロードの時にこれを使って note<CalcNote> の値をrealmから取ってくる
    var table: CalcTable?
    private var realm: Realm!
    
    @IBOutlet weak var totalAmountLabel: UILabel!
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
    
    
    @IBAction func tappedNewButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "InputCalcItem", bundle: nil)
        let inputNewNameViewController = storyboard.instantiateViewController(identifier: "InputCalcItemViewController") as! InputCalcItemViewController
        //inputCalcItemViewController.recordViewControllerDelegate = self
        inputNewNameViewController.delegate = self
        inputNewNameViewController.navigationItem.title = "新規項目の作成"
        let nav = UINavigationController(rootViewController: inputNewNameViewController)
        
        self.present(nav,animated: true, completion: nil)
    }
    
}

extension TableDetailViewController: InputCalcItemViewControllerDelegate{
    func inputData(calcItem: CalcItem, inputType: InputType) {
        
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
    
    func reload() {
        table = realm.object(ofType: CalcTable.self, forPrimaryKey: tableId)
        DispatchQueue.main.async {
            self.navigationItem.title = self.table?.tableName
            self.itemsTableView.reloadData()
        }
    }
    
}


extension TableDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return table?.calcItems.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = itemsTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ItemTableViewCell
        cell.calcItemNameLabel.text = table?.calcItems[indexPath.row].name
        cell.quantityLabel.text = table?.calcItems[indexPath.row].quantity.currency
        cell.unitPriceLabel.text = table?.calcItems[indexPath.row].unitPrice.currency
        cell.subTotalLabel.text = table?.calcItems[indexPath.row].subtotal.currency
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
