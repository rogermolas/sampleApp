//
//  ViewController.swift
//  Converter
//
//  Created by Roger Molas on 2/26/22.
//

import UIKit
import ActionSheetPicker_3_0
import MBProgressHUD

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    var amountToConvert = 0.00
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.tableView.addGestureRecognizer(tap)
        self.view.addGestureRecognizer(tap)
        tableView.keyboardDismissMode = .interactive
        tableView.keyboardDismissMode = .onDrag

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
        
        // Get initial amount conversion for the current source to destination
        // All amount available
        let amount = BalanceStorage.shared.getBalance(forKey: source)
        self.convertRequest(amount: amount, source: source, destination: destination)
    }
    
    //MARK: - Action
    
    @objc func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    
    @IBAction func onSubmit(sender: UIButton) {
        self.dismissKeyBoard()

        if BalanceStorage.shared.getBalance(forKey: source) <= 0 {
            let message = "Does not have enough \(source) balance to cover transactions."
            UIAlertController.init(title: "Insufficient fund", message: message, onDone: nil)
                .show(owner: self, completion: nil)
            return
        }
        
        if source == destination {
            let message = "Conversion using the same currency is not allowed"
            UIAlertController.init(title: "Invalid Conversion", message: message, onDone: nil)
                .show(owner: self, completion: nil)
            return
        }
        
        // Assuming it was doing a sending API request to server
        let hud = MBProgressHUD.showAdded(to: self.navigationController!.view, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            hud.hide(animated: true)
            let action: callBack = { [self] in
                // Update source and destination balance
                let total =  BalanceStorage.shared.getBalance(forKey: self.source)
                let remainingAmount = total - amountToConvert
                BalanceStorage.shared.setBalance(amount: remainingAmount, forKey: self.source)
                let convertedAmount = BalanceStorage.shared.getCoversion(forKey: self.destination)
                BalanceStorage.shared.setBalance(amount: convertedAmount, forKey: self.destination)
                self.tableView.reloadData()
            }
            let souceBalance = BalanceStorage.shared.getBalance(forKey: self.source)
            let receiveBalance = BalanceStorage.shared.getCoversion(forKey: self.destination)
            let commission = 0.4
            
            let message = "You have converted \(souceBalance) \(self.source) to \(receiveBalance) \(self.destination). Commission Fee - \(commission) EUR"
            UIAlertController.init(title: "Currency Converted", message: message, onDone: action)
                .show(owner: self, completion: nil)
        }
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
    func didChangeCurrency(cell: ConversionCell, trans: Transaction, code: String, amount: String) {
        self.amountToConvert = amount.toDouble()
        if trans == .sell {
            BalanceStorage.shared.source = code
            self.convertRequest(amount: amount.toDouble(), source: code, destination: destination)
        }
        
        if trans == .recieve {
            BalanceStorage.shared.destination = code
            self.convertRequest(amount: amount.toDouble(), source: source, destination: code)
        }
    }
}
