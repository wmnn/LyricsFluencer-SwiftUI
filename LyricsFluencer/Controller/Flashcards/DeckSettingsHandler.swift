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
    func handleDeleteDeck() {
        appBrain?.deckModel.handleDeleteDeck()
    }
}
