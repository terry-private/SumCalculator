//
//  CalcItemView.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/14.
//

import UIKit

class CalcItemView: UIView {
    
    @IBOutlet weak var calcItemNameLabel: UILabel!
    // -------------------------------------------------
    // IBOutlet unitPrice
    // -------------------------------------------------
    @IBOutlet weak var unitPriceIntegerPartLabel: UILabel!
    @IBOutlet weak var unitPriceAfterDotLabel: UILabel!
    @IBOutlet weak var unitPriceUnitLabel: UILabel!
    
    // -------------------------------------------------
    // IBOutlet quantity
    // -------------------------------------------------
    @IBOutlet weak var quantityIntegerPartLabel: UILabel!
    @IBOutlet weak var quantityAfterDotLabel: UILabel!
    @IBOutlet weak var quantityUnitLabel: UILabel!
    
    // -------------------------------------------------
    // IBOutlet subTotal
    // -------------------------------------------------
    @IBOutlet weak var subTotalIntegerPartLabel: UILabel!
    @IBOutlet weak var subTotalAfterDotLabel: UILabel!
    
    // -------------------------------------------------
    // ライフサイクル
    // -------------------------------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    

}
