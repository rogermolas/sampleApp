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
        fromAmountLabel.text = "\(self.amountToConvert)"
        fromCurrencyLabel.text = storage.source
        
        // calculate commision
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
        // Fee
        self.fee = round(amountToConvert * percentage)
        fromFeeLabel.text = "\(self.fee)"
        fromFeePercentLabel.text = "\(percentage)%"
        
        var newAmount = 0.00
        // Check if no remaining balance
        // Deduct the commision from amount to be converted
        let remainingAmount = (self.remaining - self.amountToConvert)
        if remainingAmount <= 0 {
             newAmount = self.amountToConvert - self.fee
        } else {
            // Deduct the commision from remaining balance wallet
            newAmount = self.remaining - self.amountToConvert - self.fee
        }
        fromRemainingBalanceLabel.text = "\(newAmount)"
        
        // TO
        let addedBalance = storage.getCoversion(forKey: storage.destination)
        let destinationBalance = storage.getBalance(forKey: storage.destination)
        toAmountLabel.text = "\(addedBalance)"
        toCurrencyLabel.text = storage.destination
        toRemainingBalanceLabel.text = "\(destinationBalance + addedBalance)"
    }
    
    @IBAction func onContinue(sender: UIButton) {
        
        let action: callBack = { [self] in
            self.callBackAction!()
            self.navigationController?.popViewController(animated: true)
        }
        
        // Assuming it was doing a sending API request to server
        let hud = MBProgressHUD.showAdded(to: self.navigationController!.view, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            hud.hide(animated: true)
            
            var newAmount = 0.00
            // Check if no remaining balance
            // Deduct the commision from amount to be converted
            let remainingAmount = (self.remaining - self.amountToConvert)
            if remainingAmount <= 0 {
                newAmount = self.amountToConvert - self.fee
                storage.setBalance(amount: newAmount, forKey: storage.source)
            } else {
                // Deduct the commision from remaining balance wallet
                newAmount = self.remaining - self.amountToConvert - self.fee
                storage.setBalance(amount: newAmount, forKey: storage.source)
            }
            
            // Coverted
            let addedBalance = storage.getCoversion(forKey: storage.destination)
            let remainingBalance = storage.getBalance(forKey: storage.destination)
            let convertedAmount = remainingBalance + addedBalance
            storage.setBalance(amount: convertedAmount, forKey: storage.destination)
            
            let message = "You have converted \(self.amountToConvert) \(storage.source) to \(addedBalance) \(storage.destination). Commission Fee - \(self.fee) \(storage.source)"
            UIAlertController.init(title: "Currency Converted", message: message, onDone: action)
                .show(owner: self, completion: nil)
        }
    }
}
