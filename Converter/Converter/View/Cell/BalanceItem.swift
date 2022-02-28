//
//  BalanceItem.swift
//  Converter
//
//  Created by Roger Molas on 2/28/22.
//

import Foundation
import UIKit

class BalanceItem: UIView {
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    class func instantiate(owner: BalanceCell) -> BalanceItem {
        let views = Bundle.main.loadNibNamed("BalanceItem", owner: owner, options: nil)
        return views?.first as! BalanceItem
    }
}
