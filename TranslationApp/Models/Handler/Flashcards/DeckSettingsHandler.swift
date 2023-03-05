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
    @Published var front = ""
    @Published var back = ""
    @Published var showCreateCardAlert = false
    @Published var showDeleteDeckAlert = false
    
    func handleCancel(){
        self.front = ""
        self.back = ""
        self.showCreateCardAlert = false
    }
    func handleCreateCard(appBrain: AppBrain){
        var _ = appBrain.handleAddToDeck(front: self.front, back: self.back)
        DispatchQueue.main.async {
            self.front = ""
            self.back = ""
            self.showCreateCardAlert = false
        }
    }
    func handleDeleteDeck(appBrain: AppBrain){
        let uid = appBrain.getCurrentUser()
        
        let subcollectionRef = db.collection("flashcards").document(uid).collection("decks").document(appBrain.selectedDeck.deckName).collection("cards")
        subcollectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
                self.db.collection("flashcards").document(uid).collection("decks").document(appBrain.selectedDeck.deckName).delete(){ err in
                    if let err = err{
                        print("Error while deleting deck \(err)")
                    }else{
                        let newDecks = appBrain.decks.filter { deck in
                            return deck.deckName != appBrain.selectedDeck.deckName
                        }
                        appBrain.decks = newDecks
                        appBrain.path.removeLast()
                    }
                }
            }
        }
    }
}

