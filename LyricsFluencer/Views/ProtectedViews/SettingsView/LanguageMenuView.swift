//
//  LanguageMenuView.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 06.11.24.
//
import SwiftUI

enum LanguageMenuViewType {
    case learnedLanguage
    case nativeLanguage
}
struct LanguageMenuView: View {
    
    @StateObject var settingsViewController: SettingsViewController
    var buttonText: String
    var type: LanguageMenuViewType
    
    
    var body: some View {
        
        Menu{
            ForEach(0..<STATIC.languages.count, id: \.self) { idx in
                SomeButton(text: STATIC.languages[idx].name!) {
                    
                    if self.type == LanguageMenuViewType.learnedLanguage {
                        self.settingsViewController.learnedLanguage = Language(language: STATIC.languages[idx].language, name: LanguageUtil.getLanguageName(STATIC.languages[idx].language))
                    } else {
                        self.settingsViewController.nativeLanguage = Language(language: STATIC.languages[idx].language, name: LanguageUtil.getLanguageName(STATIC.languages[idx].language))
                    }
                    
                }
            }
        } label: {
            if self.type == LanguageMenuViewType.learnedLanguage {
                SomeButton(text: "\(buttonText) \(self.settingsViewController.learnedLanguage?.name ?? "")") {
                    
                }
            } else {
                SomeButton(text: "\(buttonText) \(self.settingsViewController.nativeLanguage?.name ?? "")") {
                }
            }
            
        }
        
    }
}
