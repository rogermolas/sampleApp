//
//  Layer.swift
//  Converter
//
//  Created by Roger Molas on 3/2/22.
//

import Foundation
import UIKit

class GradientLayer {
    
    func image(frame: CGRect) -> UIImage {
        let r = UIColor(named: "rightColor")?.cgColor
        let l = UIColor(named: "leftColor")?.cgColor
        let gradient = CAGradientLayer()
        gradient.colors = [r as Any, l as Any]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = frame
        
        return self.image(fromLayer: gradient)
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
