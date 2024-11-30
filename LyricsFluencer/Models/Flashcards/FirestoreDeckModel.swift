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
        
        UserModel.getToken{ token, error in
            
            guard error == nil else {
                return;
            }
            let urlString = "\(STATIC.API_ROOT)/flashcards/decks"
            
            if let url = URL(string: urlString){
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let json: [String: String] = ["deckName": deckName]
                request.httpBody = try? JSONSerialization.data(withJSONObject: json)

                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let err = error {
                        completion(Deck(deckName: deckName));
                        print("Error while sending request: \(err)")
                        return
                    }

                    print((response as? HTTPURLResponse)!.statusCode)
                    guard let data = data, let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                        completion(Deck(deckName: deckName));
                        print("Error while receiving response")
                        return
                    }
                    
                    //Successfull Request
                    if let res: CreateDeckResponse = AppContext.parseData(data: data, dataModel: CreateDeckResponse.self) {
                        completion(res.deck);
                    }
                }
                task.resume()
            }
            
        }
        
    }
    
    func fetchingDecks(completion: @escaping ([Deck]) -> Void) {
        
        UserModel.getToken{ token, error in
            
            guard error == nil else {
                return;
            }
            let urlString = "\(STATIC.API_ROOT)/flashcards/decks"
            
            if let url = URL(string: urlString){
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let err = error {
                        completion([]);
                        print("Error while sending request: \(err)")
                        return
                    }

                    print((response as? HTTPURLResponse)!.statusCode)
                    guard let data = data, let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                        completion([]);
                        print("Error while receiving response")
                        return
                    }
                    
                    //Successfull Request
                    if let res: GetDecksResponse = AppContext.parseData(data: data, dataModel: GetDecksResponse.self) {
                        print(res.decks);
                        completion(res.decks);
                    }
                }
                task.resume()
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
