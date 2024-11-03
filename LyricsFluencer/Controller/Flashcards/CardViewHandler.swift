//
//  CardViewHandler.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 25.02.23.
//

import Foundation
import FirebaseFirestore

class CardViewHandler: ObservableObject{
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    var appBrain: AppBrain?
    @Published var isFrontClicked = false
    @Published var filteredDeck: [Card] = []
    @Published var index : Int = 0
    
    func handleGood(){
        let documentID = filteredDeck[index].id
        let documentFront = filteredDeck[index].front
        let documentBack = filteredDeck[index].back
        let uid = FirebaseModel.getCurrentUser()
        var interval = filteredDeck[index].interval
        if interval == 0 {
            interval = 1
        } else {
            interval = interval * 2
        }
        
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = interval
        let nextDue = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        
        db.collection("flashcards").document(uid).collection("decks").document(self.appBrain!.deckModel.selectedDeck.deckName).collection("cards").document(documentID).setData([
            "interval": interval,
            "due": nextDue!
        ], merge: true)
        if let deckIndex = self.appBrain!.deckModel.decks.firstIndex(where: { $0.deckName == self.appBrain!.deckModel.selectedDeck.deckName }),
           let cardIndex = self.appBrain!.deckModel.decks[deckIndex].cards?.firstIndex(where: { $0.id == documentID }) {
            // Create the updated card instance
            let updatedCard = Card(front: documentFront, back: documentBack, interval: interval, due: nextDue!, id: documentID)
            // Replace the old card instance with the updated one
            self.appBrain!.deckModel.decks[deckIndex].cards?[cardIndex] = updatedCard
        }
        self.index += 1
        if index == self.filteredDeck.count{
            self.appBrain!.path.removeLast()
        }
        self.isFrontClicked.toggle()
    }
    func handleAgain(){
        self.filteredDeck[self.index].due = Date()
        self.filteredDeck[self.index].interval = 0
        DispatchQueue.main.async {
            self.filteredDeck.append(self.filteredDeck[self.index])
            self.index += 1
            self.isFrontClicked.toggle()
        }
    }
    func handleFilteringForDueCards(){
        let today = Date()
        let filteredCards = self.appBrain!.deckModel.selectedDeck.cards?.filter { card in
            return card.due < today
        }
        self.filteredDeck = filteredCards ?? []
    }
}
