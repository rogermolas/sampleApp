//
//  Transaction.swift
//  Converter
//
//  Created by Roger Molas on 2/26/22.
//

import Foundation
import UIKit

enum Transaction: Int {
    case sell = 0
    case recieve = 1

    var desc: String {
        switch self {
        case .sell:
            return "Sell"
        case .recieve:
            return "Recieve"
        }
    }
    
    var color: UIColor {
        switch self {
        case .sell:
            return UIColor(named: "sellColor")!
        case .recieve:
            return UIColor(named: "recieveColor")!
        }
    }
    
    var icon: UIImage {
        switch self {
        case .sell:
            return UIImage(systemName: "arrow.up")!
        case .recieve:
            return UIImage(systemName: "arrow.down")!
        }
    }
}
