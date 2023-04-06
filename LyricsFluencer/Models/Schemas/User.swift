//
//  User.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 09.03.23.
//

import Foundation

struct User: Codable{
    var requests: Int?
    var nativeLanguage = Language(language: "None")
    var learnedLanguage = Language(language: "None")
    var decks: [Deck] = []
    var selectedDeck = Deck(deckName: "", cards: [])
    var subscriptionPlan: String?
    var subscriptionStatus: String?
    var isTrialExpired: Bool = true
    var isSubscriptionPlanChecked: Bool = false
    var isAutoLogin = false
}
