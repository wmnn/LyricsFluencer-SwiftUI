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
    
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    @EnvironmentObject var appBrain: AppContext
    @EnvironmentObject var songContext: SongContext
    @EnvironmentObject var userContext: UserContext
    @State var nativeLanguage = Language(language: "None")
    @State var learnedLanguage = Language(language: "None")
    @State var isDeleteAccountModalPresented = false
    
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            VStack{
                //Set learned Language
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
                SomeButton(text: "Save Settings") {
                    self.userContext.updateSettings(nativeLanguage: self.nativeLanguage.language, learnedLanguage: self.learnedLanguage.language){ user, error in
                        
                        guard user != nil, error == nil else {
                            return;
                        }
                        
                        DispatchQueue.main.async{
                            self.appBrain.path.removeLast()
                        }
                    }
                }
                
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
                
                
            }
            
            if isDeleteAccountModalPresented{
                ZStack{
                    VisualEffectView(effect: UIBlurEffect(style: .dark))
                    Color.black.opacity(0.4).ignoresSafeArea(.all)
                }
                .edgesIgnoringSafeArea(.all)
            }
            if isDeleteAccountModalPresented{
                DeleteAccountModal(isDeleteAccountModalPresented: $isDeleteAccountModalPresented)
            }
            
        }
        .onAppear{
            /*
            self.nativeLanguage.language = STATIC.languages.first(where: { Language in
                return Language.language == self.songContext.user!.nativeLanguage
            })
            self.learnedLanguage.language = STATIC.languages.first(where: { Language in
                return Language.language == self.songContext.user!.learnedLanguage
            })*/
        }

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


struct DeleteAccountModal: View{
    
    let db = Firestore.firestore()
    @EnvironmentObject var appContext: AppContext
    @EnvironmentObject var userContext: UserContext
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
                        userContext.handleDelete(appContext: appContext)
                    }, textColor: Color.red)
                    
                    
                }
            }
        }
    }    
}

