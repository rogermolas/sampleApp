//
//  ViewController.swift
//  Converter
//
//  Created by Roger Molas on 2/26/22.
//

import UIKit
import ActionSheetPicker_3_0

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    
    var source: String {
        get {
            return BalanceStorage.shared.source
        }
        set(newValue) {
            BalanceStorage.shared.source = newValue
        }
    }
    
    var destination: String {
        get {
            return BalanceStorage.shared.destination
        }
        set(newValue) {
            BalanceStorage.shared.destination = newValue
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Navbar
        self.title = "Currency Converter"
        let image = GradientLayer().image(frame: self.navigationController!.navigationBar.bounds)
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundImage = image
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            self.navigationController!.navigationBar.standardAppearance = appearance;
            self.navigationController!.navigationBar.scrollEdgeAppearance =  self.navigationController!.navigationBar.standardAppearance
        } else {
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController!.navigationBar.setBackgroundImage(image, for: .default)
        }
        
        //Get initial amount conversion for the current source to destination
        let amount = BalanceStorage.shared.getBalance(forKey: source)
        self.convertRequest(amount: amount, source: source, destination: destination)
    }
    
    //MARK: - Action
    @IBAction func onSubmit(sender: UIButton) {
        if BalanceStorage.shared.getBalance(forKey: source) <= 0 {
            let message = "Does not have enough \(source) balance to cover transactions."
            UIAlertController.init(title: "Insufficient fund", message: message, onDone: nil)
                .show(owner: self, completion: nil)
            return
        }

        let action: callBack = {
            // Update source and destination balance
            BalanceStorage.shared.setBalance(amount: 0.0, forKey: self.source)
            let convertedAmount = BalanceStorage.shared.getCoversion(forKey: self.destination)
            BalanceStorage.shared.setBalance(amount: convertedAmount, forKey: self.destination)
            self.tableView.reloadData()
        }
        let souceBalance = BalanceStorage.shared.getBalance(forKey: source)
        let receiveBalance = BalanceStorage.shared.getCoversion(forKey: destination)
        let commission = 0.4
        
        let message = "You have converted \(souceBalance) \(source) to \(receiveBalance) \(destination). Commission Fee - \(commission) EUR"
        UIAlertController.init(title: "Currency Converted", message: message, onDone: nil)
            .show(owner: self, completion: action)
    }
    
    //MARK: - API
    func convertRequest(amount: Double, source: String, destination: String) {
        let request = ConversionManager()
        request.convert(amount: amount, from: source, to: destination)
        { conversion, error in
            
            guard error == nil else {
                UIAlertController.init(title: "Error", message: error, onError: nil)
                    .show(owner: self, completion: nil)
                let indexSet: IndexSet = [1]
                self.tableView.reloadSections(indexSet, with: .none)
                return
            }
            
            if let c = conversion {
                BalanceStorage.shared.setCoversion(amount: Double(c.amount)!, forKey: c.currency)
                let indexSet: IndexSet = [1]
                self.tableView.reloadSections(indexSet, with: .none)
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = Sections(rawValue: section)
        return section!.rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Sections(rawValue: indexPath.section)
        
        if section == .balances {
            let cell = BalanceCell.dequeueCell(tableView, indexPath)
            return cell!
        }
        
        let trans = Transaction(rawValue: indexPath.row)
        let cell = ConversionCell.dequeueCell(tableView, indexPath)
        cell?.set(trans: trans!)
        cell?.delegate = self
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = Sections(rawValue: section)
        return section?.header
    }
}

//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.gray
        header.textLabel?.font = UIFont.systemFont(ofSize: 14)
    }
}

//MARK: - ConversionCellDelegate
extension ViewController: ConversionCellDelegate {
    func didChangeCurrency(cell: ConversionCell, trans: Transaction, code: String) {
        if trans == .sell {
            BalanceStorage.shared.source = code
            let amount = BalanceStorage.shared.getBalance(forKey: code)
            self.convertRequest(amount: amount, source: code, destination: destination)
        }
        
        if trans == .recieve {
            BalanceStorage.shared.destination = code
            let amount = BalanceStorage.shared.getBalance(forKey: source)
            self.convertRequest(amount: amount, source: source, destination: code)
        }
    }
}
