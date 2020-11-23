//
//  Date - Extension.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/23.
//

import Foundation

extension TimeZone {
    static let gmt = TimeZone(secondsFromGMT: 0)!
    static let japan = TimeZone(identifier: "Asia/Tokyo")!
}

extension Locale {
    
    static let japan = Locale(identifier: "ja_JP")
}
extension DateFormatter {
    static func current(_ dateFormat: String) -> DateFormatter {
        let df = DateFormatter()
        df.timeZone = TimeZone.gmt
        df.locale = Locale.japan
        df.dateFormat = dateFormat
        return df
    }
}

extension Date {
    init() {
        self = Date(timeIntervalSinceNow: TimeInterval(TimeZone.japan.secondsFromGMT()))
    }
    func longDate() -> String{
        let f = DateFormatter()
        f.locale = .japan
        f.timeZone = TimeZone.gmt
        f.dateStyle = .long
        return f.string(from: self)
    }
}
