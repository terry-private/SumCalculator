//
//  CalcItemView.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/14.
//

import UIKit

class CalcItemView: UIView {
    @IBOutlet weak var calcItemNameLabel: UILabel!
    @IBOutlet weak var unitPriceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var subTotalLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    

}
