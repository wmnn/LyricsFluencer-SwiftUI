//
//  DeckController.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 03.11.24.
//
import Foundation;
import Firebase
import FirebaseAuth
import FirebaseFirestore

class DeckContext: ObservableObject {
    
    @Published var decks: [Deck] = []
    @Published var selectedDeck = Deck(deckName: "", cards: [])
    let db = Firestore.firestore();
    let deckModel: DeckModel = DeckModel()
    
    func createDeck(deckName: String) {
        deckModel.createDeck(deckName: deckName) { deck in
            DispatchQueue.main.async {
                self.decks.append(deck)
            }
        }
    }
    
    func fetchingDecks(completion: @escaping ([Deck]?) -> Void) {
        deckModel.fetchingDecks{ decks in
            guard decks != nil else {
                self.decks = [];
                completion(nil);
                return;
            }
            DispatchQueue.main.async {
                self.decks = decks!;
                completion(decks!);
            }
        }
    }
    
    func handleAddToDeck(front: String, back: String) {
        deckModel.handleAddToDeck(front: front, back: back, deckName: self.selectedDeck.deckName) { newCard in
            guard newCard != nil else {
                return;
            }
            DispatchQueue.main.async {
                self.selectedDeck.cards?.append(newCard!)
                
                if let deckIndex = self.decks.firstIndex(where: { $0.deckName == self.selectedDeck.deckName }) {
                    self.decks[deckIndex].cards?.append(newCard!)
                }
            }
        }
    }
    
    func handleDeleteDeck() {
        deckModel.handleDeleteDeck(deckName: self.selectedDeck.deckName) { deckName in
        
            let newDecks = self.decks.filter { deck in
                return deck.deckName != self.selectedDeck.deckName
            }
            DispatchQueue.main.async {
                self.decks = newDecks
            }
            
        }
        
    }
}
