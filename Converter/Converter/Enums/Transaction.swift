//
//  Transaction.swift
//  Converter
//
//  Created by Roger Molas on 2/26/22.
//

import Foundation

enum Transaction: String {
    case sell = "sell"
    case recieve = "recieve"

    var getType: String {
        switch self {
        case .sell:
            return "Sell"
        case .recieve:
            return "Recieve"
        }
    }
}
