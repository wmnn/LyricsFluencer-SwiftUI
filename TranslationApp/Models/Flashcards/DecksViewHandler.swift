//
//  DecksViewHandler.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 25.02.23.
//

import Foundation

class DecksViewHandler: ObservableObject{
    @Published var showCreateDeckAlert = false
    @Published var createDeckName = ""
    
    func handleSelectedADeck(appBrain: AppBrain, deckName: String, cards: [Card]){
        //Selected a deck
        appBrain.selectedDeck.deckName = deckName
        appBrain.selectedDeck.cards = cards
        appBrain.path.append("CardsView")
    }
    func handleCountDueCards(cards: [Card]) -> Int{
        let today = Date()
        let filteredCards = cards.filter { card in
            return card.due < today
        }
        return Int(filteredCards.count)
    } 
}
