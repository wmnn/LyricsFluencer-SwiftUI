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
    enum LoginField: Hashable {
        case email
        case password
        case none
    }
    @FocusState private var fieldInFocus: LoginField?
    let defaults = UserDefaults.standard
    let db = Firestore.firestore()
    @State var email: String = ""
    @State var password: String = ""
    @EnvironmentObject var appBrain: AppBrain
    @State var isLoginLoading = false
    
    
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
                        login(email: email, password: password)
                    }
                    .submitLabel(SubmitLabel.done)
                    .focused($fieldInFocus ,equals: .password)
                
                Button {
                    self.fieldInFocus = LoginField.none
                    login(email: email, password: password)
                } label: {
                    if self.isLoginLoading{
                        ActivityIndicator()
                    }else{
                        TextWithIcon(text: "Login", systemName: "arrow.right")
                    }
                }
                .navigationTitle("Login")
            }
        }
    }
    func login(email: String, password: String){
        self.isLoginLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard let user = result?.user, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                self.isLoginLoading = false
                return
            }
            self.fetchingUserData(user.uid)
        }
    }
    func fetchingUserData(_ uid: String){
            db.collection("users").document(uid).getDocument { (document, error) in
                if let document = document, document.exists {
                    let subscriptionPlan = document.get("subscriptionPlan") as? String ?? "none"
                    self.defaults.set(subscriptionPlan, forKey: "subscriptionPlan")
                    
                    if let requests = document.get("requests") as? Int{
                        self.defaults.set(requests, forKey: "requests")
                        self.appBrain.handleTrial()
                    }
                    if let defaultLanguage = document.get("defaultLanguage") as? String{
                        self.defaults.set(defaultLanguage, forKey: "defaultLanguage")
                        self.appBrain.targetLanguage.language = defaultLanguage
                        
                        let defaultLanguageName = self.appBrain.getLanguageName(defaultLanguage)
                        self.defaults.set(defaultLanguageName, forKey: "defaultLanguageName")
                        self.appBrain.targetLanguage.name = defaultLanguageName!
                    }
                    
                    DispatchQueue.main.async {
                        self.appBrain.fetchingDecks()
                        self.isLoginLoading = false
                        self.handleLoginNavigation()
                    }
                } else {
                    //print("Document does not exist")
                    //Navigate to set defaultLanguage
                }
            }
    }
    

    
    func handleLoginNavigation(){
        let subscriptionPlan = defaults.string(forKey: "subscriptionPlan")
        if subscriptionPlan != nil{
            if(subscriptionPlan == "none"){
                appBrain.path.append("DefaultLanguage")
            }else{
                appBrain.path.append("Home")
            }
        }else{
                appBrain.path.append("DefaultLanguage")
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
