//
//  TemplateTableListViewController.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/23.
//

import UIKit
import RealmSwift

class TemplateTableListViewController: UIViewController{
    let cellId = "cellId"
    private var realm: Realm!
    var template: Template?
    var calcTables: List<CalcTable>?
    enum TemplateType {
        case Table
        case Item
    }
    enum Mode {
        case Edit
        case Use
    }
    var templateType: TemplateType = .Table
    var mode: Mode = .Edit
    
    @IBOutlet weak var listTableView: UITableView!
    
    // -------------------------------------------------
    // ライフサイクル
    // -------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        listTableView.dataSource = self
        setupBackButton()
        listTableView.register(UINib(nibName: "TemplateTableListCell", bundle: nil), forCellReuseIdentifier: cellId)
        try! realm = Realm()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
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
    
    // -------------------------------------------------
    // reload
    // -------------------------------------------------
    func reload() {
        let templates = realm.objects(Template.self)
        
        
        if templates.count == 0 {
            template = Template()
            realm.addNewTemplate(template!)
        } else {
            template = templates[0]
        }
        
        switch templateType {
        case .Table:
            calcTables = template!.listTemplates
        case .Item:
            calcTables = template!.itemTemplates
        }
        
        DispatchQueue.main.async {
            self.listTableView.reloadData()
        }
    }
    
    
    @IBAction func tappedNewButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "InputNewName", bundle: nil)
        let inputNewNameViewController = storyboard.instantiateViewController(identifier: "InputNewNameViewController") as! InputNewNameViewController
        //inputCalcItemViewController.recordViewControllerDelegate = self
        inputNewNameViewController.delegate = self
        switch templateType {
        case .Table:
            inputNewNameViewController.navigationItem.title = "リストテンプレート新規作成"
        case .Item:
            inputNewNameViewController.navigationItem.title = "項目テンプレートのフォルダ作成"
        }
        let nav = UINavigationController(rootViewController: inputNewNameViewController)
        
        self.present(nav,animated: true, completion: nil)
    }
}

extension TemplateTableListViewController: InputNewNameDelegate {
    func addNew(name: String) {
        switch templateType {
        case .Table:
            realm.addNewTemplateList(name, template: template!)
        case .Item:
            realm.addNewTemplateItemFolder(name, template: template!)
        }
        
        reload()
    }
    
    func upDate(name: String) {
        
    }
    
}

extension TemplateTableListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calcTables?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let itemsCount = calcTables?[indexPath.row].calcItems.count ?? 0
        return CGFloat(100 + 44 * itemsCount)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TemplateTableListCell
        cell.table = calcTables?[indexPath.row] ?? CalcTable()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "TemplateItemList", bundle: nil)
        let templateItemListViewController = storyboard.instantiateViewController(identifier: "TemplateItemListViewController") as! TemplateItemListViewController
        templateItemListViewController.tableId = calcTables?[indexPath.row].id ?? ""
        let nav = UINavigationController(rootViewController: templateItemListViewController)
        //nav.navigationBar.barTintColor = .cyan
        nav.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label, .font:UIFont(name: "PingFangHK-Thin", size: 18)!]
        nav.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.label, .font:UIFont(name: "PingFangHK-Thin", size: 22)!]
        nav.navigationBar.prefersLargeTitles = true
        nav.modalPresentationStyle = .fullScreen
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(nav,animated: false, completion: nil)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let deleteItem = calcTables?[indexPath.row] else { return }
        realm.deleteTable(calcTable: deleteItem)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
}
