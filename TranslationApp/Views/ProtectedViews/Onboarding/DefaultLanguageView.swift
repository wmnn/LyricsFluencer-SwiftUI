//
//  SetDefaultLanguageView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 14.02.23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct DefaultLanguageView: View {
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    @State var targetLanguage = Language(language: "None")
    @EnvironmentObject var appBrain: AppBrain
    
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            VStack{
                Menu{
                    ForEach(0..<STATIC.languages.count, id: \.self) { index in
                        Button {
                            self.targetLanguage.language = STATIC.languages[index].language
                        } label: {
                            Text(STATIC.languages[index].name!)
                        }
                    }
                } label: {
                    Label(
                        title: {Text("Target language: \(self.appBrain.getLanguageName(targetLanguage.language) ?? "")")
                                .font(.system(size:24))
                                .bold()
                                .frame(width: 300, height: 20, alignment: .center)
                                .foregroundColor(Color.white)
                                .padding()
                                .background {
                                    Color("primaryColor")
                                }
                                .cornerRadius(18)
                        },
                        icon: { Image(systemName: "")}
                    )
                    
                }
                SomeButton(text: "Save choosen language") {
                    handleData(targetLanguage)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    func handleData(_ targetLanguage: Language){
        let uid = FirebaseModel.getCurrentUser()
        if uid != ""{
            //Adding data to db
            let data: [String: Any] = ["defaultLanguage": targetLanguage.language, "requests": 0]
            db.collection("users").document(uid).setData(data, merge: true)
            //Saving data locally
            defaults.set(targetLanguage.language, forKey: "defaultLanguage")
            defaults.set(0, forKey: "requests")
            self.appBrain.user.targetLanguage.language = targetLanguage.language
            self.appBrain.user.requests = 0
            //Redirect
            appBrain.path.append("Home")
        }
    }
}

struct SetDefaultLanguageView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultLanguageView()
    }
}
