//
//  FlashcardsModel.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 24.02.23.
//

import Foundation

struct Deck: Identifiable, Hashable, Codable{
    var deckName: String
    var cards: [Card]?
    var id: String{
        return deckName
    }
}

struct Card: Hashable, Identifiable, Codable{
    var front: String
    var back: String
    var createdAt: Date?
    var interval: Int = 0
    var due: Date
    var id: String
}
