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
    @EnvironmentObject var appBrain: AppBrain
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
                    self.saveSettings()
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
            setStateVariables()
        }
    }
    
    func setStateVariables(){
        self.nativeLanguage.language = self.appBrain.user.nativeLanguage.language
        self.learnedLanguage.language = self.appBrain.user.learnedLanguage.language
    }
    
    func saveSettings(){
        let uid = FirebaseModel.getCurrentUser()
        let data: [String: Any] = ["nativeLanguage": self.nativeLanguage.language, "learnedLanguage" : self.learnedLanguage.language]
        //Save to firebase
        db.collection("users").document(uid).setData(data, merge: true)
        //Save into local Storage
        LocaleStorage.setValue(for: "nativeLanguage", value: self.nativeLanguage.language)
        LocaleStorage.setValue(for: "learnedLanguage", value: self.learnedLanguage.language)
        //Adapt changes to the app
        self.appBrain.user.nativeLanguage.language = self.nativeLanguage.language
        self.appBrain.user.learnedLanguage.language = self.learnedLanguage.language
        //Go back to Home View
        self.appBrain.path.removeLast()
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


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
                        handleDelete()
                    }, textColor: Color.red)
                    
                    
                }
            }
        }
    }
    func handleDelete(){
            let currentUser = Auth.auth().currentUser
            currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    // Handle error
                    print(error)
                    return;
                }
                let urlString = "\(STATIC.API_ROOT)/payment/account"
                if let url = URL(string: urlString){
                    let json: [String: String] = ["token": idToken ?? ""]
                    var request = URLRequest(url: url)
                    request.httpMethod = "DELETE"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json)
                    
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        if let err = error {
                            print("Error while sending request: \(err)")
                            return
                        }
                        
                        guard let data = data, let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                            print("Error while receiving response")
                            return
                        }
                        //print("Success: \(data)")
                        if let deleteAccountApiData: DeleteAccountApiData = AppBrain.parseData(data: data, dataModel: DeleteAccountApiData.self){
                            DispatchQueue.main.async {
                                Task {
                                    if deleteAccountApiData.status == 200 {
                                        appBrain.logout()
                                    }else{
                                        print("Error")
                                    }
                                }
                            }
                        }
                    }
                    task.resume()
                }
                
            }
        }
    
}

