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
    @State private var isDefaultLanguage = false
    @EnvironmentObject var appBrain: AppBrain
    
    var body: some View {
        ZStack{
            Color("appColor")
                .ignoresSafeArea()
            VStack{
                Menu{
                    ForEach(0..<Constants.languages.count, id: \.self) { index in
                        Button {
                            self.targetLanguage.language = Constants.languages[index].language
                            self.targetLanguage.name = Constants.languages[index].name
                        } label: {
                            Text(Constants.languages[index].name)
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
        .navigationDestination(isPresented: $isDefaultLanguage) {
            HomeView()
        }
    }
    func handleDefaultLanguage(_ targetLanguage: LanguageModel){
        let uid = getCurrentUser()
        if uid != ""{
            createDocumentWithUI(uid, targetLanguage)
            
            let defaults = UserDefaults.standard
            defaults.set(targetLanguage.language, forKey: "defaultLanguage") //Item like array
            defaults.set(targetLanguage.name, forKey: "defaultLanguageName")
            defaults.set("free", forKey: "subscriptionPlan")
            appBrain.targetLanguage.language = targetLanguage.language
            appBrain.targetLanguage.name = targetLanguage.name
            isDefaultLanguage = true
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
        DefaultLanguageView()
    }
}
