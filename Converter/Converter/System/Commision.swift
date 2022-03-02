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
            return (0.07, 0.04)
        case "USD":
            return (0.08, 0.04)
        case "JPY":
            return (0.5, 0.3)
        default: // other currencies
            return (0.2, 0.2)
        }
    }
}
