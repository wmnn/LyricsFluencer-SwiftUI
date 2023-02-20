//
//  ApiManager.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 19.02.23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AppBrain: ObservableObject{
    @Published var isShazamLoading = false
    @Published var targetLanguage = LanguageModel(language: "None", name: "Undefined")
    @Published var isQuickSearchLoading = false
    @Published var lyricsModel = LyricsModel()
    @Published var isTrialExpired = false
    @Published var searchQuery: String = ""
    @Published var isLoggedOut = false
    @Published var isLyrics = false
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    
    
    
    func handleTrial(){
        if let subscriptionPlan = defaults.string(forKey: "subscriptionPlan"){
            if subscriptionPlan == "free" {
                if let requests = defaults.string(forKey: "requests"){
                    if Int(requests) ?? 99 > 20 {
                        self.isTrialExpired = true
                        print("isTrialExpired? \(String(isTrialExpired))")
                    }
                }
            }
        }
    }
    func handleDeleteLocalStorage(){
        UserDefaults.standard.removeObject(forKey: "subscriptionPlan")
        UserDefaults.standard.removeObject(forKey: "defaultLanguage")
        UserDefaults.standard.removeObject(forKey: "defaultLanguageName")
        UserDefaults.standard.removeObject(forKey: "requests")
    }

}
