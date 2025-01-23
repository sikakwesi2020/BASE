//
//  LocaleManager.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/9/25.
//

import Foundation

class LocaleManager {
    static let shared = LocaleManager()

    private let localeKey = "userLocale"
    private let availableLocales = ["en", "hi", "zh", "fr", "de", "ar", "it", "ja", "pl", "pt-BR", "ru", "es", "sw", "tr"]
    
    func saveLocale(locale: Locale) {
            UserDefaults.standard.set(locale.identifier, forKey: localeKey)
            UserDefaults.standard.synchronize() // Synchronize is optional and considered unnecessary in most cases for iOS 12 and later.
            print("new language set")
        }
    
    func loadLanguage() -> String {
        let localeApp = fetchLocale()
        return localeApp.localizedString(forLanguageCode: localeApp.languageCode!) ?? "Unset"
    }
    
    func fetchLocale() -> Locale {
       
        // Fetch the saved locale from UserDefaults or default to "en" if not found
        let localeIdentifier = UserDefaults.standard.string(forKey: localeKey) ?? "en"
        return Locale(identifier: localeIdentifier)
    }

    func fetchInitialLocale() -> Locale {
        
        if UserDefaults.standard.object(forKey: localeKey) == nil {
            // first time
            // Check if the first part of the identifier (language code) is in the available locales
            if let languageCode = Locale.current.language.languageCode?.identifier, availableLocales.contains(languageCode) {
                print("First time, has current code and will translate directly")
                return Locale(identifier: languageCode)
               
                
            }else{
                
                let localeIdentifier = "en"
                print("First time, not yet translated")
                return Locale(identifier: localeIdentifier)
                
            }
            
        }else{
            // Fetch the saved locale from UserDefaults or default to "en" if not found
            let localeIdentifier = UserDefaults.standard.string(forKey: localeKey) ?? "en"
            return Locale(identifier: localeIdentifier)
        }
        
       
    }
}


