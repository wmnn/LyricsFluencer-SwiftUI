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

struct UserModel{
    
    static let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    
    static func getCurrentUserId() -> String{
        guard let uid = Auth.auth().currentUser?.uid else{
            print("User not found")
            return ""
        }
        return uid
    }
    
    func login(email: String, password: String, completion: @escaping (User?, Error?) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            guard error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                completion(nil, error)
                return
            }
            
            self.getCurrentUser{ user, error in
                
                guard user != nil, error == nil else {
                    print(error?.localizedDescription ?? "Unknown error")
                    return
                }
                
                completion(user, nil)
                
            }
        }
        
    }
    
    public func getCurrentUser(completion: @escaping (User?, Error?) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No logged in user")
            completion(nil, NSError())
            return;
        }
        
        UserModel.db.collection("users").document(uid).getDocument { (document, error) in
            
            guard document != nil && document!.exists else {
                
                completion(nil, error)
                return;
            }
            
            var user = User(id: document!.documentID)
            print(user.id)
            // user.subscriptionPlan = document!.get("subscriptionPlan") as? String
            user.nativeLanguage = document!.get("nativeLanguage") as? String
            user.learnedLanguage = document!.get("learnedLanguage") as? String
            
            LocalStorageModel.updateUser(user: user)
            completion(user, nil)
        }
    }
    
    func register(email: String, password: String, completion: @escaping (User?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                completion(nil, NSError())
                return
            }
            
            //Adding User to db
            let uid = UserModel.getCurrentUserId()
            let user = User(id: uid);
            completion(user, nil)
        }
    }
    
    func updateSettings(nativeLanguage: String, learnedLanguage: String, completion: @escaping (User?, Error?) -> Void) {
        
        let data: [String: Any] = ["nativeLanguage": nativeLanguage, "learnedLanguage" : learnedLanguage]
        
        //Save to firebase
        UserModel.db.collection("users").document(UserModel.getCurrentUserId()).setData(data, merge: true)
        
        //Save into local Storage
        LocalStorageModel.setValue(for: "nativeLanguage", value: nativeLanguage)
        LocalStorageModel.setValue(for: "learnedLanguage", value: learnedLanguage)
        
        //Adapt changes to the app
        getCurrentUser { user, error in
            guard user != nil, error == nil else {
                completion(nil, error)
                return;
            }
            completion(user, nil)
        }
        
    }
    
    func logout(completion: @escaping (Error?) -> Void) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            LocalStorageModel.removeData()
            completion(nil)
        } catch let error as NSError {
            print("Error signing out: %@", error)
            completion(error)
        }
    }

    func deleteUser(completion: @escaping (Error?) -> Void) {
        
            let currentUser = Auth.auth().currentUser
            currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                
                if let error = error {
                    print(error)
                    completion(error);
                    return;
                }
                
                let urlString = "\(STATIC.API_ROOT)/payment/account"
                if let url = URL(string: urlString) {
                    
                    let json: [String: String] = ["token": idToken ?? ""]
                    var req = URLRequest(url: url)
                    req.httpMethod = "DELETE"
                    req.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    req.httpBody = try? JSONSerialization.data(withJSONObject: json)
                    
                    let task = URLSession.shared.dataTask(with: req) { data, response, error in
                        
                        if let err = error {
                            print("Error while sending request: \(err), delete user inside user model")
                            completion(err)
                            return
                        }
                        
                        guard let data = data, let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                            print("Error while receiving response, delete user inside user model response code")
                            completion(NSError())
                            return
                        }
                        
            
                        if let res: DeleteAccountResponse = AppContext.parseData(data: data, dataModel: DeleteAccountResponse.self){
                            if res.status != 200 {
                                print("Error, status != 200")
                                completion(NSError())
                                return;
                            }
                            completion(nil)
                        }
                    }
                    task.resume()
                }
            }
    }
}
