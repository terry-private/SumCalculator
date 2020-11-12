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

    @IBOutlet weak var noteDetailTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func setupTableView() {
        noteDetailTableView.delegate = self
        noteDetailTableView.dataSource = self
    }

}


extension NoteDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = noteDetailTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NoteDetailTableViewCell
        return cell
    }
    
    
}


class NoteDetailTableViewCell: UITableViewCell {
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
