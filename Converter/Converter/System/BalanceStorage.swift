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
        static let source = "conversion.source"
        static let destination = "conversion.destination"
    }
    
    func getBalance(forKey: String) -> Double {
        let balance = self.defaults.double(forKey: forKey)
        
        if forKey == "EUR" && balance == 0.0 {
            if self.defaults.value(forKey: forKey) == nil {
                return 100.0 // default to 100
            }
        }
        return balance
    }
    
    func setBalance(forKey: String) -> Double {
        return self.defaults.double(forKey: forKey)
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
            return "EUR"
        }
        set(value) {
            self.defaults.set(value, forKey: Keys.destination)
        }
    }
}
