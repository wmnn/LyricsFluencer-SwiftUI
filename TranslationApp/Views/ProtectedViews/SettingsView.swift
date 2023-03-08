//
//  SettingsView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 07.03.23.
//

import SwiftUI
import FirebaseFirestore

struct SettingsView: View {
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    @EnvironmentObject var appBrain: AppBrain
    @State var targetLanguage = LanguageModel(language: "None", name: "Undefined")
    
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            VStack{
                Menu{
                    ForEach(0..<STATIC.languages.count, id: \.self) { index in
                        SomeButton(text: STATIC.languages[index].name) {
                            self.targetLanguage.language = STATIC.languages[index].language
                            self.targetLanguage.name = STATIC.languages[index].name
                        }
                    }
                } label: {
                    SomeButton(text: "Default language: \(targetLanguage.name)") {
                        
                    }
                }
                SomeButton(text: "Save choosen language") {
                    self.saveDefaultLanguage()
                }

            }
            
        }
        .onAppear{
            fetchLocaleStorage()
        }
    }
    func fetchLocaleStorage(){
        let dln = defaults.string(forKey: "defaultLanguageName")
        let dl = defaults.string(forKey: "defaultLanguage")
        if dln != nil && dl != nil{
            self.targetLanguage.language = dl!
            self.targetLanguage.name = dln!
        }
    }
    func saveDefaultLanguage(){
        let uid = self.appBrain.getCurrentUser()
        let data: [String: Any] = ["defaultLanguage": self.targetLanguage.language]
        db.collection("users").document(uid).setData(data, merge: true)
        defaults.set(self.targetLanguage.language, forKey: "defaultLanguage")
        defaults.set(self.targetLanguage.name, forKey: "defaultLanguageName")
        self.appBrain.targetLanguage.language = self.targetLanguage.language
        self.appBrain.targetLanguage.name = self.targetLanguage.name
        self.appBrain.path.removeLast()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
