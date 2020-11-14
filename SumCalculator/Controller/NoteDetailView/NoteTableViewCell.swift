//
//  NoteTableViewCell.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/14.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var tableNameLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var calcItemsTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBackgroundView.layer.cornerRadius = 20
        
    }
}
