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
    
    var source: String = "EUR"
    var destination: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Navbar
        let r = UIColor(named: "rightColor")?.cgColor
        let l = UIColor(named: "leftColor")?.cgColor
        let gradient = CAGradientLayer()
        gradient.colors = [r as Any, l as Any]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = self.navigationController!.navigationBar.bounds
        
        let image = self.image(fromLayer: gradient)
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundImage = self.image(fromLayer: gradient)
            self.navigationController!.navigationBar.standardAppearance = appearance;
            self.navigationController!.navigationBar.scrollEdgeAppearance =  self.navigationController!.navigationBar.standardAppearance
        } else {
            self.navigationController!.navigationBar.setBackgroundImage(image, for: .default)
        }
    }
    
    // Generate image from Layer
    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
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
extension ViewController: ConversionCellDelegate {
    func didChangeCurrency(cell: ConversionCell, trans: Transaction, code: String) {
        if trans == .sell {
            source = code
        }
        if trans == .sell {
            destination = code
        }
    }
}
