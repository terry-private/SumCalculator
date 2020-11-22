//
//  Decimal - Extension.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/22.
//

import Foundation

extension Decimal {
    var integerPart: Int {
        let num = NSDecimalNumber(decimal: self)
        return Int(truncating: num)
    }
    var fractionalPart: Decimal {
        let intNum = Decimal(self.integerPart)
        return self - intNum
    }
    var currency: String {
        // マイナスは外しておきます。
        let absDecimalNum = abs(self)
        // 整数部分と小数部分で分けておきます。
        let int = absDecimalNum.integerPart // Int
        let fraction = absDecimalNum.fractionalPart // Decimal
        
        // 整数部分を000毎のカンマ区切りの文字列に変換
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ja_JP")
        var resultString: String = formatter.string(from: NSNumber(value: int)) ?? "0"
        
        // 小数点以下がある場合
        if fraction != 0 {
            // 先頭の0を削除した文字列を加えて実現しています。
            resultString += String(fraction.description.dropFirst(1))
        }
        
        // マイナスの記号
        if self < 0 { resultString = "-" + resultString }
        
        return resultString + "円"
    }
    
    var totalCurrencyWithMyDigit: String {
        let digit = UserConfig().totalCurrencyFractionalDigit
        let digit10 = Decimal(pow(10, Double(digit)))
        let myDecimal = Decimal((self * digit10).integerPart) / digit10
        return myDecimal.currency
    }
    var unitCurrencyWithMyDigit: String {
        let digit = UserConfig().unitCurrencyFractionalDigit
        let digit10 = Decimal(pow(10, Double(digit)))
        let myDecimal = Decimal((self * digit10).integerPart) / digit10
        return myDecimal.currency
    }
    
    var quantityWithMyDigit: String {
        let digit = UserConfig().quantityFractionalDigit
        let digit10 = Decimal(pow(10, Double(digit)))
        let myDecimal = Decimal((self * digit10).integerPart) / digit10
        return myDecimal.description
    }
}
