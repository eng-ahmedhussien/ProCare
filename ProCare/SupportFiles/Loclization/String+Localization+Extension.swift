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
        let deviceLocale = NSLocale.current.languageCode ?? "ar"
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
