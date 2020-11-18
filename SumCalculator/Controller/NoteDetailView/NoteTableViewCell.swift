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
    
    var table: CalcTable? {
        didSet{
            loadCalcItems()
        }
    }
    
    var itemList = [CalcItemView]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBackgroundView.layer.cornerRadius = 20
        selectionStyle = .none
    }
    
    func loadCalcItems() {
        guard let items = table?.calcItems else { return }
        removeAllItem()
        tableNameLabel.text = table?.tableName
        subtotalLabel.text = table?.subtotal.currency
        for i in items {
            let view = Bundle.main.loadNibNamed("CalcItemView", owner: self, options: nil)?.first as! CalcItemView
            view.calcItemNameLabel.text = i.name
            view.quantityLabel.text = String(i.quantity) + i.unit
            if i.unit == "" {
                view.unitPriceLabel.text = i.unitPrice.currency
            } else {
                view.unitPriceLabel.text = i.unitPrice.currency + "／\(i.unit)"
            }
            view.subTotalLabel.text = i.subtotal.currency
            calcItemsStackView.addArrangedSubview(view)
            itemList.append(view)
        }

    }
    private func removeAllItem() {
        for i in itemList {
            i.removeFromSuperview()
        }
    }
}
