//
//  ConversionCell.swift
//  Converter
//
//  Created by Roger Molas on 2/26/22.
//

import Foundation
import UIKit
import ActionSheetPicker_3_0

protocol ConversionCellDelegate {
    func didChangeCurrency(cell: ConversionCell, trans:Transaction, code: String)
}

class ConversionCell: UITableViewCell {
    
    @IBOutlet weak var typeIcon: UIButton!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var currencyButton: UIButton!
    
    var delegate:ConversionCellDelegate? = nil
    var transactionType: Transaction = .sell
    
    static func dequeueCell(_ tableView:UITableView, _ indexPath: IndexPath) -> ConversionCell? {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "ConversionCell", for: indexPath) as? ConversionCell else {
            return nil
        }
        return cell
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        typeIcon.layer.cornerRadius = typeIcon.frame.size.height / 2
    }
    
    func set(trans: Transaction) {
        self.transactionType = trans
        self.typeLabel.text = trans.desc
        self.typeIcon.backgroundColor = trans.color
        self.typeIcon.setImage(trans.icon, for: .normal)
        
        let storage = BalanceStorage.shared
        if trans == .sell {
            self.updateButtonState(code: storage.source)
            let balance = storage.getBalance(forKey: storage.source)
            self.amountField.text = "\(balance.toCurrency())"
            self.amountField.isEnabled = true
        }
        
        if trans == .recieve {
            self.updateButtonState(code: storage.destination)
            let conversion = storage.getCoversion(forKey: storage.destination)
            self.amountField.text = "\(conversion.toCurrency())"
            self.amountField.isEnabled = false
        }
    }
    
    private func updateButtonState(code: String) {
        let icon = UIImage(systemName: "chevron.down")!
        currencyButton.setImage(icon, for: .normal)
        currencyButton.setTitle("\(code) ", for: .normal)
    }
    
    @IBAction func didChooseCurrency(sender: UIButton) {
        guard delegate != nil else { return }
        
        let options = Currency.supported
        ActionSheetStringPicker.show(
            withTitle: "Choose Currency", rows: options , initialSelection: 0,
            doneBlock: { picker, value, index in
                let code = "\(index!)"
                self.updateButtonState(code: code)
                self.delegate?.didChangeCurrency(cell: self,
                                                 trans: self.transactionType,
                                                 code: code)
                return
            },
            cancel: { picker in
                return
            },
            origin: sender.superview?.superview)
    }
}
