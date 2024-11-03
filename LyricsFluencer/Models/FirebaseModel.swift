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

struct FirebaseModel{
    static let db = Firestore.firestore()
    
    static func getCurrentUser() -> String{
        guard let uid = Auth.auth().currentUser?.uid else{
            print("User not found")
            return ""
        }
        return uid
    }

}
