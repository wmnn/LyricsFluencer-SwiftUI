//
//  LocaleStorage.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 05.04.23.
//

import Foundation

struct LocalStorageModel{
    static let defaults = UserDefaults.standard
    
    static func removeData(){
        defaults.removeObject(forKey: "subscriptionPlan")
        defaults.removeObject(forKey: "subscriptionStatus")
        defaults.removeObject(forKey: "learnedLanguage")
        defaults.removeObject(forKey: "nativeLanguage")
    }
    static func getValue(for key: String) -> String?{
        let data = defaults.string(forKey: key)
        return data
    }
    static func setValue(for key: String, value: Any?){
        defaults.set(value, forKey: key)
    }
    static func updateUser(user: User) {
        //Saving to local storage
        // self.defaults.set(user.subscriptionPlan, forKey: "subscriptionPlan")
        self.defaults.set(user.nativeLanguage, forKey: "nativeLanguage")
        self.defaults.set(user.learnedLanguage, forKey: "learnedLanguage")
    }
}

