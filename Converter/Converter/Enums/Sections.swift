//
//  Sections.swift
//  Converter
//
//  Created by Roger Molas on 2/26/22.
//

import Foundation

enum Sections: Int {
    case balances = 0
    case conversion = 1
    
    var rows: Int {
        switch self {
        case .balances:
            return 1
        case .conversion:
            return 2
        }
    }
    
    var header: String {
        switch self {
        case .balances:
            return "MY BALANCES"
        case .conversion:
            return "CURRENCY EXCHANGE"
        }
    }
}
