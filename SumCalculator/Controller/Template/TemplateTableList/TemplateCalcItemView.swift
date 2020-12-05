//
//  TemplateCalcItemView.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/23.
//

import UIKit

class TemplateCalcItemView: UIView {
    
    @IBOutlet weak var calcItemNameLabel: UILabel!
    // -------------------------------------------------
    // IBOutlet unitPrice
    // -------------------------------------------------
    @IBOutlet weak var unitPriceIntegerPartLabel: UILabel!
    @IBOutlet weak var unitPriceAfterDotLabel: UILabel!
    @IBOutlet weak var unitPriceUnitLabel: UILabel!

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
