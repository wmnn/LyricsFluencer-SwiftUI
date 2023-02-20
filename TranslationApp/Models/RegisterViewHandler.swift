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
    @Published var isLoggedIn = false
    @Published var isRegistered = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isSignUpLoading = false
}
