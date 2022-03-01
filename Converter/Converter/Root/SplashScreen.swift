//
//  SplashScreen.swift
//  Converter
//
//  Created by Roger Molas on 3/2/22.
//

import Foundation
import UIKit

class SplashScreen: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        imageView.image = GradientLayer().image(frame: self.view.frame)
        imageView.contentMode = .scaleAspectFit
    }
}
