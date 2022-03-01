//
//  BalanceCell.swift
//  Converter
//
//  Created by Roger Molas on 2/26/22.
//

import Foundation
import UIKit

class BalanceCell: UITableViewCell {
    
    var scrollView: UIScrollView? = nil
    
    static func dequeueCell(_ tableView:UITableView, _ indexPath: IndexPath) -> BalanceCell? {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "BalanceCell", for: indexPath) as? BalanceCell else {
            return nil
        }
        cell.layoutCell()
        return cell
    }
    
    func layoutCell() {
        // Clean up
        if scrollView != nil {
            scrollView?.removeFromSuperview()
        }
        
        scrollView = UIScrollView(frame: self.contentView.bounds)
        self.addSubview(scrollView!)
        let itemWidth = 150.0
        
        let currencies = Currency.supported
        currencies.enumerated().forEach { (index, element) in
            
            let item = BalanceItem.instantiate(owner: self)
            let origin_x = itemWidth * CGFloat(index)
            let frame = CGRect(x: origin_x, y: 0, width: itemWidth, height: scrollView!.bounds.size.height)
            
            item.frame = frame
            
            let balance = BalanceStorage.shared.getBalance(forKey: element)
            item.amountLabel.text = "\(balance.toCurrency())"
            item.codeLabel.text = element
           
            scrollView!.addSubview(item)
            scrollView!.sizeToFit()
            scrollView!.contentSize.width = frame.width * CGFloat(index + 1)
        }
    }
}
