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
