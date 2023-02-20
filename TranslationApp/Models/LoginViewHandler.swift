//
//  LoginViewHandler.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 19.02.23.
//

import Foundation
import Firebase
import FirebaseFirestore

class LoginViewHandler: ObservableObject{
    let defaults = UserDefaults.standard
    let db = Firestore.firestore()
    var apiManager = AppBrain()
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn = false
    @Published var isNotSetUp = false
    @Published var isLoading = false
    
    func login(){
        self.isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard let user = result?.user, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                self.isLoading = false
                return
            }
            self.loadUserData(user.uid)
        }
    }
    func loadUserData(_ uid: String){
            db.collection("users").document(uid).getDocument { (document, error) in
                if let document = document, document.exists {
                    
                    let subscriptionPlan = document.get("subscriptionPlan") as? String ?? "none"
                    self.defaults.set(subscriptionPlan, forKey: "subscriptionPlan")
                    
                    if let requests = document.get("requests") as? Int{
                        self.defaults.set(requests, forKey: "requests")
                        if Int(requests) > 20 {
                            self.apiManager.isTrialExpired = true
                        }
                    }
                    if let defaultLanguage = document.get("defaultLanguage") as? String{
                        self.defaults.set(defaultLanguage, forKey: "defaultLanguage")
                        self.apiManager.targetLanguage.language = defaultLanguage
                        
                        let defaultLanguageName = self.getLanguageName(defaultLanguage)
                        self.defaults.set(defaultLanguageName, forKey: "defaultLanguageName")
                        self.apiManager.targetLanguage.name = defaultLanguageName!
                    }
                } else {
                    print("Document does not exist")
                }
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.handleNavigation()
                }
            }
    }
    func getLanguageName(_ languageCode: String) -> String?{
        for language in STATIC.languages {
            if language.language == languageCode {
                return language.name
            }
        }
        return nil
    }
    func getCurrentUser() -> String{
        guard let uid = Auth.auth().currentUser?.uid else{
            print("User not found")
            return ""
        }
        return uid
    }
    func handleNavigation(){
        let subscriptionPlan = defaults.string(forKey: "subscriptionPlan")
        if subscriptionPlan != nil{
            if(subscriptionPlan == "none"){
                self.isNotSetUp = true
            }else{
                self.isLoggedIn = true
            }
        }else{
            self.isNotSetUp = true
        }
    }
    
}
