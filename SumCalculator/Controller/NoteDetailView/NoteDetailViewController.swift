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
        
    }
    
    func setupTableView() {
        noteDetailTableView.delegate = self
        noteDetailTableView.dataSource = self
        noteDetailTableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
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



