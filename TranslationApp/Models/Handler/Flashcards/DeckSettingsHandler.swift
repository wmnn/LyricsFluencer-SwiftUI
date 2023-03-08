//
//  DeckSettingsHandler.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 25.02.23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class DeckSettingsHandler: ObservableObject{
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    var appBrain: AppBrain?
    @Published var front = ""
    @Published var back = ""
    @Published var showCreateCardAlert = false
    @Published var showDeleteDeckAlert = false
    
    func handleCancel(){
        self.front = ""
        self.back = ""
        self.showCreateCardAlert = false
    }
    func handleCreateCard(){
        var _ = self.appBrain!.handleAddToDeck(front: self.front, back: self.back)
        DispatchQueue.main.async {
            self.front = ""
            self.back = ""
            self.showCreateCardAlert = false
        }
    }
    func handleDeleteDeck(){
        let uid = self.appBrain!.getCurrentUser()
        
        let subcollectionRef = db.collection("flashcards").document(uid).collection("decks").document(self.appBrain!.selectedDeck.deckName).collection("cards")
        subcollectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
                self.db.collection("flashcards").document(uid).collection("decks").document(self.appBrain!.selectedDeck.deckName).delete(){ err in
                    if let err = err{
                        print("Error while deleting deck \(err)")
                    }else{
                        let newDecks = self.appBrain!.decks.filter { deck in
                            return deck.deckName != self.appBrain!.selectedDeck.deckName
                        }
                        self.appBrain!.decks = newDecks
                        self.appBrain!.path.removeLast()
                    }
                }
            }
        }
    }
}

