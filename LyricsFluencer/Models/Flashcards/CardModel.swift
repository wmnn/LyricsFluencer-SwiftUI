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
    
    func updateCard(deckName: String, updatedCard: Card, completion: @escaping (Card?) -> Void) {
        
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
