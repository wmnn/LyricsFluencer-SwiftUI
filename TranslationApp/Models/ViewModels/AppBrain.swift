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
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    @Published var path: NavigationPath = NavigationPath()
    @Published var user = User()
    @Published var lyricsModel = Lyrics()

    func getCurrentUser() -> String{
        guard let uid = Auth.auth().currentUser?.uid else{
            print("User not found")
            return ""
        }
        return uid
    }
    
    func handleTrial(){
        let subscriptionPlan = defaults.string(forKey: "subscriptionPlan")
        let subscriptionStatus = defaults.string(forKey: "subscriptionStatus")
      
        if subscriptionPlan == "free" || subscriptionStatus == "EXPIRED" {
            let requests = defaults.string(forKey: "requests")
            if Int(requests ?? "") ?? 99 > 100 {
                self.user.isTrialExpired = true
            }else{
                self.user.isTrialExpired = false
            }
        }else{
            self.user.isTrialExpired = false
        }
    }
    func handleDeleteLocalStorage(){
        defaults.removeObject(forKey: "subscriptionPlan")
        defaults.removeObject(forKey: "subscriptionStatus")
        defaults.removeObject(forKey: "defaultLanguage")
        defaults.removeObject(forKey: "requests")
        self.user.isSubscriptionPlanChecked = false
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
            defaults.set((Int(requests)! + 1), forKey: "requests")
            self.user.requests = Int(requests)! + 1
            DispatchQueue.main.async {
                self.handleTrial()
            }
        }
    }

    func handleAddToDeck(front: String, back: String) -> String{
        var documentID: String = ""
        if self.user.selectedDeck.deckName != "" {
            let uid = self.getCurrentUser()
            var ref: DocumentReference? = nil
            ref = db.collection("flashcards").document(uid).collection("decks").document(self.user.selectedDeck.deckName).collection("cards").addDocument(data: [
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
                    self.user.selectedDeck.cards?.append(newCard)
                    
                    if let deckIndex = self.user.decks.firstIndex(where: { $0.deckName == self.user.selectedDeck.deckName }){
                        self.user.decks[deckIndex].cards?.append(newCard)
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
        self.user.decks.append(deck)
    }
    func fetchingDecks(){
        self.user.decks = []
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
                                self.user.decks.append(deck)
                            }
                        }
                    }
                }
        }
    }
   
    
    func checkSubscriptionPlan(){
        if !self.user.isSubscriptionPlanChecked{
            let currentUser = Auth.auth().currentUser
            currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    // Handle error
                    print(error)
                    return;
                }
                let urlString = "\(STATIC.API_ROOT)/payment/plan?token=\(idToken ?? "")"
                if let url = URL(string: urlString){
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        if let err = error {
                            print("Error while sending request: \(err)")
                            return
                        }
                        
                        guard let data = data, let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                            print("Error while receiving response")
                            return
                        }
                        //print("Success: \(data)")
                        if let planApiData: PlanApiData = self.parsePlanApiJSON(data){
                            DispatchQueue.main.async {
                                Task {
                                    //print(planApiData)
                                    self.user.isSubscriptionPlanChecked = true
                                    self.defaults.set(planApiData.subscriptionPlan, forKey: "subscriptionPlan")
                                    self.defaults.set(planApiData.subscriptionStatus ?? "", forKey: "subscriptionStatus")
                                    self.handleTrial()
                                }
                            }
                        }
                    }
                    task.resume()
                }
                
            }
        }
        
        
    }
    func parsePlanApiJSON(_ planApiData: Data) -> PlanApiData? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(PlanApiData.self, from: planApiData)
            return decodedData
        }catch {
            print(error)
            return nil
        }
    }
}
