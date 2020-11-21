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
    var currentIndex = 0
    
    // ドメイン系のプロパティ
    var tableId = "" // 親のノートID {リロードの時にこれを使って note<CalcNote> の値をrealmから取ってくる
    var calcTable: CalcTable?
    private var realm: Realm!
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var itemsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func reload() {
        calcTable = realm.object(ofType: CalcTable.self, forPrimaryKey: tableId)
        DispatchQueue.main.async {
            self.navigationItem.title = self.calcTable?.tableName
            self.itemsTableView.reloadData()
            self.totalAmountLabel.text = self.calcTable?.subtotal.currency ?? "¥0"
        }
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
        if inputType == .AddNew {
            realm.addNewItem(calcItem, parentTable: calcTable!) // 強制アンラップ使ってます。
        } else {
            realm.updateItem(calcTable!.calcItems[currentIndex], after: calcItem) // 強制アンラップ使ってます。
        }
        reload()
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
        return calcTable?.calcItems.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = itemsTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ItemTableViewCell
        let item = calcTable?.calcItems[indexPath.row]
        let unit = item?.unit ?? ""
        cell.calcItemNameLabel.text = item?.name
        cell.quantityLabel.text = (item?.quantity ?? 0).quantity + unit
        if unit == "" {
            cell.unitPriceLabel.text = item?.unitPrice.currency
        } else {
            cell.unitPriceLabel.text = (item?.unitPrice ?? 0).currency + "／\(unit)"
        }
        cell.subTotalLabel.text = item?.subtotal.currency
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "InputCalcItem", bundle: nil)
        let inputCalcItemViewController = storyboard.instantiateViewController(identifier: "InputCalcItemViewController") as! InputCalcItemViewController
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

class ItemTableViewCell: UITableViewCell {
    @IBOutlet weak var calcItemNameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var unitPriceLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
