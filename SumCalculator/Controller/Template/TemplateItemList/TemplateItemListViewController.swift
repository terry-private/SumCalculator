//
//  TemplateItemListViewController.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/23.
//

import UIKit
import RealmSwift

class TemplateItemListViewController: UIViewController {
    let cellId = "cellId"
    // ドメイン系のプロパティ
    var tableId = "" // 親のノートID {リロードの時にこれを使って note<CalcNote> の値をrealmから取ってくる
    var calcTable: CalcTable?
    var currentIndex = 0
    private var realm: Realm!
    
    @IBOutlet weak var itemListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBackButton()
        try! realm = Realm()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    func setupTableView() {
        itemListTableView.delegate = self
        itemListTableView.dataSource = self
        //itemListTableView.register(UINib(nibName: "TemplateItemListTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
    }
    func setupBackButton() {
        let backBarButtonItem = UIBarButtonItem(title: "戻る", style: .plain, target: self, action: #selector(tappedBackButton))
        backBarButtonItem.tintColor = .white
        //backBarButtonItem.setTitleTextAttributes([.font: UIFont(name: "PingFangHK-Thin", size: 17)!], for: .normal)
        navigationItem.setLeftBarButton(backBarButtonItem, animated: true)
    }
    
    @objc private func tappedBackButton() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    
    func reload() {
        calcTable = realm.object(ofType: CalcTable.self, forPrimaryKey: tableId)
        DispatchQueue.main.async {
            self.navigationItem.title = self.calcTable?.tableName
            self.itemListTableView.reloadData()
        }
    }
    
    @IBAction func tappedNewButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "InputCalcItem", bundle: nil)
        let inputCalcItemViewController = storyboard.instantiateViewController(identifier: "InputCalcItemViewController") as! InputCalcItemViewController
        //inputCalcItemViewController.recordViewControllerDelegate = self
        inputCalcItemViewController.delegate = self
        inputCalcItemViewController.navigationItem.title = "新規項目の作成"
        inputCalcItemViewController.isTemplate = true
        let nav = UINavigationController(rootViewController: inputCalcItemViewController)
        
        self.present(nav,animated: true, completion: nil)
    }

}

extension TemplateItemListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calcTable?.calcItems.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = itemListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TemplateItemListTableViewCell
        let item = calcTable?.calcItems[indexPath.row]
        let unit = item?.unit ?? ""

        cell.calcItemNameLabel.text = item?.name
        
        // unitPrice
        cell.unitPriceIntegerPartLabel.text = item?.unitPrice.unitPriceRounded.intPartCurrency
        cell.unitPriceAfterDotLabel.text = item?.unitPrice.unitPriceRounded.afterDot
        if unit == "" {
            cell.unitPriceUnitLabel.text = ""
        } else {
            cell.unitPriceUnitLabel.text = "円／\(unit)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "InputCalcItem", bundle: nil)
        let inputCalcItemViewController = storyboard.instantiateViewController(identifier: "InputCalcItemViewController") as! InputCalcItemViewController
        inputCalcItemViewController.isTemplate = true
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

extension TemplateItemListViewController: InputCalcItemViewControllerDelegate {
    func inputData(calcItem: CalcItem, inputType: InputType) {
        if inputType == .AddNew {
            realm.addNewItem(calcItem, parentTable: calcTable!) // 強制アンラップ使ってます。
        } else {
            realm.updateItem(calcTable!.calcItems[currentIndex], after: calcItem) // 強制アンラップ使ってます。
        }
        reload()
    }
}


class TemplateItemListTableViewCell: UITableViewCell {
    @IBOutlet weak var calcItemNameLabel: UILabel!
    @IBOutlet weak var unitPriceIntegerPartLabel: UILabel!
    @IBOutlet weak var unitPriceAfterDotLabel: UILabel!
    @IBOutlet weak var unitPriceUnitLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
