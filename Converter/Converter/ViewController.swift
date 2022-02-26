//
//  ViewController.swift
//  Converter
//
//  Created by Roger Molas on 2/26/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        let cell = ConversionCell.dequeueCell(tableView, indexPath)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = Sections(rawValue: section)
        return section?.header
    }
    
}

//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
}
