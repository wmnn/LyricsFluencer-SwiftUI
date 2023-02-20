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
    @State var targetLanguage = LanguageModel(language: "None", name: "Undefined")
    @EnvironmentObject var appBrain: AppBrain
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack{
            Color("appColor")
                .ignoresSafeArea()
            VStack{
                Menu{
                    ForEach(0..<STATIC.languages.count, id: \.self) { index in
                        Button {
                            self.targetLanguage.language = STATIC.languages[index].language
                            self.targetLanguage.name = STATIC.languages[index].name
                        } label: {
                            Text(STATIC.languages[index].name)
                        }
                    }
                } label: {
                    Label(
                        title: {Text("Target language: \(targetLanguage.name)")
                                .font(.system(size:24))
                                .bold()
                                .frame(width: 300, height: 20, alignment: .center)
                                .foregroundColor(Color.black)
                                .padding()
                                .background {
                                    Color("primaryColor")
                                }
                                .cornerRadius(18)
                        },
                        icon: { Image(systemName: "")}
                    )
                    
                }
                
                Button {
                    handleDefaultLanguage(targetLanguage)
                } label: {
                    Text("Save choosen language")
                    .font(.system(size:24))
                    .bold()
                    .frame(width: 300, height: 20, alignment: .center)
                    .foregroundColor(Color.black)
                    .padding()
                    .background {
                        Color("primaryColor")
                    }
                    .cornerRadius(18)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    func handleDefaultLanguage(_ targetLanguage: LanguageModel){
        let uid = getCurrentUser()
        if uid != ""{
            createDocumentWithUI(uid, targetLanguage)
            
            let defaults = UserDefaults.standard
            defaults.set(targetLanguage.language, forKey: "defaultLanguage")
            defaults.set(0, forKey: "requests")
            defaults.set(targetLanguage.name, forKey: "defaultLanguageName")
            defaults.set("free", forKey: "subscriptionPlan")
            appBrain.targetLanguage.language = targetLanguage.language
            appBrain.targetLanguage.name = targetLanguage.name
            path.append("Home")
        }
    }
    func getCurrentUser() -> String{
        guard let uid = Auth.auth().currentUser?.uid else{
            print("User not found")
            return ""
        }
        return uid
    }
    func createDocumentWithUI(_ uid: String, _ targetLanguage: LanguageModel){
        let data: [String: Any] = ["defaultLanguage": targetLanguage.language, "requests": 0, "subscriptionPlan": "free"]
        db.collection("users").document(uid).setData(data)
    }
}

struct SetDefaultLanguageView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultLanguageView(path: .constant(NavigationPath()))
    }
}
