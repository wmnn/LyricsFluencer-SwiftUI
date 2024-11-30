//
//  CardModel.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 30.11.24.
//
import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class CardModel {
    
    let db = Firestore.firestore();
    
    func handleGood(card: Card, deckName: String, completion: @escaping (Card) -> Void){
        
        var newCard = card;
        if card.interval == 0 {
            newCard.interval = 1
        } else {
            newCard.interval = card.interval * 2
        }
        
        let uid = UserModel.getCurrentUserId()
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = newCard.interval
        
        let nextDue = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        newCard.due = nextDue!
        
        db.collection("flashcards").document(uid).collection("decks").document(deckName).collection("cards").document(card.id).setData([
            "interval": newCard.interval,
            "due": nextDue!
        ], merge: true)
        
        completion(newCard)
    }
    
    func editCard(deckName: String, updatedCard: Card, completion: @escaping (Card?) -> Void) {
        
        let uid = UserModel.getCurrentUserId()
        self.db.collection("flashcards").document(uid).collection("decks").document(deckName).collection("cards").document(updatedCard.id).setData([
                "front" : updatedCard.front,
                "back" : updatedCard.back,
                "interval" : updatedCard.interval,
                "due": updatedCard.due
        ], merge: true){ err in
            guard err == nil else {
                print("Error while editing card \(err!)")
                completion(nil);
                return;
            }
            print(updatedCard)
            completion(updatedCard);
        }
    }
    func deleteCard(_ deckName: String, _ cardId: String, completion: @escaping (Bool) -> Void) {
        let uid = UserModel.getCurrentUserId()
        
        self.db.collection("flashcards").document(uid).collection("decks").document(deckName).collection("cards").document(cardId).delete(){ err in
            if let err = err {
                print("Error while deleting deck \(err)")
                completion(false);
            } else {
                completion(true);
            }
        }
        
    }
    
}
