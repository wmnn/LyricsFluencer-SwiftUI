//
//  CardContext.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 30.11.24.
//
import SwiftUI
import FirebaseFirestore

class CardContext: ObservableObject {
    
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    var appBrain: AppContext?
    var deckContext: DeckContext!
    @Published var isFrontClicked = false
    @Published var filteredDeck: [Card] = []
    @Published var currentIdxInFilteredDeck : Int = 0
    let cardModel = CardModel()
    
    // For editing and deleting cards
    @Published var selectedCard: Card? = nil;
    @Published var tmpCard: Card = Card(front: "", back: "", interval: -1, due: Date(), id: "-1");

    func handleFilteringForDueCards() {
        
        let today = Date()
        let filteredCards = self.deckContext.selectedDeck.cards?.filter { card in
            return card.due < today
        }
        self.filteredDeck = filteredCards ?? []
        
    }
    
    func handleGood() {
        
        let currentCard = filteredDeck[currentIdxInFilteredDeck];
        print(currentCard)
        
        cardModel.handleGood(card: currentCard, deckName: self.deckContext.selectedDeck.deckName) { newCard in
        
            DispatchQueue.main.async {
            
                // Replace the old card instance with the updated one
                self.deckContext.updateCard(deckName: self.deckContext.selectedDeck.deckName, cardId: newCard.id, newCard: newCard)
                
                self.currentIdxInFilteredDeck += 1
                
                // Completed all due cards
                if self.currentIdxInFilteredDeck == self.filteredDeck.count{
                    self.appBrain!.path.removeLast()
                }
                self.isFrontClicked.toggle()
            }
        }
        
    }
    
    func handleAgain() {
        
        // updating card in filtered deck
        var currentCard = filteredDeck[currentIdxInFilteredDeck];
        currentCard.due = Date()
        currentCard.interval = 0;
        
        let deckName = self.deckContext.selectedDeck.deckName;
        
        DispatchQueue.main.async {
            
            self.cardModel.editCard(deckName: deckName, updatedCard: currentCard) { card in
                
                // updating card in deck context
                self.deckContext.updateCard(deckName: deckName, cardId: currentCard.id, newCard: currentCard)
                
                self.filteredDeck.append(self.filteredDeck[self.currentIdxInFilteredDeck])
                self.currentIdxInFilteredDeck += 1
                self.isFrontClicked.toggle()
            }
        }
        
    }
    
    func editCard(completion: @escaping (Card?) -> Void){
        
        let deckName = self.deckContext.selectedDeck.deckName;
        let updatedCard = self.tmpCard;
        
        cardModel.editCard(deckName: deckName, updatedCard: updatedCard) { card in
            guard card != nil else {
                completion(nil)
                return;
            }
            
            self.deckContext.updateCard(deckName: deckName, cardId: updatedCard.id, newCard: updatedCard)
            completion(card)
        }
    }
    
    func deleteCard(completion: @escaping (Bool) -> Void){
        let deckName = self.deckContext.selectedDeck.deckName;
        let cardId = self.selectedCard?.id ?? "-1"
        
        if (cardId == "-1") {
            return;
        }
        cardModel.deleteCard(deckName, cardId) { isDeleted in
            
            guard isDeleted == true else {
                completion(false);
                return;
            }
            
            self.deckContext.deleteCard(deckName: deckName, cardId: cardId)
            completion(true);
            
        }
        
        
    }
    
}
