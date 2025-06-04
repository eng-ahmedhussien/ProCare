//
//  Extentins.swift
//  ProCare
//
//  Created by ahmed hussien on 28/03/2025.
//

import SwiftUI


extension Int {
    func toString() -> String {
        return String(self)
    }
}

extension UIImage {
    static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension Int {
    func asEGPCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EGP"
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        if let formatted = formatter.string(from: NSNumber(value: self)) {
            return formatted
        }
        return "\(self) ج.م"
    }
}
