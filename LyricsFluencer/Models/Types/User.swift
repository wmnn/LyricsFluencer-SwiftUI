//
//  User.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 09.03.23.
//

import Foundation

struct User: Codable{
    
    var id: String
    var nativeLanguage: String?
    var learnedLanguage: String?
    // var subscriptionPlan: String?
    // var subscriptionStatus: String?
    // var isTrialExpired: Bool?
    
    init(id: String) {
        self.id = id;
    }
}
