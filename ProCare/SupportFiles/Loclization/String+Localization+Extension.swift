//
//  String+Localization+Extension.swift
//  AllinOnApp
//
//  Created by ahmed hussien on 01/02/2024.
//

import Foundation

extension String {
    
    /// Localizes a string using the Localization Manager current language
    /// - Returns: Localized String
    func localized() -> String {
       // let language = LocalizationManager.shared.currentLanguage
        let deviceLocale = NSLocale.current.language.languageCode?.identifier ?? "ar"
        let language  = Language(rawValue: deviceLocale) ?? .arabic
        return localized(language)
    }
    
    /// Localizes a string using a given language from Language enum
    /// - Parameter language: The language that will be used to localized string
    /// - Returns: Localized String
    func localized(_ language: Language) -> String {
        
        let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj")
        let bundle: Bundle
        if let path = path {
            bundle = Bundle(path: path) ?? .main
        } else {
            bundle = .main
        }
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    
}


enum Language: String {
    
    case arabic = "ar-EG"
    case english = "en-US"
    
    var locale: Locale {
        switch self {
        case .arabic:
            return Locale(identifier: Language.arabic.rawValue)
        case .english:
            return Locale(identifier: Language.english.rawValue)
        }
    }
    
}
