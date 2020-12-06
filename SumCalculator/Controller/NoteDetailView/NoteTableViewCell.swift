//
//  NoteTableViewCell.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/14.
//

import UIKit

class NoteTableViewCell: UITableViewCell, Reloadable {
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var subtotalIntLabel: UILabel!
    @IBOutlet weak var calcItemsStackView: UIStackView!
    @IBOutlet weak var subtotalFractionalLabel: UILabel!
    @IBOutlet weak var tableNameButton: UIButton!
    
    weak var delegate: CalcItemViewDelegate?
    weak var reloadableDelegate: Reloadable?
    
    var table: CalcTable? {
        didSet{
            loadCalcItems()
        }
    }
    
    var itemList = [CalcItemView]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBackgroundView.layer.cornerRadius = 10
        selectionStyle = .none
    }
    func reload() {
        reloadableDelegate?.reload()
    }
    func loadCalcItems() {
        guard let items = table?.calcItems else { return }
        removeAllItem()
        tableNameButton.setTitle(table?.tableName, for: .normal)
        let subtotal = table?.subtotal.totalRounded ?? 0
        subtotalIntLabel.text = subtotal.intPartCurrency
        subtotalFractionalLabel.text = subtotal.afterDot
        for i in items {
            let view = Bundle.main.loadNibNamed("CalcItemView", owner: self, options: nil)?.first as! CalcItemView
            view.calcItemNameLabel.text = i.name
            
            // unitPrice
            view.unitPriceIntegerPartLabel.text = i.unitPrice.unitPriceRounded.intPartCurrency
            view.unitPriceAfterDotLabel.text = i.unitPrice.unitPriceRounded.afterDot
            if i.unit == "" {
                view.unitPriceUnitLabel.text = ""
            } else {
                view.unitPriceUnitLabel.text = "円／\(i.unit)"
            }
            
            // quantity
            view.quantityIntegerPartLabel.text = i.quantity.quantityRounded.intPartCurrency
            view.quantityAfterDotLabel.text = i.quantity.quantityRounded.afterDot
            view.quantityUnitLabel.text = i.unit
            
            // subTotal
            view.subTotalIntegerPartLabel.text = i.subtotal.totalRounded.intPartCurrency
            view.subTotalAfterDotLabel.text = i.subtotal.totalRounded.afterDot
            

            view.calcItem = i
            view.delegate = self
            view.reloadableDelegate = self
            view.setTarget()
            
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

extension NoteTableViewCell: CalcItemViewDelegate {
    func tappedCalcItem(calcItem: CalcItem) {
        delegate?.tappedCalcItem(calcItem: calcItem)
    }
    
}
