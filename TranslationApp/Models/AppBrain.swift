//
//  ApiManager.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 19.02.23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AppBrain: ObservableObject{
    @Published var path: NavigationPath = NavigationPath()
    @Published var isShazamLoading = false
    @Published var targetLanguage = LanguageModel(language: "None", name: "Undefined")
    @Published var isQuickSearchLoading = false
    @Published var lyricsModel = LyricsModel()
    @Published var isTrialExpired = false
    @Published var searchQuery: String = ""
    @Published var isLoggedOut = false
    @Published var isLyrics = false
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    
    //For Flashcards and DeckView
    @Published var decks: [Deck] = []
    @Published var selectedDeck = Deck(deckName: "", cards: [])
    
    func getCurrentUser() -> String{
        guard let uid = Auth.auth().currentUser?.uid else{
            print("User not found")
            return ""
        }
        return uid
    }
    
    func handleTrial(){
        if let subscriptionPlan = defaults.string(forKey: "subscriptionPlan"){
            if subscriptionPlan == "free" {
                if let requests = defaults.string(forKey: "requests"){
                    if Int(requests) ?? 99 > 80 {
                        self.isTrialExpired = true
                        print("isTrialExpired? \(String(isTrialExpired))")
                    }
                }
            }
        }
    }
    func handleDeleteLocalStorage(){
        defaults.removeObject(forKey: "subscriptionPlan")
        defaults.removeObject(forKey: "defaultLanguage")
        defaults.removeObject(forKey: "defaultLanguageName")
        defaults.removeObject(forKey: "requests")
        defaults.removeObject(forKey: "decks")
    }
    func getLanguageName(_ languageCode: String) -> String?{
        for language in STATIC.languages {
            if language.language == languageCode {
                return language.name
            }
        }
        return nil
    }
    func logout(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.handleDeleteLocalStorage()
            self.path = NavigationPath()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    func handleShazam(){
        
    }
    func updateRequestCounter(){
        let uid = self.getCurrentUser()
        let userRef = db.collection("users").document(uid)
        userRef.updateData(["requests": FieldValue.increment(Int64(1))]) { (error) in
            if error == nil {
                print("Updated request counter")
            }else{
                print("not updated")
            }
        }
        if let requests = defaults.string(forKey: "requests"){
            defaults.set((Int(requests) ?? 99) + 1 , forKey: "requests")
            DispatchQueue.main.async {
                self.handleTrial()
            }
        }
    }

    func handleAddToDeck(front: String, back: String) -> String{
        var documentID: String = ""
        if self.selectedDeck.deckName != "" {
            let uid = self.getCurrentUser()
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
                    print("Document added with ID: \(documentID)")
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
    func createDeck(deckName: String){
        let uid = self.getCurrentUser()
        let deckName = deckName
        
        db.collection("flashcards").document(uid).getDocument { (document, error) in
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
    func fetchingDecks(){
        self.decks = []
        let uid = self.getCurrentUser()
            db.collection("flashcards").document(uid).collection("decks").getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print("Error getting subcollection: \(error)")
                } else {
                    for deckDocument in querySnapshot!.documents {
                        deckDocument.reference.collection("cards").getDocuments { (cardsQuerySnapshot, error) in
                            if let error = error {
                                print("Error getting cards subcollection: \(error)")
                            } else {
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
        }
    }
}
