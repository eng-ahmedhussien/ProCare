//
//  ValidationRuleEnum.swift
//  ProCare
//
//  Created by ahmed hussien on 13/04/2025.
//

import SwiftUI

enum ValidationRule {
    case isEmpty
    case phone
    case password
    case confirmPassword(Binding<String>)
    case limit(min: Double?, max: Double?)
    case numeric
}

extension ValidationRule {
    func validate(_ value: String) -> String? {
        switch self {
        case .isEmpty:
            let newText = value.trimmingCharacters(in: .whitespacesAndNewlines)
            return newText.isEmpty ? "validation_empty".localized() : nil
            
        case .phone:
            let phoneRegex = "^(?:\\+?20|0)?1[0125][0-9]{8}$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return predicate.evaluate(with: value) ? nil : "validation_phone".localized()
            
        case .password:
            let pattern = #"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$"#
              let regexMatch = value.range(of: pattern, options: .regularExpression) != nil
            return regexMatch ? nil : "validation_password".localized()
            
        case .confirmPassword(let binding):
            return value == binding.wrappedValue ? nil : "validation_confirm_password".localized()
            
        case .limit(let min, let max):
            guard let numericValue = Double(value) else {
                return "validation_number".localized()
            }
            var errors = [String]()
            if let min = min, numericValue < min {
                errors.append(String(format: NSLocalizedString("validation_min", comment: ""), min))
            }
            if let max = max, numericValue > max {
                errors.append(String(format: NSLocalizedString("validation_max", comment: ""), max))
            }
            return errors.isEmpty ? nil : errors.joined(separator: NSLocalizedString("validation_and", comment: ""))
            
        case .numeric:
            return Double(value) == nil ? "validation_number".localized() : nil
        }
    }
    
    
    
}
