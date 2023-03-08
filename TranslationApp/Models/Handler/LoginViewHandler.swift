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
                    let subscriptionPlan = document.get("subscriptionPlan") as? String ?? "none"
                    self.defaults.set(subscriptionPlan, forKey: "subscriptionPlan")
                    
                    if let requests = document.get("requests") as? Int{
                        self.defaults.set(requests, forKey: "requests")
                        self.appBrain!.handleTrial()
                    }
                    if let defaultLanguage = document.get("defaultLanguage") as? String{
                        self.defaults.set(defaultLanguage, forKey: "defaultLanguage")
                        self.appBrain!.targetLanguage.language = defaultLanguage
                        
                        let defaultLanguageName = self.appBrain!.getLanguageName(defaultLanguage)
                        self.defaults.set(defaultLanguageName, forKey: "defaultLanguageName")
                        self.appBrain!.targetLanguage.name = defaultLanguageName!
                    }
                    
                    DispatchQueue.main.async {
                        self.appBrain!.fetchingDecks()
                        self.isLoginLoading = false
                        self.handleLoginNavigation()
                    }
                } else {
                    //print("Document does not exist")
                    //Navigate to set defaultLanguage
                }
            }
    }
    
    func handleLoginNavigation(){
        let subscriptionPlan = defaults.string(forKey: "subscriptionPlan")
        let defaultLanguage = defaults.string(forKey: "defaultLanguage")
        if subscriptionPlan != nil && defaultLanguage != nil{
            self.appBrain!.path.append("Home")
        }else{
            self.appBrain!.path.append("DefaultLanguage")
        }
    }
    
}
