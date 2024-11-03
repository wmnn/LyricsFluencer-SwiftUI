//
//  DeckSettingsHandler.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 25.02.23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class DeckSettingsHandler: ObservableObject {
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    @Published var front = ""
    @Published var back = ""
    @Published var showCreateCardAlert = false
    @Published var showDeleteDeckAlert = false
    
    func handleCancel() {
        self.front = ""
        self.back = ""
        self.showCreateCardAlert = false
    }
    
    func handleCreateCard(deckContext: DeckContext) {
        var _ = deckContext.handleAddToDeck(front: self.front, back: self.back)
        DispatchQueue.main.async {
            self.front = ""
            self.back = ""
            self.showCreateCardAlert = false
        }
    }
}
