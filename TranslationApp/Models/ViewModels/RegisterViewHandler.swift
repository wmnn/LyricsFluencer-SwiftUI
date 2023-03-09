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
    var appBrain: AppBrain?
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isSignUpLoading = false
    
    func register(){
        self.isSignUpLoading = true
        Auth.auth().createUser(withEmail: self.email, password: self.password) { authResult, error in
            if let e = error{
                print(e.localizedDescription)
            }else{
                //Adding User to db
                let uid = self.appBrain!.getCurrentUser()
                let data: [String: Any] = ["subscriptionPlan": "free"]
                self.db.collection("users").document(uid).setData(data, merge: true)
                //Redirecting
                self.defaults.set("free", forKey: "subscriptionPlan") //This is set here because also premium user can be on the DefaultLanguageView
                self.appBrain!.user.subscriptionPlan = "free"
                self.appBrain!.path.append("DefaultLanguage")
            }
        }
        self.isSignUpLoading = false
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
