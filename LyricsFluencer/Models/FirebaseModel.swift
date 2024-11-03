//
//  Firestore.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 05.04.23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct FirebaseModel{
    static let db = Firestore.firestore()
    
    static func getCurrentUser() -> String{
        guard let uid = Auth.auth().currentUser?.uid else{
            print("User not found")
            return ""
        }
        return uid
    }
    /*
    static func getDecks() -> QuerySnapshot{
        let uid = self.getCurrentUser()
        var returnedQuerySnapshot : QuerySnapshot
        db.collection("flashcards").document(uid).collection("decks").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting subcollection: \(error)")
            } else {
                returnedQuerySnapshot = querySnapshot!
            }
        }
        return returnedQuerySnapshot
    }*/
    static func getDecks(completion: @escaping (QuerySnapshot?, Error?) -> Void) {
        let uid = self.getCurrentUser()
        db.collection("flashcards").document(uid).collection("decks").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting subcollection: \(error)")
                completion(nil, error)
            } else {
                completion(querySnapshot, nil)
            }
        }
    }
    static func getCards(reference: DocumentReference, completion: @escaping (QuerySnapshot?, Error?) -> Void) {
        reference.collection("cards").getDocuments { (cardsQuerySnapshot, error) in
            if let error = error {
                print("Error getting subcollection: \(error)")
                completion(nil, error)
            } else {
                completion(cardsQuerySnapshot, nil)
            }
        }
    }

}
