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
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoginLoading = false
    
    func login(email: String, password: String, appBrain: AppBrain){
        self.isLoginLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard let user = result?.user, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                self.isLoginLoading = false
                return
            }
            self.fetchingUserData(user.uid, appBrain: appBrain)
        }
    }
    func fetchingUserData(_ uid: String, appBrain: AppBrain){
            db.collection("users").document(uid).getDocument { (document, error) in
                if let document = document, document.exists {
                    let subscriptionPlan = document.get("subscriptionPlan") as? String ?? "none"
                    self.defaults.set(subscriptionPlan, forKey: "subscriptionPlan")
                    
                    if let requests = document.get("requests") as? Int{
                        self.defaults.set(requests, forKey: "requests")
                        appBrain.handleTrial()
                    }
                    if let defaultLanguage = document.get("defaultLanguage") as? String{
                        self.defaults.set(defaultLanguage, forKey: "defaultLanguage")
                        appBrain.targetLanguage.language = defaultLanguage
                        
                        let defaultLanguageName = appBrain.getLanguageName(defaultLanguage)
                        self.defaults.set(defaultLanguageName, forKey: "defaultLanguageName")
                        appBrain.targetLanguage.name = defaultLanguageName!
                    }
                    
                    DispatchQueue.main.async {
                        appBrain.fetchingDecks()
                        self.isLoginLoading = false
                        self.handleLoginNavigation(appBrain: appBrain)
                    }
                } else {
                    //print("Document does not exist")
                    //Navigate to set defaultLanguage
                }
            }
    }
    
    func handleLoginNavigation(appBrain: AppBrain){
        let subscriptionPlan = defaults.string(forKey: "subscriptionPlan")
        if subscriptionPlan != nil{
            if(subscriptionPlan == "none"){
                appBrain.path.append("DefaultLanguage")
            }else{
                appBrain.path.append("Home")
            }
        }else{
                appBrain.path.append("DefaultLanguage")
        }
    }
    
}
