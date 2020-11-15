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
    @IBOutlet weak var calcItemsStackView: UIStackView!
    
    
    var testItemsCount: Int = 0 {
        didSet{
            loadCalcItems()
        }
    }
    var items = [CalcItemView]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBackgroundView.layer.cornerRadius = 20
        selectionStyle = .none
    }
    
    func loadCalcItems() {
        removeAllItem()
        
        for i in 0..<testItemsCount {
            let view = Bundle.main.loadNibNamed("CalcItemView", owner: self, options: nil)?.first as! CalcItemView
            //view.bounds.size.width = calcItemsStackView.bounds.size.width
            //view.bounds.size.height = 64
            view.calcItemNameLabel.text = "カルビ"
            view.quantityLabel.text = "48" + String(i) + "g"
            view.unitPriceLabel.text = "3円／g"
            view.subTotalLabel.text = "1,440円"
            calcItemsStackView.addArrangedSubview(view)
            items.append(view)
        }

    }
    private func removeAllItem() {
        for i in items {
            i.removeFromSuperview()
        }
    }
}
