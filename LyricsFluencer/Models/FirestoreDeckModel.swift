//
//  DeckModel.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 03.11.24.
//
import Foundation;
import Firebase
import FirebaseAuth
import FirebaseFirestore

class FirestoreDeckModel: DeckProtocol {
    
    let db = Firestore.firestore();
    
    func createDeck(deckName: String, completion: @escaping (Deck) -> Void) {
        let uid = UserModel.getCurrentUserId()
        let deckName = deckName
        
        self.db.collection("flashcards").document(uid).getDocument { (document, error) in
            
            if let error = error {
                print(error)
                return;
            }
            
            let data: [String: Any] = [
                "createdAt": FieldValue.serverTimestamp()
            ]
            if let document = document, document.exists { // If the document exists, add data to the "decks" subcollection
                self.db.collection("flashcards").document(uid).collection("decks").document(deckName).setData(data, merge: true)
            } else {// If the document doesn't exist, create it with the timestamp field
                self.db.collection("flashcards").document(uid).setData(data)
                self.db.collection("flashcards").document(uid).collection("decks").document(deckName).setData(data, merge: true)
            }
            let deck = Deck(deckName: deckName, cards: [])
            completion(deck)
        }
        
        
    }
    
    func fetchingDecks(completion: @escaping ([Deck]) -> Void) {
        
        let uid = UserModel.getCurrentUserId()
        self.db.collection("flashcards").document(uid).collection("decks").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting decks: \(error)")
                // Return an empty array in case of error
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            // Process the documents into Deck objects
            var decks: [Deck] = []
            for document in querySnapshot?.documents ?? [] {
                // Create a Deck object from the document data
                let deck = Deck(deckName: document.documentID, cards: [])
                decks.append(deck)
            }
            
            // Call the completion handler on the main thread
            DispatchQueue.main.async {
                completion(decks)
            }
        }
    }


    
    func handleAddToDeck(front: String, back: String, deckName: String) -> String {
        
        var documentID: String = ""
        guard deckName != "" else {
            return ""//Bad outcome 1
        }
        
        let uid = UserModel.getCurrentUserId()
        var ref: DocumentReference? = nil
        ref = db.collection("flashcards").document(uid).collection("decks").document(deckName).collection("cards").addDocument(data: [
            "front": front,
            "back": back,
            "interval": 0,
            "due": Date()
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                documentID = ref!.documentID
            }
        }
        
        return documentID
    }
    func handleDeleteDeck(deckName: String, completion: @escaping (String) -> Void) {
        let uid = UserModel.getCurrentUserId()
        
        let subcollectionRef = db.collection("flashcards").document(uid).collection("decks").document(deckName).collection("cards")
        subcollectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
                self.db.collection("flashcards").document(uid).collection("decks").document(deckName).delete(){ err in
                    if let err = err{
                        print("Error while deleting deck \(err)")
                    } else {
                        completion(deckName)
                    }
                }
            }
        }
    }
    
    func getDecks(completion: @escaping (QuerySnapshot?, Error?) -> Void) {
        let uid = UserModel.getCurrentUserId()
        self.db.collection("flashcards").document(uid).collection("decks").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting subcollection: \(error)")
                completion(nil, error)
            } else {
                completion(querySnapshot, nil)
            }
        }
    }
    
    func getCards(reference: DocumentReference, completion: @escaping (QuerySnapshot?, Error?) -> Void) {
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
