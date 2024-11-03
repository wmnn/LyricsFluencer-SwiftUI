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

protocol DeckProtocol {
    
    func createDeck(deckName: String)
    func fetchingDecks()
    func handleAddToDeck(front: String, back: String) -> String
    func handleDeleteDeck()
    
}

class DeckModel: ObservableObject/*, DeckModel */{
    
    let db = Firestore.firestore();
    @Published var decks: [Deck] = []
    @Published var selectedDeck = Deck(deckName: "", cards: [])
    
    func createDeck(deckName: String) {
        let uid = FirebaseModel.getCurrentUser()
        let deckName = deckName
        
        self.db.collection("flashcards").document(uid).getDocument { (document, error) in
            let data: [String: Any] = [
                "createdAt": FieldValue.serverTimestamp()
            ]
            if let document = document, document.exists { // If the document exists, add data to the "decks" subcollection
                self.db.collection("flashcards").document(uid).collection("decks").document(deckName).setData(data, merge: true)
            } else {// If the document doesn't exist, create it with the timestamp field
                self.db.collection("flashcards").document(uid).setData(data)
                self.db.collection("flashcards").document(uid).collection("decks").document(deckName).setData(data, merge: true)
            }
        }
        let deck = Deck(deckName: deckName, cards: [])
        self.decks.append(deck)
    }
    
    func fetchingDecks() {
        
        FirebaseModel.getDecks { (querySnapshot, error) in
            if let error = error {
                print(error)
                return;
            }
            
            for deckDocument in querySnapshot!.documents {
                
                print(deckDocument)
                
                FirebaseModel.getCards(reference: deckDocument.reference) { cardsQuerySnapshot, error in
                    if let error = error {
                        print("Error getting cards subcollection: \(error)")
                        return;
                    }
                    var cards = [Card]()
                    
                    for cardDocument in cardsQuerySnapshot!.documents {
                        let front = cardDocument.data()["front"] as? String ?? ""
                        let back = cardDocument.data()["back"] as? String ?? ""
                        let interval = cardDocument.data()["interval"] as? Int ?? 0
                        let createdAt = cardDocument.data()["createdAt"] as? Date ?? Date()
                        //let due = cardDocument.data()["due"] as? Date ?? Date()
                        //Handling firebase timestamp
                        var due: Date
                        if let timestamp = cardDocument.data()["due"] as? Timestamp {
                            due = timestamp.dateValue()
                            // use the date object as needed
                        } else {
                           due = Date() // use current date as default value
                        }
        
                        let card = Card(front: front, back: back, createdAt: createdAt, interval: interval, due: due, id: cardDocument.documentID)
                        cards.append(card)
                    }
                    
                    let deck = Deck(deckName: deckDocument.documentID, cards: cards)
                    self.decks.append(deck)
                }
                
            }
            
        }
    
    }
    func handleAddToDeck(front: String, back: String) -> String {
        var documentID: String = ""
        if self.selectedDeck.deckName != "" {
            let uid = FirebaseModel.getCurrentUser()
            var ref: DocumentReference? = nil
            ref = db.collection("flashcards").document(uid).collection("decks").document(self.selectedDeck.deckName).collection("cards").addDocument(data: [
                "front": front,
                "back": back,
                "interval": 0,
                "due": Date()
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    documentID = ref!.documentID
                    //print("Document added with ID: \(documentID)")
                    let newCard = Card(front: front, back: back, createdAt: Date(), interval: 0, due: Date(), id: documentID)
                    self.selectedDeck.cards?.append(newCard)
                    
                    if let deckIndex = self.decks.firstIndex(where: { $0.deckName == self.selectedDeck.deckName }){
                        self.decks[deckIndex].cards?.append(newCard)
                    }
                }
            }
        }
        return documentID
    }
    func handleDeleteDeck() {
        let uid = FirebaseModel.getCurrentUser()
        
        let subcollectionRef = db.collection("flashcards").document(uid).collection("decks").document(self.selectedDeck.deckName).collection("cards")
        subcollectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
                self.db.collection("flashcards").document(uid).collection("decks").document(self.selectedDeck.deckName).delete(){ err in
                    if let err = err{
                        print("Error while deleting deck \(err)")
                    }else{
                        let newDecks = self.decks.filter { deck in
                            return deck.deckName != self.selectedDeck.deckName
                        }
                        self.decks = newDecks
                    }
                }
            }
        }
    }
}
