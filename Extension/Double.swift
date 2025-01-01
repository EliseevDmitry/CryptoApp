//
//  Double.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 20.12.2024.
//

import Foundation

extension Double {
    /*
     Формат создания короткой справки по созданной функции при нажатии на функцию "Option + ?"
     ///Convert a Double into a Currency with 2-6 decimal places
     ///```
     ///Convert 1234,56 to $1,234.56
     ///Convert 12.3456 to $12,3456
     ///Convert 0.123456 to $0.123456
     ///```
     */
    
    ///Convert a Double into a Currency with 2 decimal places
    ///```
    ///Convert 1234,56 to $1,234.56
    ///```
    
    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true //разделяет число на группы цифр 1000000 -> 1,000,000 (для улучшения визуальной составляющей восприятия информации)
        formatter.numberStyle = .currency //будет установлен знак валюты в зависимости от региона
        //Блок кода что бы в текущей локации не отображались RUB
        formatter.locale = .current
        formatter.currencyCode = "usd"
        formatter.currencySymbol = "$"
        //Блок кода что бы в текущей локации не отображались RUB
        formatter.minimumFractionDigits = 2 //min количество знаков после запятой
        formatter.maximumFractionDigits = 2 //max количество знаков после запятой
        return formatter
    }
    
    ///Convert a Double into a Currency as a String with 2 decimal places
    ///```
    ///Convert 12,3456 to "12,34"
    ///```
    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter2.string(from: number) ?? "$0.00"
    }
    
    ///Convert a Double into a Currency with 2-6 decimal places
    ///```
    ///Convert 1234,56 to $1,234.56
    ///Convert 12.3456 to $12,3456
    ///Convert 0.123456 to $0.123456
    ///```
    
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true //разделяет число на группы цифр 1000000 -> 1,000,000 (для улучшения визуальной составляющей восприятия информации)
        formatter.numberStyle = .currency //будет установлен знак валюты в зависимости от региона
        //Блок кода что бы в текущей локации не отображались RUB
        formatter.locale = .current
        formatter.currencyCode = "usd"
        formatter.currencySymbol = "$"
        //Блок кода что бы в текущей локации не отображались RUB
        formatter.minimumFractionDigits = 2 //min количество знаков после запятой
        formatter.maximumFractionDigits = 6 //max количество знаков после запятой
        return formatter
    }
    
    ///Convert a Double into a Currency as a String with 2-6 decimal places
    ///```
    ///Convert 12,3456 to "12,34"
    ///```
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    
    ///Convert a Double into String representation
    ///```
    ///Convert 12,3456 to "12,34"
    ///```
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    ///Convert a Double into String representation with percent symbol
    ///```
    ///Convert 12,3456 to "12,34%"
    ///```
    func asPersentString() -> String {
        return asNumberString() + "%"
    }
    
    /// Convert a Double to a String with K, M, Bn, Tr abbreviations.
    /// ```
    /// Convert 12 to 12.00
    /// Convert 1234 to 1.23K
    /// Convert 123456 to 123.45K
    /// Convert 12345678 to 12.34M
    /// Convert 1234567890 to 1.23Bn
    /// Convert 123456789012 to 123.45Bn
    /// Convert 12345678901234 to 12.34Tr
    /// ```
    func formattedWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""
        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return self.asNumberString()
        default:
            return "\(sign)\(self)"
        }
    }
    
}
