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
    
    private func convertCardToDictionary(_ card: Card) -> [String: Any]? {
        let encoder = JSONEncoder()
        
        // Set the date encoding strategy to .iso8601 or .secondsSince1970 depending on your preference
        encoder.dateEncodingStrategy = .iso8601  // You can also use .millisecondsSince1970 if needed
        
        // Convert the `Card` to JSON data
        guard let jsonData = try? encoder.encode(card) else {
            return nil
        }
        
        // Convert JSON data to a dictionary
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            return jsonObject as? [String: Any]
        } catch {
            print("Error converting to dictionary: \(error)")
            return nil
        }
    }
    
    func updateCard(deckName: String, updatedCard: Card, completion: @escaping (Card?) -> Void) {
        
        UserModel.getToken{ token, error in
            
            guard error == nil else {
                return;
            }
            let urlString = "\(STATIC.API_ROOT)/flashcards/decks/cards"
            
            if let url = URL(string: urlString){
                var request = URLRequest(url: url)
                request.httpMethod = "PATCH"
                request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let json: [String: Any] = ["deckName": deckName, "card": self.convertCardToDictionary(updatedCard)!]
                request.httpBody = try? JSONSerialization.data(withJSONObject: json)

                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let err = error {
                        completion(nil);
                        print("Error while sending request: \(err)")
                        return
                    }

                    print((response as? HTTPURLResponse)!.statusCode)
                    guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                        completion(nil);
                        print("Error while receiving response")
                        return
                    }
                    
                    //Successfull Request
                    completion(updatedCard);
                }
                task.resume()
            }
        }
    }
    
    func deleteCard(_ deckName: String, _ cardId: String, completion: @escaping (Bool) -> Void) {
        
        UserModel.getToken{ token, error in
            
            guard error == nil else {
                return;
            }
            let urlString = "\(STATIC.API_ROOT)/flashcards/decks/cards"
            
            if let url = URL(string: urlString){
                var request = URLRequest(url: url)
                request.httpMethod = "DELETE"
                request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let json: [String: Any] = ["deckName": deckName, "id": cardId]
                request.httpBody = try? JSONSerialization.data(withJSONObject: json)

                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let err = error {
                        completion(false);
                        print("Error while sending request: \(err)")
                        return
                    }

                    print((response as? HTTPURLResponse)!.statusCode)
                    guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                        completion(false);
                        print("Error while receiving response")
                        return
                    }
                    
                    //Successfull Request
                    completion(true);
                }
                task.resume()
            }
            
        }
        
    }
    
}
