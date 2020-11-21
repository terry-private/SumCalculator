//
//  Double - Extension.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/15.
//

import Foundation

extension Double {
    
    /// 日本円のみの対応とします。
    /// ・小数点以下は第二位までとします。
    /// ・小数点以下の最後の桁が０の場合は消します。
    var currency: String {
        let amountInt = Int(self)
        // マイナスは外しておきます
        let afterDot = abs(self - Double(amountInt))
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ja_JP")
        var resultString: String = formatter.string(from: NSNumber(value: amountInt)) ?? "0"
        if afterDot != 0 {
            // 小数点以下は第二位までとします。
            // "0.14159265..."の場合は前から4文字取得して先頭の0を削除したもの加えて実現しています。
            resultString += String(String(afterDot).prefix(4).dropFirst(1))
            // ・小数点以下の最後の桁が０の場合は消します。
            if resultString.hasSuffix("0") {
                resultString = String(resultString.dropLast(1))
            }
        }
        return resultString + "円"
    }
    
    var quantity: String {
        // マイナスは外しておきます。
        let minus = self < 0
        let absDouble = abs(self)
        
        // 整数パートと少数パートで分けます。
        let integerPart = Int(absDouble)
        let fractionalPart = absDouble - Double(integerPart)
        
        var resultString = String(integerPart)
        
        if fractionalPart != 0 {
            // 小数点以下は第二位までとします。
            // "0.14159265..."の場合は前から4文字取得して先頭の0を削除したもの加えて実現しています。
            resultString += String(String(fractionalPart).prefix(4).dropFirst(1))
            // ・小数点以下の最後の桁が０の場合は消します。
            if resultString.hasSuffix("0") {
                resultString = String(resultString.dropLast(1))
            }
        }
        if minus {
            resultString = "-" + resultString
        }
        return resultString
    }
    
    var string: String {
        // マイナスは外しておきます。
        let minus = self < 0
        let absDouble = abs(self)
        
        // 整数パートと小数パートで分けます。
        let integerPart = Int(absDouble)
        let fractionalPart = absDouble - Double(integerPart)
        
        var resultString = String(integerPart)
        if fractionalPart != 0 {
            // 小数点以下は第二位までとします。
            // "0.14159265..."の場合は前から4文字取得して先頭の0を削除したもの加えて実現しています。
            resultString += String(String(resultString).dropFirst(1))
            // ・小数点以下の最後の桁が０の場合は消します。
            if resultString.hasSuffix("0") {
                resultString = String(resultString.dropLast(1))
            }
        }
        if minus {
            resultString = "-" + resultString
        }
        if resultString.count > 12 {
            resultString = String(resultString.dropLast(1))
        }
        return resultString
    }
}
