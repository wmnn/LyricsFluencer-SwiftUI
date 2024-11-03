//
//  DecksViewHandler.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 25.02.23.
//

import Foundation

class DecksViewHandler: ObservableObject{
    var appBrain: AppBrain?
    var deckContext: DeckContext!
    @Published var showCreateDeckAlert = false
    @Published var createDeckName = ""
    
    
    func handleSelectedADeck(deckName: String, cards: [Card]){
        //Selected a deck
        self.deckContext.selectedDeck.deckName = deckName
        self.deckContext.selectedDeck.cards = cards
        self.appBrain!.path.append("CardsView")
    }
    func handleCountDueCards(cards: [Card]) -> Int{
        let today = Date()
        let filteredCards = cards.filter { card in
            return card.due < today
        }
        return Int(filteredCards.count)
    } 
}
