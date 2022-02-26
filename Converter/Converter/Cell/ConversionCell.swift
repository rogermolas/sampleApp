//
//  ConversionCell.swift
//  Converter
//
//  Created by Roger Molas on 2/26/22.
//

import Foundation
import UIKit


class ConversionCell: UITableViewCell {
    
    @IBOutlet weak var typeButton: UIButton!
    
    static func dequeueCell(_ tableView:UITableView, _ indexPath: IndexPath) -> ConversionCell? {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "ConversionCell", for: indexPath) as? ConversionCell else {
            return nil
        }
        return cell
    }
}
