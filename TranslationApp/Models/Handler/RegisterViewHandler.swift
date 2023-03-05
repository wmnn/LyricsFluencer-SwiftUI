//
//  RegisterViewHandler.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 19.02.23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class RegisterViewHandler: ObservableObject{
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isSignUpLoading = false
    
    func register(appBrain: AppBrain){
        self.isSignUpLoading = true
        Auth.auth().createUser(withEmail: self.email, password: self.password) { authResult, error in
            if let e = error{
                print(e.localizedDescription)
            }else{
                //Adding User to db
                let uid = appBrain.getCurrentUser()
                let data: [String: Any] = ["subscriptionPlan": "free"]
                self.db.collection("users").document(uid).setData(data, merge: true)
                //Saving locally subscriotionPlan
                self.defaults.set("free", forKey: "subscriptionPlan")
                //Redirecting
                appBrain.path.append("DefaultLanguage")
            }
        }
        self.isSignUpLoading = false
    }
    
    func handleAutomaticNavigation(appBrain: AppBrain){
        if Auth.auth().currentUser != nil {
            let defaultLanguage = defaults.string(forKey: "defaultLanguage")
            let defaultLanguageName = defaults.string(forKey: "defaultLanguageName")
            let requests = defaults.string(forKey: "requests")
            let subscriptionPlan = defaults.string(forKey: "subscriptionPlan")
            
            if defaultLanguage != nil, defaultLanguageName != nil, requests != nil, subscriptionPlan != nil/*, decks != nil*/{
                appBrain.targetLanguage.language = defaultLanguage!
                appBrain.targetLanguage.name = defaultLanguageName!
                //appBrain.decks = decks!
                DispatchQueue.main.async {
                    appBrain.fetchingDecks()
                }
                appBrain.path.append("Home")
            }else{
                appBrain.path.append("DefaultLanguage")
            }
        }else{
            appBrain.handleDeleteLocalStorage()
        }
    }
}
