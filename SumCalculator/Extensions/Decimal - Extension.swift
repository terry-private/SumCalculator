//
//  Decimal - Extension.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/22.
//

import Foundation

extension Decimal {
    /// 整数部分を取り出してIntを返します。
    var integerPart: Int {
        let str = self.description
        let index = str.firstIndex(of: ".") ?? str.endIndex
        let result = str[..<index]
        return Int(result) ?? 0
    }
    /// 小数部分を取り出してDecimalで返します。
    var fractionalPart: Decimal {
        let intNum = Decimal(self.integerPart)
        return self - intNum
    }
    
    /// 日本円の形式でString型を返します。
    var currency: String {
        // マイナスは外しておきます。
        let absDecimalNum = abs(self)
        // 整数部分と小数部分で分けておきます。
        let int = absDecimalNum.integerPart // Int
        let fraction = absDecimalNum.fractionalPart // Decimal
        
        // 整数部分を000毎のカンマ区切りの文字列に変換
        var resultString: String = currencyFromInt(int: int)
        
        // 小数点以下がある場合
        if fraction != 0 {
            // 先頭の0を削除した文字列を加えて実現しています。
            resultString += String(fraction.description.dropFirst(1))
        }
        
        // マイナスの記号
        if self < 0 { resultString = "-" + resultString }
        
        return resultString
    }
    
    /// 整数部分を000毎のカンマ区切りの文字列に変換
    func currencyFromInt(int: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: NSNumber(value: int)) ?? "0"
    }
    
    /// 四捨五入
    /// - Parameter _scale: 桁数
    /// - Returns: 丸めた結果失敗するとDecimal()が返ります
    func rounded(_ _scale: Int) -> Decimal {
        let scale = Int16(_scale)
        let r0:NSDecimalNumber = NSDecimalNumber(string: self.description)
         
        let behaviors:NSDecimalNumberHandler = NSDecimalNumberHandler(
            roundingMode: NSDecimalNumber.RoundingMode.plain,
            scale: scale,
            raiseOnExactness: false,
            raiseOnOverflow: false,
            raiseOnUnderflow: false,
            raiseOnDivideByZero: false)
         
        let r1:NSDecimalNumber = r0.rounding(accordingToBehavior: behaviors)
        return Decimal(string: r1.stringValue) ?? Decimal()
    }
    
    /// 切り捨て
    /// - Parameter scale: 桁数
    /// - Returns: Decimalで返します
    func roundDown(_ scale: Int) -> Decimal {
        let digit = scale
        let digit10 = Decimal(pow(10, Double(digit)))
        return Decimal((self * digit10).integerPart) / digit10
    }
    
    /// 整数部分を000毎のカンマ区切りの文字列に変換
    var intPartCurrency: String {
        return currencyFromInt(int: self.integerPart)
    }
    
    /// 小数点以下をStringで（合計値用）
    var afterDot: String {
        let fraction = abs(self.fractionalPart)
        if fraction == 0 {
            return ""
        } else {
            return String(fraction.description.dropFirst(1))
        }
    }
    
    // -------------------------------------------------
    // total用
    // -------------------------------------------------
    /// totalDigit指定の桁で四捨五入します。
    var totalRounded: Decimal {
        let digit = UserConfig().totalCurrencyFractionalDigit
        return rounded(digit)
    }
    var totalCurrencyWithMyDigit: String {
        return totalRounded.currency
    }

    // -------------------------------------------------
    // unitPrice用
    // -------------------------------------------------
    var unitPriceRounded: Decimal {
        return roundDown(UserConfig().unitCurrencyFractionalDigit)
    }
    var unitCurrencyWithMyDigit: String {
        let digit = UserConfig().unitCurrencyFractionalDigit
        let digit10 = Decimal(pow(10, Double(digit)))
        let myDecimal = Decimal((self * digit10).integerPart) / digit10
        return myDecimal.currency
    }
    
    // -------------------------------------------------
    // quantity用
    // -------------------------------------------------
    var quantityRounded: Decimal {
        return roundDown(UserConfig().quantityFractionalDigit)
    }
    
    var quantityWithMyDigit: String {
        let digit = UserConfig().quantityFractionalDigit
        let digit10 = Decimal(pow(10, Double(digit)))
        let myDecimal = Decimal((self * digit10).integerPart) / digit10
        
        return myDecimal.description
    }
}
