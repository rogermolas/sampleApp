//
//  ConversionCell.swift
//  Converter
//
//  Created by Roger Molas on 2/26/22.
//

import Foundation
import UIKit
import ActionSheetPicker_3_0
import CurrencyText

protocol ConversionCellDelegate {
    func didChangeCurrency(cell: ConversionCell,
                           trans:Transaction,
                           code: String,
                           amount: String)
    func didEnterInvalidAmount(cell: ConversionCell)
}

class ConversionCell: UITableViewCell {
    
    @IBOutlet weak var typeIcon: UIButton!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var currencyButton: UIButton!
    
    var currentCode: String!
    var delegate:ConversionCellDelegate? = nil
    var transactionType: Transaction = .sell
    var textFieldDelegate: CurrencyUITextFieldDelegate!
    
    let storage = BalanceStorage.shared
    
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
        setupTextFieldWithCurrencyDelegate()
    }
    
    private func setupTextFieldWithCurrencyDelegate() {
        let currencyFormatter = CurrencyFormatter {
            $0.maxValue = 100000000
            $0.hasDecimals = true
            $0.alwaysShowsDecimalSeparator = true
            $0.showCurrencySymbol = false
        }
        
        textFieldDelegate = CurrencyUITextFieldDelegate(formatter: currencyFormatter)
        textFieldDelegate.clearsWhenValueIsZero = true
        textFieldDelegate.passthroughDelegate = self
        amountField.delegate = textFieldDelegate
    }
    
    @objc func valueChange() {
        if transactionType == .sell && amountField.text != "" {
            let storage = BalanceStorage.shared
            let balance = storage.getBalance(forKey: storage.source)
            if amountField.text!.toDouble() > balance {
                let message = "Entered amount should not be greater than your \(storage.source) balance \(balance.toCurrency())"
                UIAlertController(title: "Invalid Amount", message:message, onError: nil)
                    .show(owner: delegate as! UIViewController, completion: nil)
                delegate!.didEnterInvalidAmount(cell: self)
            }
        }
    }
    
    func set(trans: Transaction) {
        self.transactionType = trans
        self.typeLabel.text = trans.desc
        self.typeIcon.backgroundColor = trans.color
        self.typeIcon.setImage(trans.icon, for: .normal)
        
        if trans == .sell {
            self.currentCode = storage.source
            self.updateButtonState(code: storage.source)
            let balance = storage.getToCovert(forKey: storage.source)
            self.amountField.text = "\(balance.toCurrency())"
            self.amountField.isEnabled = true
            
            print("Source : \(balance)")
        }
        
        if trans == .recieve {
            self.currentCode = storage.source
            self.updateButtonState(code: storage.destination)
            let conversion = storage.getCoversion(forKey: storage.destination)
            self.amountField.text = "\(conversion.toCurrency())"
            self.amountField.isEnabled = false
            
            print("Conversion : \(conversion)")
        }
    }
    
    private func updateButtonState(code: String) {
        let icon = UIImage(systemName: "chevron.down")!
        currencyButton.setImage(icon, for: .normal)
        currencyButton.setTitle("\(code) ", for: .normal)
        
        let balance = storage.getBalance(forKey: code)
        amountField.text = balance.toCurrency()
        
    }
    
    @IBAction func didChooseCurrency(sender: UIButton) {
        guard delegate != nil else { return }
        
        self.endEditing(true)
        let options = Currency.supported
        ActionSheetStringPicker.show(
            withTitle: "Choose Currency", rows: options , initialSelection: 0,
            doneBlock: { picker, value, index in
                let code = "\(index!)"
                self.updateButtonState(code: code)
                let amount = self.amountField.text ?? "0.00"
                self.delegate?.didChangeCurrency(cell: self,
                                                 trans: self.transactionType,
                                                 code: code,
                                                 amount: amount)
                return
            },
            cancel: { picker in
                return
            },
            origin: sender.superview?.superview)
    }
}

//MARK: - UITextFieldDelegate
extension ConversionCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn
                   range: NSRange, replacementString string: String) -> Bool {
        valueChange()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let amount = amountField.text ?? "0.00"
        self.delegate?.didChangeCurrency(cell: self,
                                         trans: self.transactionType,
                                         code: currentCode,
                                         amount: amount)
    }
}
