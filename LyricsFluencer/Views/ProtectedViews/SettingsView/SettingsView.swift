//
//  SettingsView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 07.03.23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct SettingsView: View {
    
    @EnvironmentObject var appBrain: AppContext
    @EnvironmentObject var songContext: SongContext
    @EnvironmentObject var userContext: UserContext
    @StateObject var settingsViewController: SettingsViewController = SettingsViewController()
    
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            VStack{
                
                //Set learned Language
                SomeHeadline(text: "What language do you learn?", fontSize: 28)
                LanguageMenuView(
                    settingsViewController: self.settingsViewController,
                    buttonText: "Learned Language:",
                    type: LanguageMenuViewType.learnedLanguage
                )
                
                //Set Native language
                SomeHeadline(text: "What is your native Language?", fontSize: 28)
                LanguageMenuView(
                    settingsViewController: self.settingsViewController,
                    buttonText: "Native Language:",
                    type: LanguageMenuViewType.nativeLanguage
                )
            
                Spacer()
                SomeButton(text: "Save Settings") {
                    settingsViewController.updateSettings()
                }
                
                //Delete Account
                DeleteAccountButton(isDeleteAccountModalPresented: self.$settingsViewController.isDeleteAccountModalPresented
                )
                
                
            }
            
            if settingsViewController.isDeleteAccountModalPresented{
                
                DeleteAccountModal(isDeleteAccountModalPresented: $settingsViewController.isDeleteAccountModalPresented)
            }
            
        }
        .onAppear{
            
            self.settingsViewController.appContext = self.appBrain
            self.settingsViewController.userContext = self.userContext
            self.settingsViewController.updateState(user: userContext.user!)
            
        }

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

