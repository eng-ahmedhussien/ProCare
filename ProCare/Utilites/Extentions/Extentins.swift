//
//  Extentins.swift
//  ProCare
//
//  Created by ahmed hussien on 28/03/2025.
//

import SwiftUI

//MARK: UIImage
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
//MARK: Int
extension Int {
    func toString() -> String {
        return String(self)
    }
    
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
//MARK: Date
extension Date {
    func toAPIDateString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    func toAPITimeString() -> String {
           let formatter = DateFormatter()
           formatter.locale = Locale(identifier: "en_US_POSIX")
           formatter.dateFormat = "HH:mm"
           return formatter.string(from: self)
       }
}

//MARK: string
extension String {
    func toAPIDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: self)
    }
}

extension Double {
    var starRateIcon: String {
        switch self {
        case 1...3:
            return "star.leadinghalf.filled"
        case 4...5:
            return "star.fill"
        default:
            return "star"
        }
    }
}
