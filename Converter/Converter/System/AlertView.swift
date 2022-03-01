//
//  AlertView.swift
//  Converter
//
//  Created by Roger Molas on 3/1/22.
//

import Foundation
import UIKit

public typealias callBack = (() -> Swift.Void)

extension UIAlertController {
    
    convenience init(title: String, message: String? = nil, onDone doneHandler: callBack? = nil) {
        self.init(title: title, message: message, preferredStyle: .alert)
        self.addAction(UIAlertAction(title: "Done", style: .default) { (action) in
            if doneHandler != nil {
                doneHandler!()
            }
        })
    }
    
    convenience init(title: String, message: String? = nil, onError errHandler: callBack? = nil) {
        self.init(title: title, message: message, preferredStyle: .alert)
        self.addAction(UIAlertAction(title: "Ok", style: .cancel) { (action) in
            if errHandler != nil {
                errHandler!()
            }
        })
    }
    
    func show(owner: UIViewController, completion: callBack? = nil) {
        owner.present(self, animated: true, completion: completion)
    }
}
