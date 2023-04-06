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
    @State var nativeLanguage = Language(language: "None")
    @EnvironmentObject var appBrain: AppBrain
    
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            VStack{
                Menu{
                    ForEach(0..<STATIC.languages.count, id: \.self) { index in
                        Button {
                            self.nativeLanguage.language = STATIC.languages[index].language
                        } label: {
                            Text(STATIC.languages[index].name!)
                        }
                    }
                } label: {
                    Label(
                        title: {Text("Your Language: \(self.appBrain.getLanguageName(nativeLanguage.language) ?? "")")
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
                    handleData(nativeLanguage)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
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
    }
}

struct SetDefaultLanguageView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultLanguageView()
    }
}
