//
//  EditCardView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 25.02.23.
//

import Foundation
import FirebaseFirestore


class EditCardsViewHandler: ObservableObject{
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    var appBrain: AppBrain?
    @Published var front: String = ""
    @Published var back: String = ""
    @Published var selectedCardID: String = ""
    @Published var isEditCardAlertShown: Bool = false
    @Published var isDeleteCardAlertShown: Bool = false
    
    
    func handleIsEditCardClicked(front: String, back: String, id: String){
        self.front = front
        self.back = back
        self.selectedCardID = id
        self.isEditCardAlertShown = true
    }
    func handleCancel(){
        self.isEditCardAlertShown = false
        self.isDeleteCardAlertShown = false
    }
    func handleEditCard(){
        let uid = self.appBrain!.getCurrentUser()
        self.db.collection("flashcards").document(uid).collection("decks").document(self.appBrain!.user.selectedDeck.deckName).collection("cards").document(self.selectedCardID).setData([
            "front" : self.front,
            "back" : self.back
            ], merge: true){ err in
            if let err = err {
                print("Error while editing card \(err)")
            } else {
                // Filter the decks array and create a new array with updated decks
                let newDecks = self.appBrain!.user.decks.map { deck in
                    if deck.deckName == self.appBrain!.user.selectedDeck.deckName {
                        // If deck name matches selected deck, filter the cards array and create a new array with updated cards
                        let newCards = deck.cards?.map { card in
                            if card.id == self.selectedCardID {
                                let updatedCard = Card(front: self.front, back: self.back, due: card.due, id: card.id)
                                return updatedCard
                            } else {
                                return card
                            }
                        }
                        // Update the deck's cards property with the new array of cards
                        var updatedDeck = deck
                        updatedDeck.cards = newCards
                        self.appBrain!.user.selectedDeck.cards = newCards
                        return updatedDeck
                    } else {
                        // For all other decks, return them as is
                        return deck
                    }
                }
                // Update the appBrain's decks array with the new array of decks
                self.appBrain!.user.decks = newDecks
                self.isEditCardAlertShown = false
            }
        }
        
    }
    func handleIsDeleteCardAlertClicked(id: String){
        self.selectedCardID = id
        self.isDeleteCardAlertShown = true
    }
    func handleDeleteCard(){
        let uid = self.appBrain!.getCurrentUser()
        
        self.db.collection("flashcards").document(uid).collection("decks").document(self.appBrain!.user.selectedDeck.deckName).collection("cards").document(self.selectedCardID).delete(){ err in
            if let err = err {
                print("Error while deleting deck \(err)")
            } else {
                // Filter the decks array and create a new array with updated decks
                let newDecks = self.appBrain!.user.decks.map { deck in
                    if deck.deckName == self.appBrain!.user.selectedDeck.deckName {
                        // If deck name matches selected deck, filter the cards array and create a new array with updated cards
                        let newCards = deck.cards?.filter { card in
                            return card.id != self.selectedCardID
                        }
                        // Update the deck's cards property with the new array of cards
                        var updatedDeck = deck
                        updatedDeck.cards = newCards
                        self.appBrain!.user.selectedDeck.cards = newCards
                        return updatedDeck
                    } else {
                        // For all other decks, return them as is
                        return deck
                    }
                }
                // Update the appBrain's decks array with the new array of decks
                self.appBrain!.user.decks = newDecks
                self.isDeleteCardAlertShown = false
            }
        }
    }
}
