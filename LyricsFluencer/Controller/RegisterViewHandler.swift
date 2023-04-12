//
//  RegisterViewHandler.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 12.04.23.
//

import Foundation
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
                let uid = FirebaseModel.getCurrentUser()
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
}
