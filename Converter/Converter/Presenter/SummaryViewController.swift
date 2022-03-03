//
//  SummaryViewController.swift
//  Converter
//
//  Created by Roger Molas on 3/3/22.
//

import Foundation
import UIKit
import MBProgressHUD

class SummaryViewController: UIViewController {
    // FROM
    @IBOutlet weak var fromAmountLabel: UILabel!
    @IBOutlet weak var fromCurrencyLabel: UILabel!
    @IBOutlet weak var fromFeeLabel: UILabel!
    @IBOutlet weak var fromFeePercentLabel: UILabel!
    @IBOutlet weak var fromRemainingBalanceLabel: UILabel!
    
    // TO
    @IBOutlet weak var toAmountLabel: UILabel!
    @IBOutlet weak var toCurrencyLabel: UILabel!
    @IBOutlet weak var toRemainingBalanceLabel: UILabel!
    
    let storage = BalanceStorage.shared
    let amountToConvert = BalanceStorage.shared.getToCovert(forKey: BalanceStorage.shared.source)
    let remaining = BalanceStorage.shared.getBalance(forKey: BalanceStorage.shared.source)
    var fee = 0.00
    
    var callBackAction:(()->Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Summary"
        
        //FROM
        fromAmountLabel.text = self.amountToConvert.toCurrency()
        fromCurrencyLabel.text = storage.source
        
        // Fee
        // Fee if deducted to amount to be converted
        let percentage = getPercentage(amount: self.amountToConvert)
        self.fee = round(self.amountToConvert * percentage).round(to: 2)
        fromFeeLabel.text = "\(self.fee)"
        fromFeePercentLabel.text = "\(percentage)%"
        
        var newAmount = 0.00
        // Check if no remaining balance
        // Deduct the commision from amount to be converted
        let remainingAmount = (self.remaining - self.amountToConvert)
        if remainingAmount <= 0 {
            newAmount = self.amountToConvert - self.fee
            fromAmountLabel.text = newAmount.toCurrency()
            fromRemainingBalanceLabel.text = remainingAmount.toCurrency()
        } else {
            newAmount = self.remaining - self.amountToConvert - self.fee
            // check if the commision can be deducted
            if newAmount <= self.fee {
                // otherwise deduct the amount in amount that to be converted
                newAmount = self.amountToConvert - self.fee
                fromAmountLabel.text = newAmount.toCurrency()
                fromRemainingBalanceLabel.text = remainingAmount.toCurrency()
            } else {
                // Deduct the commision from remaining balance wallet
                // Fee if deducted to remaining balance
                let percentage = getPercentage(amount: self.remaining)
                self.fee = round(self.remaining * percentage).round(to: 2)
                newAmount = self.remaining - self.amountToConvert - self.fee
                fromRemainingBalanceLabel.text = newAmount.toCurrency()
            }
        }
        
        // TO
        let addedBalance = storage.getCoversion(forKey: storage.destination)
        let destinationBalance = storage.getBalance(forKey: storage.destination)
        toAmountLabel.text = addedBalance.toCurrency()
        toCurrencyLabel.text = storage.destination
        let destinationTotal = destinationBalance + addedBalance
        toRemainingBalanceLabel.text = destinationTotal.toCurrency()
    }
    
    @IBAction func onContinue(sender: UIButton) {
        
        let action: callBack = { [self] in
            storage.setToCovert(amount: 0.00, forKey: storage.source)
            storage.setCoversion(amount: 0.00, forKey: storage.destination)
            
            self.callBackAction!()
            self.navigationController?.popViewController(animated: true)
        }
        
        // Assuming it was doing a sending API request to server
        let hud = MBProgressHUD.showAdded(to: self.navigationController!.view, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            hud.hide(animated: true)
            
            // Fee if deducted to amount to be converted
            let percentage = getPercentage(amount: self.amountToConvert)
            self.fee = round(self.amountToConvert * percentage).round(to: 2)
            
            var newAmount = 0.00
            // Check if no remaining balance
            // Deduct the commision from amount to be converted
            let remainingAmount = (self.remaining - self.amountToConvert)
            if remainingAmount <= 0 {
                storage.setBalance(amount: remainingAmount, forKey: storage.source)
            } else {
                // Deduct the commision from remaining balance wallet
                newAmount = self.remaining - self.amountToConvert - self.fee
                // check if the commision can be deducted
                if newAmount < self.fee {
                    // otherwise deduct the amount in amount that to be converted
                    storage.setBalance(amount: remainingAmount, forKey: storage.source)
                } else {
                    // Fee if deducted to remaining balance
                    let percentage = getPercentage(amount: self.remaining)
                    self.fee = round(self.remaining * percentage).round(to: 2)
                    newAmount = self.remaining - self.amountToConvert - self.fee
                    storage.setBalance(amount: newAmount, forKey: storage.source)
                }
            }
            
            // Coverted
            let convertedAmount = storage.getCoversion(forKey: storage.destination)
            let remainingBalance = storage.getBalance(forKey: storage.destination)
            let newBalance = remainingBalance + convertedAmount
            storage.setBalance(amount: newBalance, forKey: storage.destination)
            
            let message = "You have converted \(self.amountToConvert.toCurrency()) \(storage.source) to \(convertedAmount.toCurrency()) \(storage.destination). Commission Fee - \(self.fee) \(storage.source)"
            UIAlertController.init(title: "Currency Converted", message: message, onDone: action)
                .show(owner: self, completion: nil)
        }
    }
    
    // calculate commision
    func getPercentage(amount: Double) -> Double {
        let commision = Commision(currency: storage.source)
        var percentage = 0.00
        if self.amountToConvert <= 100.00 {
            // stage 1 comission fee
            percentage = commision.pecentage.0
        } else if (self.amountToConvert > 100.00 && self.amountToConvert <= 1000.00) {
            // stage 2 comission fee
            percentage = commision.pecentage.1
        } else  {
            // free for 1000 up
        }
        return percentage
    }
}
