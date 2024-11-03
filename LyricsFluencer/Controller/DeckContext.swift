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

protocol DeckProtocol {
    
    func createDeck(deckName: String, completion: @escaping (Deck) -> Void)
    func fetchingDecks(completion: @escaping ([Deck]) -> Void)
    func handleAddToDeck(front: String, back: String, deckName: String) -> String
    func handleDeleteDeck(deckName: String, completion: @escaping (String) -> Void)
    
}

class DeckContext: ObservableObject {
    
    @Published var decks: [Deck] = []
    @Published var selectedDeck = Deck(deckName: "", cards: [])
    let db = Firestore.firestore();
    let deckModel: FirestoreDeckModel = FirestoreDeckModel()
    
    func createDeck(deckName: String) {
        deckModel.createDeck(deckName: deckName) { deck in
            self.decks.append(deck)
        }
    }
    
    func fetchingDecks() {
        deckModel.fetchingDecks{ decks in
            self.decks = decks
        }
    }
    
    func handleAddToDeck(front: String, back: String) -> String {
        let docId =  deckModel.handleAddToDeck(front: front, back: back, deckName: self.selectedDeck.deckName)
        let newCard = Card(front: front, back: back, createdAt: Date(), interval: 0, due: Date(), id: docId)
        self.selectedDeck.cards?.append(newCard)
        
        if let deckIndex = self.decks.firstIndex(where: { $0.deckName == self.selectedDeck.deckName }) {
            self.decks[deckIndex].cards?.append(newCard)
        }
        return docId
    }
    
    func handleDeleteDeck() {
        deckModel.handleDeleteDeck(deckName: self.selectedDeck.deckName) { deckName in
            
            let newDecks = self.decks.filter { deck in
                return deck.deckName != self.selectedDeck.deckName
            }
            self.decks = newDecks
            
        }
        
    }
}
