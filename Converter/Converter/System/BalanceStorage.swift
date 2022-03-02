//
//  BalanceStorage.swift
//  Converter
//
//  Created by Roger Molas on 2/28/22.
//

import Foundation

class BalanceStorage {
    static let shared = BalanceStorage()
    private var defaults = UserDefaults.standard
    
    struct Keys {
        static let source = "result.conversion.source"
        static var source_amount = "result.conversion.source.amount"
        static var destination_amount = "result.conversion.destination.amount"
        static let destination = "result.conversion.destination"
    }
    
    //Main Wallet
    func getBalance(forKey: String) -> Double {
        let balance = self.defaults.double(forKey: forKey)
        
        if forKey == "EUR" && balance == 0.0 {
            if self.defaults.value(forKey: forKey) == nil {
                return 100.0 // default to 100
            }
        }
        return balance
    }
    
    // Call on submit
    func setBalance(amount:Double, forKey: String) {
        self.defaults.set(amount, forKey: forKey)
    }
    
    func getToCovert(forKey: String) -> Double {
        let amountKey = "\(Keys.source_amount).\(forKey)"
        return self.defaults.double(forKey: amountKey)
    }
    
    func setToCovert(amount:Double, forKey: String) {
        let amountKey = "\(Keys.source_amount).\(forKey)"
        self.defaults.set(amount, forKey: amountKey)
    }
    
    // API conversion results
    func getCoversion(forKey: String) -> Double {
        let amountKey = "\(Keys.destination_amount).\(forKey)"
        return self.defaults.double(forKey: amountKey)
    }
    
    func setCoversion(amount:Double, forKey: String) {
        let amountKey = "\(Keys.destination_amount).\(forKey)"
        self.defaults.set(amount, forKey: amountKey)
    }

    var source: String {
        get {
            let source = self.defaults.string(forKey: Keys.source)
            if source != nil {
                return source!
            }
            return "EUR"
        }
        set(value) {
            self.defaults.set(value, forKey: Keys.source)
        }
    }
    
    var destination: String {
        get {
            let source = self.defaults.string(forKey: Keys.destination)
            if source != nil {
                return source!
            }
            return "USD"
        }
        set(value) {
            self.defaults.set(value, forKey: Keys.destination)
        }
    }
}
