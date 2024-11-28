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
            let dispatchGroup = DispatchGroup()
            
            for document in querySnapshot?.documents ?? [] {
                
                dispatchGroup.enter()
                
                self.getCards(deckReference: document.reference) { cards in
                    let deck = Deck(deckName: document.documentID, cards: cards)
                    decks.append(deck)
                    dispatchGroup.leave()
                }
            }
            
            // After all asynchronous tasks are done, call the completion handler
            dispatchGroup.notify(queue: .main) {
                // Call the completion handler on the main thread
                completion(decks)
            }
        }
    }
    
    func getCards(deckReference: DocumentReference, completion: @escaping ([Card]) -> Void) {
        deckReference.collection("cards").getDocuments { (querySnapshot, error) in
            
            if let error = error {
                print("Error getting decks: \(error)")
                // Return an empty array in case of error
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            // Process the documents into Deck objects
            var cards: [Card] = []
            
            // Loop through the documents
            for document in querySnapshot?.documents ?? [] {
                // Get the data from the document
                let data = document.data()
                
                // Extract the fields from the document data (assuming fields are present)
                if let front = data["front"] as? String,
                   let back = data["back"] as? String,
                   let interval = data["interval"] as? Int,
                   let dueTimestamp = data["due"] as? Timestamp
                {
                    let due = dueTimestamp.dateValue()
                    let card = Card(front: front, back: back, interval: interval, due: due, id: document.documentID)
                    cards.append(card)
                } else {
                    // If this block is not being executed, this helps debug why
                    print("Skipping document due to missing or incorrect data fields")
                }
            }
            
            DispatchQueue.main.async {
                completion(cards)
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
    
}
