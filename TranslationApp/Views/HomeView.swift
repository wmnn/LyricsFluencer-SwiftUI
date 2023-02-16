//
//  ContentView.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 12.02.23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct HomeView: View {
    let db = Firestore.firestore()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isRegistered = false
    @State private var isLoggedIn = false
    @State private var isSignUpLoading = false
    //@State private var path = NavigationPath() //creating a costum NavigationPath
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        NavigationStack() {
            ZStack{
                Color("appColor")
                    .ignoresSafeArea()
                
                VStack {
                    Text("Learn languages with music !")
                        .padding()
                        .bold()
                        .font(.system(size:32))
                        .foregroundColor(Color("textColor"))
                        .padding()
                        .cornerRadius(18)
                    
                    TextField(text: $email){
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
                    
                    
                    SecureField(text: $password){
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
                    
                    Button {
                        register()
                    } label: {
                        if isSignUpLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                .font(.system(size:24))
                                .bold()
                                .frame(width: 300, height: 20, alignment: .center)
                                .foregroundColor(Color.black)
                                .padding()
                                .background {
                                    Color("primaryColor")
                                }
                                .cornerRadius(18)
                        }else{
                            Text("Sign Up")
                                .bold()
                                .font(.system(size:18))
                                .frame(width: 300, height: 20, alignment: .center)
                                .foregroundColor(Color.black)
                                .padding()
                                .background {
                                    Color("primaryColor")
                                }
                                .cornerRadius(18)
                        }
                        
                    }
                    .navigationDestination(isPresented: $isRegistered) {
                        SetDefaultLanguageView()
                    }
                    .navigationDestination(isPresented: $isLoggedIn) {
                        LoggedInHomeView()
                    }
                    
                    Text("Already have an account?")
                        .padding()
                        .bold()
                        .font(.system(size:18))
                        .foregroundColor(Color("textColor"))
                        .padding()
                        .cornerRadius(18)
                    
                    NavigationLink(destination: LoginView()) {
                        HStack{
                            Text("Go to Login")
                            Image(systemName: "arrow.right")
                        }
                        .bold()
                        .font(.system(size:18))
                        .frame(width: 300, height: 20, alignment: .center)
                        .foregroundColor(Color.black)
                        .padding()
                        .background {
                            Color("primaryColor")
                        }
                        .cornerRadius(18)
                    }
                }//Closing H-Stack
            }//Closing Z-Stack
            .navigationBarBackButtonHidden(true)
        }//closing NavigationStack
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                print("App is active")
                //handleAutomaticNavigation()
                if Auth.auth().currentUser != nil {
                    print("User is logged in already")
                    self.isLoggedIn = true
                }
                
                //IF NO SUBSCRIPTION PLAN IS SAVED INSIDE THE LOCAL STORAGE MAKE AN API CALL
            case .inactive:
                print("App is inactive")
            case .background:
                print("App is in background")
            @unknown default:
                print("Interesting: Unexpected new value.")
            }
        }
    }//View
        
    
    
    func register(){
        self.isSignUpLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error{
                print(e.localizedDescription)
            }else{
                print("Registered")
                //Navigate to setDefaultLanguage
                self.isRegistered = true
            }
        }
        self.isSignUpLoading = false
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
