//
//  SettingsViewController.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 06.11.24.
//
import Foundation

import SwiftUI

class SettingsViewController: ObservableObject {
    
    @Published var nativeLanguage: Language?
    @Published var learnedLanguage: Language?
    @Published var isDeleteAccountModalPresented = false
    @Published var isErrorModalShown = false
    var errorMessage = ""
    var userContext: UserContext?
    var appContext: AppContext?
    
    func updateSettings() {
        
        guard self.nativeLanguage != nil && self.learnedLanguage != nil else {
            
            return;
        }
        self.userContext!.updateSettings(
            nativeLanguage: self.nativeLanguage!.language,
            learnedLanguage: self.learnedLanguage!.language
        ){ user, error in
            
            guard user != nil, error == nil else {
                return;
            }
            
            DispatchQueue.main.async{
                self.appContext!.resetNavigationPath()
                self.appContext!.navigate(to: Views.Home)
            }
        }
    }
    
    func updateState(user: User) {
        
        guard user.learnedLanguage != nil && user.nativeLanguage != nil else {
            
            return;
        }
        self.learnedLanguage = STATIC.languages.first(where: { Language in
            return Language.language == user.learnedLanguage
        })
        self.nativeLanguage = STATIC.languages.first(where: { Language in
            return Language.language == user.nativeLanguage
        })
        
    }
}
