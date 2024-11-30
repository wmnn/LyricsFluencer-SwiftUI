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

class DeckModel: DeckProtocol {
    
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
    
    func fetchingDecks(completion: @escaping ([Deck]?) -> Void) {
        
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
                        completion(nil);
                        print("Error while sending request: \(err)")
                        return
                    }

                    print((response as? HTTPURLResponse)!.statusCode)
                    guard let data = data, let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                        completion(nil);
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
    
    func handleAddToDeck(front: String, back: String, deckName: String, completion: @escaping (Card?) -> Void) {
        
        UserModel.getToken{ token, error in
            
            guard error == nil else {
                return;
            }
            let urlString = "\(STATIC.API_ROOT)/flashcards/decks/cards"
            
            if let url = URL(string: urlString){
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let json: [String: Any] = ["deckName": deckName, "card": ["front": front, "back": back]]
                request.httpBody = try? JSONSerialization.data(withJSONObject: json)

                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let err = error {
                        completion(nil);
                        print("Error while sending request: \(err)")
                        return
                    }

                    print((response as? HTTPURLResponse)!.statusCode)
                    guard let data = data, let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                        completion(nil);
                        print("Error while receiving response")
                        return
                    }
                    
                    //Successfull Request
                    if let res: CreateCardResponse = AppContext.parseData(data: data, dataModel: CreateCardResponse.self) {
                        completion(res.card);
                    }
                }
                task.resume()
            }
            
        }
    }
    
    func handleDeleteDeck(deckName: String, completion: @escaping (String) -> Void) {
        
        UserModel.getToken{ token, error in
            
            guard error == nil else {
                return;
            }
            let urlString = "\(STATIC.API_ROOT)/flashcards/decks"
            
            if let url = URL(string: urlString){
                var request = URLRequest(url: url)
                request.httpMethod = "DELETE"
                request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let json: [String: String] = ["deckName": deckName]
                request.httpBody = try? JSONSerialization.data(withJSONObject: json)

                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let err = error {
                        completion(deckName);
                        print("Error while sending request: \(err)")
                        return
                    }

                    print((response as? HTTPURLResponse)!.statusCode)
                    guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                        completion(deckName);
                        print("Error while receiving response")
                        return
                    }
                    
                    //Successfull Request
                    completion(deckName);
                }
                task.resume()
            }
            
        }
        
    }
    
}
