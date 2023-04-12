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
    @EnvironmentObject var appBrain: AppBrain
    
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
                    saveSettings()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    func saveSettings(){
        let uid = FirebaseModel.getCurrentUser()
        let data: [String: Any] = ["nativeLanguage": self.nativeLanguage.language, "learnedLanguage" : self.learnedLanguage.language, "requests" : 0]
        //Save to firebase
        db.collection("users").document(uid).setData(data, merge: true)
        //Save into local Storage
        LocaleStorage.setValue(for: "nativeLanguage", value: self.nativeLanguage.language)
        LocaleStorage.setValue(for: "learnedLanguage", value: self.learnedLanguage.language)
        LocaleStorage.setValue(for: "requests", value: 0)
        LocaleStorage.setValue(for: "subscriptionPlan", value: "free")
        
        //Adapt changes to the app
        self.appBrain.user.nativeLanguage.language = self.nativeLanguage.language
        self.appBrain.user.learnedLanguage.language = self.learnedLanguage.language
        self.appBrain.user.requests = 0
        self.appBrain.user.subscriptionPlan = "free"
        //Go back to Home View
        self.appBrain.path.append("Home")
    }/*
    func handleData(_ nativeLanguage: Language){
        let uid = FirebaseModel.getCurrentUser()
        if uid != ""{
            //Adding data to db
            let data: [String: Any] = ["nativeLanguage": nativeLanguage.language, "requests": 0]
            db.collection("users").document(uid).setData(data, merge: true)
            //Saving data locally
            defaults.set(nativeLanguage.language, forKey: "defaultLanguage")
            defaults.set(0, forKey: "requests")
            self.appBrain.user.nativeLanguage.language = nativeLanguage.language
            self.appBrain.user.requests = 0
            //Redirect
            appBrain.path.append("Home")
        }
    }*/
}

struct SetDefaultLanguageView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultLanguageView()
    }
}
