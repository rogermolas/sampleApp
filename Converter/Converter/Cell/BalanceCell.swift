//
//  BalanceCell.swift
//  Converter
//
//  Created by Roger Molas on 2/26/22.
//

import Foundation
import UIKit

class BalanceCell: UITableViewCell {
    
    static func dequeueCell(_ tableView:UITableView, _ indexPath: IndexPath) -> BalanceCell? {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "BalanceCell", for: indexPath) as? BalanceCell else {
            return nil
        }
        return cell
    }
    
}
