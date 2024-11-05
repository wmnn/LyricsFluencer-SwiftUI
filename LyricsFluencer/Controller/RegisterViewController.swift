//
//  RegisterViewController.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 12.04.23.
//

import Foundation
import Firebase
import FirebaseFirestore

class RegisterViewController: ObservableObject{
    
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    var userContext: UserContext?
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isSignUpLoading = false
    
    func register(appBrain: AppContext){
        self.isSignUpLoading = true
        userContext?.register(email: email, password: password) { user, error in
            DispatchQueue.main.async {
                appBrain.path.append("DefaultLanguage")
                self.isSignUpLoading = false
            }
        }
    }
}
