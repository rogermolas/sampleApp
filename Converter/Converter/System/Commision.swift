//
//  Commision.swift
//  Converter
//
//  Created by Roger Molas on 3/2/22.
//

import Foundation
import SwiftUI

struct Commision {
    
    var currency: String
    
    var pecentage: (Double, Double) {
        switch currency {
        case "EUR":
            return (0.3, 0.2)
        case "USD":
            return (0.2, 0.09)
        case "JPY":
            return (0.5, 0.3)
        default: // other currencies
            return (0.2, 0.2)
        }
    }
}

// Helpher
func getFee(amount: Double, source: String) -> Double {
    let commision = Commision(currency: source)
    var percentage = 0.00
    if amount <= 100.00 {
        // stage 1 comission fee
        percentage = commision.pecentage.0
    } else if (amount > 100.00 && amount <= 1000.00) {
        // stage 2 comission fee
        percentage = commision.pecentage.1
    } else  {
        // free for 1000 up
    }
    return Double(amount * percentage).round(to: 2)
}
