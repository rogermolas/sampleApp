//
//  Formatter.swift
//  Converter
//
//  Created by Roger Molas on 2/28/22.
//

import Foundation


extension Double {
    
    func toCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.positiveFormat = "#,##0.00"
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}


extension String {
    
    var currency: String {
        // removing all characters from string before formatting
        let stringWithoutSymbol = self.replacingOccurrences(of: "$", with: "")
        let stringWithoutComma = stringWithoutSymbol.replacingOccurrences(of: ",", with: "")
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.numberStyle = .currency

        if let result = NumberFormatter().number(from: stringWithoutComma) {
            return formatter.string(from: result)!
        }
        return self
    }
    
    func toDouble() -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let number = formatter.number(from: self)
        return number!.doubleValue
    }
}
