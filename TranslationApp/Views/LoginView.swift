//
//  LoginView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 12.02.23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {  
    @Binding var path: NavigationPath
    enum LoginField: Hashable {
        case email
        case password
    }
    @FocusState private var fieldInFocus: LoginField?
    let defaults = UserDefaults.standard
    let db = Firestore.firestore()
    @State var email: String = ""
    @State var password: String = ""
    @State var isLoading = false
    @EnvironmentObject var appBrain: AppBrain
    
    
    var body: some View {
        ZStack{
            Color("appColor")
                .ignoresSafeArea()
            
            VStack{
                Text("Login")
                    .padding()
                    .bold()
                    .font(.system(size:32))
                    .foregroundColor(Color("textColor"))
                    .padding()
                    .cornerRadius(18)
                
                TextField(text: self.$email){
                    Text("Email").foregroundColor(.gray)
                }
                    .font(.system(size:18))
                    .frame(width: 300, height: 20, alignment: .center)
                    .foregroundColor(Color.black)
                    .padding()
                    .background {
                        Color("inputColor")
                    }
                    .cornerRadius(18)
                    .cornerRadius(18)
                    .onSubmit {
                        fieldInFocus = .password
                    }
                    .submitLabel(SubmitLabel.next)
                    .focused($fieldInFocus ,equals: .email)
                    
                
                SecureField(text: self.$password){
                    Text("Password").foregroundColor(.gray)
                }
                    .font(.system(size:18))
                    .frame(width: 300, height: 20, alignment: .center)
                    .foregroundColor(Color.black)
                    .padding()
                    .background {
                        Color("inputColor")
                    }
                    .cornerRadius(18)
                    .onSubmit {
                        fieldInFocus = nil
                        login()
                    }
                    .submitLabel(SubmitLabel.done)
                    .focused($fieldInFocus ,equals: .password)
                
                Button {
                    self.fieldInFocus = nil
                    login()
                } label: {
                    if self.isLoading{
                        ActivityIndicator()
                    }else{
                        ButtonWithIcon(text: "Login", systemName: "arrow.right")
                    }
                    }
                
                .navigationTitle("Login")
            }
        }
    }
    func login(){
        self.isLoading = true
        Auth.auth().signIn(withEmail: self.email, password: self.password) { result, error in
            guard let user = result?.user, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                self.isLoading = false
                return
            }
            loadUserData(user.uid)
        }
    }
    func loadUserData(_ uid: String){
            db.collection("users").document(uid).getDocument { (document, error) in
                if let document = document, document.exists {
                    
                    let subscriptionPlan = document.get("subscriptionPlan") as? String ?? "none"
                    self.defaults.set(subscriptionPlan, forKey: "subscriptionPlan")
                    
                    if let requests = document.get("requests") as? Int{
                        self.defaults.set(requests, forKey: "requests")
                        if Int(requests) > 20 {
                            self.appBrain.isTrialExpired = true
                        }
                    }
                    if let defaultLanguage = document.get("defaultLanguage") as? String{
                        self.defaults.set(defaultLanguage, forKey: "defaultLanguage")
                        self.appBrain.targetLanguage.language = defaultLanguage
                        
                        let defaultLanguageName = getLanguageName(defaultLanguage)
                        self.defaults.set(defaultLanguageName, forKey: "defaultLanguageName")
                        self.appBrain.targetLanguage.name = defaultLanguageName!
                    }
                } else {
                    //print("Document does not exist")
                    //Navigate to set defaultLanguage
                }
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.handleNavigation()
                }
            }
    }
    func getLanguageName(_ languageCode: String) -> String?{
        for language in STATIC.languages {
            if language.language == languageCode {
                return language.name
            }
        }
        return nil
    }
    func getCurrentUser() -> String{
        guard let uid = Auth.auth().currentUser?.uid else{
            print("User not found")
            return ""
        }
        return uid
    }
    func handleNavigation(){
        let subscriptionPlan = defaults.string(forKey: "subscriptionPlan")
        if subscriptionPlan != nil{
            if(subscriptionPlan == "none"){
                path.append("DefaultLanguage")
            }else{
                path.append("Home")
            }
        }else{
                path.append("DefaultLanguage")
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(path: .constant(NavigationPath()))
    }
}
