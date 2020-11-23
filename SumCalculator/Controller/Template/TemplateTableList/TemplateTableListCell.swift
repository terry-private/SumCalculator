//
//  TemplateTableListCell.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/23.
//

import UIKit

class TemplateTableListCell: UITableViewCell {
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var tableNameLabel: UILabel!
    @IBOutlet weak var calcItemsStackView: UIStackView!
    
    var table: CalcTable? {
        didSet{
            loadCalcItems()
        }
    }
    
    var itemList = [TemplateCalcItemView]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBackgroundView.layer.cornerRadius = 20
        selectionStyle = .none
    }
    
    func loadCalcItems() {
        guard let items = table?.calcItems else { return }
        removeAllItem()
        tableNameLabel.text = table?.tableName
        for i in items {
            let view = Bundle.main.loadNibNamed("TemplateCalcItemView", owner: self, options: nil)?.first as! TemplateCalcItemView
            view.calcItemNameLabel.text = i.name
            
            // unitPrice
            view.unitPriceIntegerPartLabel.text = i.unitPrice.unitPriceRounded.intPartCurrency
            view.unitPriceAfterDotLabel.text = i.unitPrice.unitPriceRounded.afterDot
            if i.unit == "" {
                view.unitPriceUnitLabel.text = ""
            } else {
                view.unitPriceUnitLabel.text = "円／\(i.unit)"
            }
            
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
