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
    @State var targetLanguage = LanguageModel(language: "None"/*, name: "Undefined"*/)
    
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            VStack{
                Menu{
                    ForEach(0..<STATIC.languages.count, id: \.self) { index in
                        SomeButton(text: STATIC.languages[index].name) {
                            self.targetLanguage.language = STATIC.languages[index].language
                        }
                    }
                } label: {
                    SomeButton(text: "Default language: \(self.appBrain.getLanguageName(targetLanguage.language) ?? "")") {
                        
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
        let dl = defaults.string(forKey: "defaultLanguage")
        if dl != nil{
            self.targetLanguage.language = dl!
        }
    }
    func saveDefaultLanguage(){
        let uid = self.appBrain.getCurrentUser()
        let data: [String: Any] = ["defaultLanguage": self.targetLanguage.language]
        db.collection("users").document(uid).setData(data, merge: true)
        defaults.set(self.targetLanguage.language, forKey: "defaultLanguage")
        self.appBrain.user.targetLanguage.language = self.targetLanguage.language
        self.appBrain.path.removeLast()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
