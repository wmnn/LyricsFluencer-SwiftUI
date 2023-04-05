//
//  LocaleStorage.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 05.04.23.
//

import Foundation

struct LocaleStorage{
    static let defaults = UserDefaults.standard
    
    static func removeData(){
        defaults.removeObject(forKey: "subscriptionPlan")
        defaults.removeObject(forKey: "subscriptionStatus")
        defaults.removeObject(forKey: "defaultLanguage")
        defaults.removeObject(forKey: "requests")
    }
    static func getValue(for key: String) -> String?{
        let data = defaults.string(forKey: key)
        return data
    }
    static func setValue(for key: String, value: Any?){
        defaults.set(value, forKey: key)
    }
}

