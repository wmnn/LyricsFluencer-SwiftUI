//
//  LyricsViewHandler.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 25.02.23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class LoginViewHandler: ObservableObject{
    let defaults = UserDefaults.standard
    let db = Firestore.firestore()
    var appBrain: AppBrain?
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoginLoading = false
    
    func login(email: String, password: String){
        self.isLoginLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard let user = result?.user, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                self.isLoginLoading = false
                return
            }
            self.fetchingUserData(user.uid)
        }
    }
    func fetchingUserData(_ uid: String){
            db.collection("users").document(uid).getDocument { (document, error) in
                if let document = document, document.exists {
                    let subscriptionPlan = document.get("subscriptionPlan") as? String
                    let requests = document.get("requests") as? Int
                    let defaultLanguage = document.get("defaultLanguage") as? String
                    
                    //Saving to local storage
                    self.defaults.set(subscriptionPlan, forKey: "subscriptionPlan")
                    self.defaults.set(requests, forKey: "requests")
                    self.defaults.set(defaultLanguage, forKey: "defaultLanguage")
                    //self.defaults.set(defaultLanguageName, forKey: "defaultLanguageName")
                    self.appBrain!.user.subscriptionPlan = subscriptionPlan
                    self.appBrain!.user.requests = requests
                    self.appBrain!.user.targetLanguage.language = defaultLanguage ?? ""
                    
                    DispatchQueue.main.async {
                        self.appBrain!.fetchingDecks()
                        self.isLoginLoading = false
                        self.handleLoginNavigation()
                        self.appBrain!.handleTrial()
                    }
                } /*else {
                    print("Document does not exist")
                }*/
            }
    }
    
    func handleLoginNavigation(){
        let defaultLanguage = defaults.string(forKey: "defaultLanguage")
        if defaultLanguage != nil{
            self.appBrain!.path.append("Home")
        }else{
            self.appBrain!.path.append("DefaultLanguage")
        }
    }
    func handleAutoLogin(){
        if Auth.auth().currentUser != nil {
            let defaultLanguage = defaults.string(forKey: "defaultLanguage")
            let requests = defaults.string(forKey: "requests")
            let subscriptionPlan = defaults.string(forKey: "subscriptionPlan")
            
            if defaultLanguage != nil, requests != nil, subscriptionPlan != nil/*, decks != nil*/{
                self.appBrain!.user.targetLanguage.language = defaultLanguage!
                self.appBrain!.user.requests = Int(requests!)
                //self.appBrain!.user.targetLanguage.name = appBrain!.getLanguageName(defaultLanguage!) ?? ""
    
                if !self.appBrain!.user.isAutoLogin{
                    DispatchQueue.main.async {
                        self.appBrain!.fetchingDecks()
                    }
                    self.appBrain!.path.append("Home")
                    self.appBrain!.user.isAutoLogin = true
                }
            }else{
                self.appBrain!.path.append("DefaultLanguage")
            }
        }else{
            self.appBrain!.handleDeleteLocalStorage()
        }
    }
    
}
