//
//  SetDefaultLanguageView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 14.02.23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct DefaultLanguageView: View {
    
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    @State var nativeLanguage = Language(language: "None")
    @State var learnedLanguage = Language(language: "None")
    @EnvironmentObject var appBrain: AppContext
    @EnvironmentObject var userContext: UserContext
    
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            VStack{
                Spacer()
                SomeHeadline(text: "What language do you learn?", fontSize: 28)
                Menu{
                    ForEach(0..<STATIC.languages.count, id: \.self) { index in
                        SomeButton(text: STATIC.languages[index].name!) {
                            self.learnedLanguage.language = STATIC.languages[index].language
                        }
                    }
                } label: {
                    SomeButton(text: "Learned Language: \(self.appBrain.getLanguageName(learnedLanguage.language) ?? "")") {
                        
                    }
                }
                //Set Native language
                SomeHeadline(text: "What is your native Language?", fontSize: 28)
                Menu{
                    ForEach(0..<STATIC.languages.count, id: \.self) { index in
                        SomeButton(text: STATIC.languages[index].name!) {
                            self.nativeLanguage.language = STATIC.languages[index].language
                        }
                    }
                } label: {
                    SomeButton(text: "Your Language: \(self.appBrain.getLanguageName(nativeLanguage.language) ?? "")") {
                        
                    }
                }
                Spacer()
                SomeButton(text: "Save your choices") {
                    userContext.updateSettings(nativeLanguage: nativeLanguage.language, learnedLanguage: learnedLanguage.language){ user, error in
                        
                        guard user != nil, error == nil else {
                            return;
                        }
                        //Go back to Home View
                        self.appBrain.path.append("Home")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct SetDefaultLanguageView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultLanguageView()
    }
}
