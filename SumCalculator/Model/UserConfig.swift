//
//  UserConfig.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/22.
//

import Foundation

protocol Config {
    var quantityFractionalDigit: Int { get set }
    var totalCurrencyFractionalDigit: Int { get set }
    var unitCurrencyFractionalDigit: Int { get set }
}

class UserConfig: Config {
    var quantityFractionalDigit: Int {
        get {
            let digit = UserDefaults.standard.object(forKey: "quantityFractionalDigit") as? Int ?? 2
            return digit
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "quantityFractionalDigit")
        }
    }
    var totalCurrencyFractionalDigit: Int {
        get {
            let digit = UserDefaults.standard.object(forKey: "totalCurrencyFractionalDigit") as? Int ?? 0
            return digit
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "totalCurrencyFractionalDigit")
        }
    }
    var unitCurrencyFractionalDigit: Int {
        get {
            let digit = UserDefaults.standard.object(forKey: "unitCurrencyFractionalDigit") as? Int ?? 2
            return digit
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "unitCurrencyFractionalDigit")
        }
    }
}
