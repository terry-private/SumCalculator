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
    var isFirst: Bool { get }
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
            let digit = UserDefaults.standard.object(forKey: "totalCurrencyFractionalDigit") as? Int ?? 2
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
    var isFirst: Bool {
        get {
            let isFirstOpen = UserDefaults.standard.object(forKey: "isFirst") as? Bool ?? true
            if isFirstOpen {
                UserDefaults.standard.set(false, forKey: "isFirst")
            }
            return isFirstOpen
        }
    }
}
