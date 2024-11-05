//
//  LoginViewController.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 25.02.23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase

class LoginViewController: ObservableObject {
    
    let defaults = UserDefaults.standard
    let db = Firestore.firestore()
    var appBrain: AppContext?
    var deckContext: DeckContext!
    var userContext: UserContext!
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoginLoading = false
    
    func login(email: String, password: String){
        self.isLoginLoading = true
        userContext.login(email: email, password: password){ user, error in
            guard user != nil, error == nil else {
                self.isLoginLoading = false
                return
            }
            self.isLoginLoading = false
            
            if user!.learnedLanguage != nil {
                self.appBrain!.path.append("Home")
            } else {
                self.appBrain!.path.append("DefaultLanguage")
            }
        }
    }
}
