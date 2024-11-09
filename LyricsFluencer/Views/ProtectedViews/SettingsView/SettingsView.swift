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
    
    @EnvironmentObject var appContext: AppContext
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
            
            if settingsViewController.isErrorModalShown {
                
                ErrorModal(
                    isErrorModalShown: $settingsViewController.isErrorModalShown,
                    message: settingsViewController.errorMessage
                )
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{
            
            self.settingsViewController.appContext = self.appContext
            self.settingsViewController.userContext = self.userContext
            self.settingsViewController.updateState(user: userContext.user!)
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                
                Button {
                    guard self.userContext.user!.nativeLanguage != nil else {
                        
                        self.settingsViewController.isErrorModalShown = true
                        self.settingsViewController.errorMessage = "You haven't selected a native language "
                        return;
                    }
                    
                    guard self.userContext.user!.learnedLanguage != nil else {
                        
                        self.settingsViewController.isErrorModalShown = true
                        self.settingsViewController.errorMessage = "You haven't selected the language you are learning "
                        return;
                    }
            
                    appContext.resetNavigationPath()
                    
                    
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                    }
                }
            }
        }

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

