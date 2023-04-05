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
    @State var targetLanguage = Language(language: "None"/*, name: "Undefined"*/)
    @State var isDeleteAccountModalPresented = false
    
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            VStack{
                Menu{
                    ForEach(0..<STATIC.languages.count, id: \.self) { index in
                        SomeButton(text: STATIC.languages[index].name!) {
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
                /*
                //Delete Account
                Button {
                    self.isDeleteAccountModalPresented = true
                } label: {
                    HStack{
                        Text("Delete Account")

                    }
                    .bold()
                    .font(.system(size:24))
                    .frame(width: 300, height: 20, alignment: .center)
                    .foregroundColor(Color.red)
                    .padding()
                    .background {
                        Color("primaryColor")
                    }
                    .cornerRadius(18)
                }
                 */

            }
            /*
            if isDeleteAccountModalPresented{
                ZStack{
                    VisualEffectView(effect: UIBlurEffect(style: .dark))
                    Color.black.opacity(0.4).ignoresSafeArea(.all)
                }
                .edgesIgnoringSafeArea(.all)
            }
            if isDeleteAccountModalPresented{
                DeleteAccountModal(isDeleteAccountModalPresented: $isDeleteAccountModalPresented)
            }*/
            
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
        let uid = FirebaseModel.getCurrentUser()
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
/*

struct DeleteAccountModal: View{
    let db = Firestore.firestore()
    @EnvironmentObject var appBrain: AppBrain
    @Binding var isDeleteAccountModalPresented: Bool
    
    var body: some View{
        ZStack{
            VStack{
                TextWithIcon(text: "Delete Account?", systemName: "")
                HStack{
                    
                    SomeSmallButton(text: "Cancel", buttonAction: {
                        isDeleteAccountModalPresented = false
                     
                    }, textColor: Color.green)
                    
                    SomeSmallButton(text: "Delete", buttonAction: {
                        isDeleteAccountModalPresented = false
                        handleDeleteAccount()
                    }, textColor: Color.red)
                    
                    
                }
            }
        }
    }
    func handleDeleteAccount(){
        
    }
}*/
