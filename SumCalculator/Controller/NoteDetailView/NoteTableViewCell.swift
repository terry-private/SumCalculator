//
//  NoteTableViewCell.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/14.
//

import UIKit

protocol NoteTableViewCellDelegate: AnyObject {
    func changeTableTitle(currentTable: CalcTable)
    func addItem(parentTable: CalcTable)
    func deleteCalcItem(calcItem: CalcItem)
    func deleteCalcTable(calcTable:CalcTable)
}

class NoteTableViewCell: UITableViewCell, Reloadable {
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var subtotalIntLabel: UILabel!
    @IBOutlet weak var calcItemsStackView: UIStackView!
    @IBOutlet weak var subtotalFractionalLabel: UILabel!
    @IBOutlet weak var tableTitleButton: UIButton!
    @IBOutlet weak var deleteButtonWidth: NSLayoutConstraint!
    
    weak var calcItemViewDelegate: CalcItemViewDelegate?
    weak var reloadableDelegate: Reloadable?
    weak var noteTableViewCellDelegate: NoteTableViewCellDelegate?
    
    var calcTable: CalcTable? {
        didSet{
            loadCalcItems()
        }
    }
    var isEditingMode = false {
        didSet {
            for i in itemList {
                i.isEditingMode = isEditingMode
            }
            deleteButtonWidth.constant = isEditingMode ? 94 : 0
//            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {self.layoutIfNeeded()})
            layoutIfNeeded()
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
        guard let items = calcTable?.calcItems else { return }
        removeAllItem()
        tableTitleButton.setTitle(calcTable?.tableName, for: .normal)
        let subtotal = calcTable?.subtotal.totalRounded ?? 0
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
    
    
    @IBAction func tappedTableTitleButton(_ sender: Any) {
        noteTableViewCellDelegate?.changeTableTitle(currentTable: calcTable!) // 強制アンラップ
    }
    @IBAction func tappedAddItemButton(_ sender: Any) {
        noteTableViewCellDelegate?.addItem(parentTable: calcTable!) // 強制アンラップ
    }
    @IBAction func tappedDeleteButton(_ sender: Any) {
        noteTableViewCellDelegate?.deleteCalcTable(calcTable: calcTable!) // 強制アンラップ
    }
    
}

extension NoteTableViewCell: CalcItemViewDelegate {
    func tappedCalcItem(calcItem: CalcItem) {
        calcItemViewDelegate?.tappedCalcItem(calcItem: calcItem)
    }
    func deleteCalcItem(calcItem: CalcItem) {
        noteTableViewCellDelegate?.deleteCalcItem(calcItem: calcItem)
    }
}
