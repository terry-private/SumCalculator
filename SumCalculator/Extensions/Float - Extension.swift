//
//  Float - Extension.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/15.
//

import Foundation

extension Float {
    var currency: String {
        let amountInt = Int(self)
        let afterDot = self - Float(amountInt)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = .current
        var resultString: String = formatter.string(from: NSNumber(value: amountInt)) ?? "0"
        if afterDot != 0 {
            resultString += String(String(afterDot).prefix(4).dropFirst(1))
        }
        return resultString
    }
}
