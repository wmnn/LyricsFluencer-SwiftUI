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
    
    func calculateNextInterval(_ currentInterval: Int) -> Int {
        if currentInterval == 0 {
            return 1
        }
        return currentInterval * 2
    }
    
    func calculateDueDate(interval: Int) -> Date {
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = interval
        return Calendar.current.date(byAdding: dateComponent, to: currentDate)!
    }
    
    func handleGood() {
        
        let uid = UserModel.getCurrentUserId()
        let deckName = self.deckContext.selectedDeck.deckName;
        var updatedCard = Card(filteredDeck[currentIdxInFilteredDeck]);
        updatedCard.interval = calculateNextInterval(updatedCard.interval)
        updatedCard.due = calculateDueDate(interval: updatedCard.interval)
        
        cardModel.updateCard(deckName: deckName, updatedCard: updatedCard) { newCard in
            guard newCard != nil else {
                return;
            }
            
            // Replace the old card instance with the updated one
            self.deckContext.updateCard(deckName: deckName, cardId: updatedCard.id, newCard: updatedCard)
            
            self.currentIdxInFilteredDeck += 1
            
            // Completed all due cards
            if self.currentIdxInFilteredDeck == self.filteredDeck.count{
                self.appBrain!.path.removeLast()
            }
            self.isFrontClicked.toggle()
            
        }
        
    }
    
    func handleAgain() {
        
        // updating card in filtered deck
        var currentCard = filteredDeck[currentIdxInFilteredDeck];
        currentCard.due = Date()
        currentCard.interval = 0;
        
        let deckName = self.deckContext.selectedDeck.deckName;
        
        DispatchQueue.main.async {
            
            self.cardModel.updateCard(deckName: deckName, updatedCard: currentCard) { card in
                
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
        
        cardModel.updateCard(deckName: deckName, updatedCard: updatedCard) { card in
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
