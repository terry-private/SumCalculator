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
    var calcTables: List<CalcTable> = List<CalcTable>()
    
    @IBOutlet weak var listTableView: UITableView!
    // -------------------------------------------------
    // ライフサイクル
    // -------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        listTableView.dataSource = self
    }
    
}

extension TemplateTableListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NoteTableViewCell
        cell.table = calcTables[indexPath.row]
        return cell
    }
    
    
}
