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
            return newText.isEmpty ? "This field cannot be empty" : nil
            
        case .phone:
            let phoneRegex = "^(?:\\+?20|0)?1[0125][0-9]{8}$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return predicate.evaluate(with: value) ? nil : "Phone number must start with +20 (e.g. +201XXXXXXXXX)"
            
        case .password:
            let pattern = #"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$"#
              let regexMatch = value.range(of: pattern, options: .regularExpression) != nil
              return regexMatch ? nil : "Password must be 8+ characters, with uppercase, lowercase, number, and symbol."
            
        case .confirmPassword(let binding):
            return value == binding.wrappedValue ? nil : "Passwords do not match"
            
        case .limit(let min, let max):
            guard let numericValue = Double(value) else {
                return "Must be a valid number"
            }
            var errors = [String]()
            if let min = min, numericValue < min {
                errors.append("Value must be ≥ \(min)")
            }
            if let max = max, numericValue > max {
                errors.append("Value must be ≤ \(max)")
            }
            return errors.isEmpty ? nil : errors.joined(separator: " and ")
            
        case .numeric:
            return Double(value) == nil ? "Must be a numeric value" : nil
        }
    }
    
    
    
}
