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
